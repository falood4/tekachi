package com.geojit.tekachi.chatbot;

import com.geojit.tekachi.chatbot.RAG.entity.DocumentChunk;
import com.geojit.tekachi.chatbot.RAG.repo.ChunkRepository;
import com.geojit.tekachi.chatbot.dtos.MessageRequest;
import com.geojit.tekachi.chatbot.dtos.StartRequest;
import com.geojit.tekachi.chatbot.dtos.StartResponse;
import com.geojit.tekachi.chatbot.entity.Conversation;
import com.geojit.tekachi.chatbot.entity.Message;
import com.geojit.tekachi.chatbot.entity.Persona;
import com.geojit.tekachi.chatbot.entity.Role;
import com.geojit.tekachi.chatbot.repo.ConvoRepo;
import com.geojit.tekachi.chatbot.repo.MsgRepo;
import com.geojit.tekachi.chatbot.repo.PersonaRepo;
import com.geojit.tekachi.usersignin.entity.User;
import com.geojit.tekachi.usersignin.repository.UserRepository;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ChatControllerTest {

    @Mock
    private OpenAiService openAiService;

    @Mock
    private ConvoRepo convoRepo;

    @Mock
    private MsgRepo msgRepo;

    @Mock
    private PersonaRepo personaRepo;

    @Mock
    private ChunkRepository chunkRepository;

    @Mock
    private UserRepository userRepository;

    @AfterEach
    void tearDown() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void startConversationRejectsUserMismatch() {
        ChatController controller = new ChatController(
                openAiService, convoRepo, msgRepo, personaRepo, chunkRepository, userRepository);
        setAuthenticatedUser("alice@example.com", 1L);

        StartRequest request = new StartRequest();
        request.setUserId(2L);
        request.setPersonaId(1);

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> controller.startConversation(request));

        assertEquals(HttpStatus.FORBIDDEN, ex.getStatusCode());
    }

    @Test
    void startConversationThrowsWhenPersonaMissing() {
        ChatController controller = new ChatController(
                openAiService, convoRepo, msgRepo, personaRepo, chunkRepository, userRepository);
        setAuthenticatedUser("alice@example.com", 1L);

        StartRequest request = new StartRequest();
        request.setUserId(1L);
        request.setPersonaId(99);

        when(personaRepo.findById(99)).thenReturn(Optional.empty());

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> controller.startConversation(request));

        assertEquals(HttpStatus.NOT_FOUND, ex.getStatusCode());
    }

    @Test
    void startConversationForTechPersonaUsesChunksAndSavesAssistantMessage() {
        ChatController controller = new ChatController(
                openAiService, convoRepo, msgRepo, personaRepo, chunkRepository, userRepository);
        setAuthenticatedUser("alice@example.com", 1L);

        Persona persona = new Persona();
        persona.setPersonaId(2);
        persona.setSystemPrompt("You are a tech interviewer");

        when(personaRepo.findById(2)).thenReturn(Optional.of(persona));
        doAnswer(invocation -> {
            Conversation c = invocation.getArgument(0);
            if (c.getConversationId() == null) {
                c.setConversationId(10);
            }
            return c;
        }).when(convoRepo).save(any(Conversation.class));

        DocumentChunk chunk = new DocumentChunk();
        chunk.setContent("Reference line");
        when(chunkRepository.findTop5ByTopic(anyString())).thenReturn(List.of(chunk));
        when(openAiService.getChatResponse(anyList())).thenReturn("Welcome");

        StartRequest request = new StartRequest();
        request.setUserId(1L);
        request.setPersonaId(2);

        StartResponse response = controller.startConversation(request);

        assertEquals(10, response.getConversationId());
        assertEquals("Welcome", response.getGreeting());
        verify(chunkRepository).findTop5ByTopic(anyString());

        ArgumentCaptor<Message> messageCaptor = ArgumentCaptor.forClass(Message.class);
        verify(msgRepo).save(messageCaptor.capture());
        assertEquals(Role.ASSISTANT, messageCaptor.getValue().getRole());
        assertEquals("Welcome", messageCaptor.getValue().getContent());
        assertEquals(10, messageCaptor.getValue().getConversationId());
    }

    @Test
    void startConversationForNonTechPersonaSkipsChunkLookup() {
        ChatController controller = new ChatController(
                openAiService, convoRepo, msgRepo, personaRepo, chunkRepository, userRepository);
        setAuthenticatedUser("alice@example.com", 1L);

        Persona persona = new Persona();
        persona.setPersonaId(1);
        persona.setSystemPrompt("HR interviewer");

        when(personaRepo.findById(1)).thenReturn(Optional.of(persona));
        doAnswer(invocation -> {
            Conversation c = invocation.getArgument(0);
            c.setConversationId(20);
            return c;
        }).when(convoRepo).save(any(Conversation.class));
        when(openAiService.getChatResponse(anyList())).thenReturn("Hello");

        StartRequest request = new StartRequest();
        request.setUserId(1L);
        request.setPersonaId(1);

        StartResponse response = controller.startConversation(request);

        assertEquals(20, response.getConversationId());
        assertEquals("Hello", response.getGreeting());
        verify(chunkRepository, never()).findTop5ByTopic(anyString());
    }

    @Test
    void sendTechMessageRejectsBlankMessage() {
        ChatController controller = new ChatController(
                openAiService, convoRepo, msgRepo, personaRepo, chunkRepository, userRepository);
        setAuthenticatedUser("alice@example.com", 1L);

        Conversation conversation = ownedConversation(5, 1L, 2);
        when(convoRepo.findById(5)).thenReturn(Optional.of(conversation));
        when(personaRepo.findByPersonaIdAndIsActiveTrue(2)).thenReturn(Optional.of(conversation.getPersona()));

        MessageRequest request = new MessageRequest();
        request.setContent("   ");

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class,
                () -> controller.sendTechMessage(5, request));

        assertEquals("Message cannot be empty", ex.getMessage());
    }

    @Test
    void sendTechMessageRejectsConversationOwnedByAnotherUser() {
        ChatController controller = new ChatController(
                openAiService, convoRepo, msgRepo, personaRepo, chunkRepository, userRepository);
        setAuthenticatedUser("alice@example.com", 1L);

        Conversation conversation = ownedConversation(5, 2L, 2);
        when(convoRepo.findById(5)).thenReturn(Optional.of(conversation));

        MessageRequest request = new MessageRequest();
        request.setContent("hello");

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> controller.sendTechMessage(5, request));

        assertEquals(HttpStatus.FORBIDDEN, ex.getStatusCode());
    }

    @Test
    void getVerdictUppercasesAndPersistsConversationVerdict() {
        ChatController controller = new ChatController(
                openAiService, convoRepo, msgRepo, personaRepo, chunkRepository, userRepository);
        setAuthenticatedUser("alice@example.com", 1L);

        Conversation conversation = ownedConversation(8, 1L, 1);
        when(convoRepo.findById(8)).thenReturn(Optional.of(conversation));
        when(personaRepo.findByPersonaIdAndIsActiveTrue(1)).thenReturn(Optional.of(conversation.getPersona()));
        when(msgRepo.findRecentMessages(anyInt(), any(Pageable.class))).thenReturn(List.of());
        when(openAiService.getVerdict(anyList())).thenReturn("hired ");

        MessageRequest request = new MessageRequest();
        request.setContent("final answer");

        String verdict = controller.getVerdict(8, request);

        assertEquals("HIRED", verdict);
        verify(msgRepo, times(2)).save(any(Message.class));

        ArgumentCaptor<Conversation> convoCaptor = ArgumentCaptor.forClass(Conversation.class);
        verify(convoRepo).save(convoCaptor.capture());
        assertEquals("HIRED", convoCaptor.getValue().getVerdict());
    }

    @Test
    void clearConversationsRejectsOtherUsers() {
        ChatController controller = new ChatController(
                openAiService, convoRepo, msgRepo, personaRepo, chunkRepository, userRepository);
        setAuthenticatedUser("alice@example.com", 1L);

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> controller.clearConversations(2L, 1));

        assertEquals(HttpStatus.FORBIDDEN, ex.getStatusCode());
    }

    @Test
    void clearMessagesDeletesMessagesForOwnedConversation() {
        ChatController controller = new ChatController(
                openAiService, convoRepo, msgRepo, personaRepo, chunkRepository, userRepository);
        setAuthenticatedUser("alice@example.com", 1L);

        when(convoRepo.findById(9)).thenReturn(Optional.of(ownedConversation(9, 1L, 1)));

        controller.clearMessages(9);

        verify(msgRepo).deleteByConversationId(9);
    }

    private Conversation ownedConversation(Integer id, Long userId, Integer personaId) {
        Persona persona = new Persona();
        persona.setPersonaId(personaId);
        persona.setSystemPrompt("system");

        Conversation conversation = new Conversation();
        conversation.setConversationId(id);
        conversation.setUserId(userId);
        conversation.setPersona(persona);
        return conversation;
    }

    private void setAuthenticatedUser(String email, Long id) {
        UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(email, null, List.of());
        SecurityContextHolder.getContext().setAuthentication(auth);

        User user = new User();
        user.setId(id);
        user.setEmail(email);
        when(userRepository.findByEmail(email)).thenReturn(user);
        assertNotNull(SecurityContextHolder.getContext().getAuthentication());
    }
}
