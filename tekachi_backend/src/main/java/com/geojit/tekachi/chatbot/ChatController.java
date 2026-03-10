package com.geojit.tekachi.chatbot;

import com.geojit.tekachi.chatbot.RAG.entity.DocumentChunk;
import com.geojit.tekachi.chatbot.RAG.repo.ChunkRepository;
import com.geojit.tekachi.chatbot.dtos.*;
import com.geojit.tekachi.chatbot.entity.*;
import com.geojit.tekachi.chatbot.repo.ConvoRepo;
import com.geojit.tekachi.chatbot.repo.MsgRepo;
import com.geojit.tekachi.chatbot.repo.PersonaRepo;
import com.geojit.tekachi.usersignin.OpenAiService;
import com.geojit.tekachi.usersignin.entity.User;
import com.geojit.tekachi.usersignin.repository.UserRepository;

import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.*;

/*
User presses start
↓
Create conversation row
↓
Call LLM with persona + greeting instruction + relevant chunks for random topic
↓
Return LLM response and first question
↓
User sends response message 
↓
Store user message
↓
Load last N messages
↓
Build payload (persona + history + new msg + chunks for follow-up question)
↓
Call LLM and deliver prompt payload
↓
Store assistant reply
↓
Return LLM response
*/

@RestController
@RequestMapping("/chat")
public class ChatController {

    private final OpenAiService openAiService;
    private final ConvoRepo convoRepo;
    private final MsgRepo msgRepo;
    private final PersonaRepo personaRepo;
    private final ChunkRepository chunkRepository;
    private final UserRepository userRepository;

    private final List<String> topicArray = List.of(
            "Database System Architecture",
            "Three-Level Architecture",
            "ER Model and Keys",
            "Relational Algebra",
            "DDL, DML, DCL",
            "Joins and Subqueries",
            "ACID",
            "Deadlocks",
            "Sorting",
            "Trees",
            "Graphs",
            "Graph Traversals",
            "Stack",
            "Queue",
            "Object-Oriented Concepts",
            "Overloading and Overriding",
            "Inheritance and Multilevel Hierarchy",
            "Packages and Interfaces",
            "Exception Handling",
            "Multithreaded Programming",
            "Event Handling",
            "AWT",
            "UML",
            "Data Abstraction",
            "Encapsulation and Data Hiding",
            "Functions of an Operating System",
            "Types of Operating Systems",
            "Processes",
            "Multithreading",
            "CPU Scheduling",
            "Inter Process Communication",
            "Memory Management",
            "Disk Scheduling Algorithms");

    public ChatController(OpenAiService openAiService,
            ConvoRepo convoRepo,
            MsgRepo msgRepo,
            PersonaRepo personaRepo,
            ChunkRepository chunkRepository,
            UserRepository userRepository) {
        this.openAiService = openAiService;
        this.convoRepo = convoRepo;
        this.msgRepo = msgRepo;
        this.personaRepo = personaRepo;
        this.chunkRepository = chunkRepository;
        this.userRepository = userRepository;
    }

    @PostMapping("/start")
    public StartResponse startConversation(@RequestBody StartRequest request) {
        Long authenticatedUserId = getAuthenticatedUserId();
        if (request.getUserId() != null && !Objects.equals(request.getUserId(), authenticatedUserId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Cannot start conversation for another user");
        }

        Persona persona = personaRepo.findById(request.getPersonaId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Persona not found"));

        Conversation conversation = new Conversation();
        conversation.setUserId(authenticatedUserId);
        conversation.setPersona(persona);

        if (persona.getPersonaId() == 2) {
            // Select random topic
            String selectedTopic = topicArray.get(new Random().nextInt(topicArray.size()));
            conversation.setCurrentTopic(selectedTopic);

            convoRepo.save(conversation);

            // Fetch chunks
            List<DocumentChunk> chunks = chunkRepository.findTop5ByTopic(selectedTopic);
            String chunkText = buildChunkText(chunks);

            List<OpenAiMsg> messages = new ArrayList<>();
            messages.add(new OpenAiMsg("system", persona.getSystemPrompt()));
            messages.add(new OpenAiMsg("system",
                    "Use the reference material given to ask a technical interview question."));
            messages.add(new OpenAiMsg("system", chunkText));
            messages.add(new OpenAiMsg("user", "Start the interview."));

            String response = openAiService.getChatResponse(messages);

            saveAssistantMessage(conversation.getConversationId(), response);

            return new StartResponse(conversation.getConversationId(), response);
        }

        convoRepo.save(conversation);

        List<OpenAiMsg> messages = new ArrayList<>();
        messages.add(new OpenAiMsg("system", persona.getSystemPrompt()));
        messages.add(new OpenAiMsg("user", "Start the interview."));

        String response = openAiService.getChatResponse(messages);

        saveAssistantMessage(conversation.getConversationId(), response);

        return new StartResponse(conversation.getConversationId(), response);
    }

    // SEND MESSAGE
    @PostMapping("/{conversationId}/tech/message")
    public MessageResponse sendTechMessage(
            @PathVariable Integer conversationId,
            @RequestBody MessageRequest request) {

        Conversation conversation = findOwnedConversation(conversationId);

        Persona persona = personaRepo
                .findByPersonaIdAndIsActiveTrue(conversation.getPersona().getPersonaId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Persona not found"));

        if (request.getContent() == null || request.getContent().isBlank()) {
            throw new IllegalArgumentException("Message cannot be empty");
        }

        saveUserMessage(conversationId, request.getContent());

        // 2️⃣ Fetch last 10 messages
        List<Message> history = msgRepo.findRecentMessages(conversationId, PageRequest.of(0, 10));

        Collections.reverse(history);

        // 3️⃣ Build OpenAI payload
        List<OpenAiMsg> openAiMsgs = new ArrayList<>();

        // 1️⃣ Persona
        openAiMsgs.add(new OpenAiMsg("system", persona.getSystemPrompt()));

        // 2️⃣ Inject topic chunks
        String topic = conversation.getCurrentTopic();
        List<DocumentChunk> chunks = chunkRepository.findTop5ByTopic(topic);
        String chunkText = buildChunkText(chunks);

        openAiMsgs.add(new OpenAiMsg("system",
                "Refer to the following reference material when asking conceptual questions. "
                        + "If transitioning/currently asking about coding or performing final evaluation, you may ignore it."));

        openAiMsgs.add(new OpenAiMsg("system", chunkText));

        for (Message msg : history) {
            openAiMsgs.add(new OpenAiMsg(
                    msg.getRole().name().toLowerCase(),
                    msg.getContent()));
        }

        String response = openAiService.getChatResponse(openAiMsgs);

        // 5️⃣ Store assistant reply
        saveAssistantMessage(conversationId, response);

        return new MessageResponse(response);
    }

    @PostMapping("/{conversationId}/hrmentor/message")
    public MessageResponse sendHrMentorMessage(
            @PathVariable Integer conversationId,
            @RequestBody MessageRequest request) {

        Conversation conversation = findOwnedConversation(conversationId);

        Persona persona = personaRepo
                .findByPersonaIdAndIsActiveTrue(conversation.getPersona().getPersonaId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Persona not found"));

        if (request.getContent() == null || request.getContent().isBlank()) {
            throw new IllegalArgumentException("Message cannot be empty");
        }

        saveUserMessage(conversationId, request.getContent());

        // 2️⃣ Fetch last 10 messages
        List<Message> history = msgRepo.findRecentMessages(conversationId, PageRequest.of(0, 10));

        Collections.reverse(history);

        // 3️⃣ Build OpenAI payload
        List<OpenAiMsg> openAiMsgs = new ArrayList<>();

        // 1️⃣ Persona
        openAiMsgs.add(new OpenAiMsg("system", persona.getSystemPrompt()));

        for (Message msg : history) {
            openAiMsgs.add(new OpenAiMsg(
                    msg.getRole().name().toLowerCase(),
                    msg.getContent()));
        }

        String response = openAiService.getChatResponse(openAiMsgs);

        // 5️⃣ Store assistant reply
        saveAssistantMessage(conversationId, response);

        return new MessageResponse(response);
    }

    @PostMapping("/{conversationId}/messages/verdict")
    public String getVerdict(@PathVariable Integer conversationId, @RequestBody MessageRequest request) {

        Conversation conversation = findOwnedConversation(conversationId);

        Persona persona = personaRepo
                .findByPersonaIdAndIsActiveTrue(conversation.getPersona().getPersonaId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Persona not found"));

        saveUserMessage(conversationId, request.getContent());

        List<Message> history = msgRepo.findRecentMessages(conversationId, PageRequest.of(0, 100));
        Collections.reverse(history);

        List<OpenAiMsg> openAiMsgs = new ArrayList<>();

        openAiMsgs.add(new OpenAiMsg("system", persona.getSystemPrompt()));

        for (Message msg : history) {
            openAiMsgs.add(new OpenAiMsg(
                    msg.getRole().name().toLowerCase(),
                    msg.getContent()));
        }

        String response = openAiService.getVerdict(openAiMsgs);

        // 5️⃣ Store assistant reply
        saveAssistantMessage(conversationId, response);

        // Save verdict to conversation
        String verdict = response.trim().toUpperCase();
        saveVerdictMessage(conversationId, verdict);

        return verdict;
    }

    @GetMapping("/conversations/{userId}/{personaId}")
    public List<ConvoHistory> getConversations(@PathVariable Long userId,
            @PathVariable Integer personaId) {
        enforceCurrentUser(userId);

        List<ConvoHistory> history = convoRepo.findByUserId(userId).stream()
                .filter(conversation -> Objects.equals(conversation.getPersona().getPersonaId(), personaId))
                .map(conversation -> new ConvoHistory(
                        conversation.getConversationId(),
                        conversation.getCreatedAt(),
                        conversation.getPersona().getPersonaId(),
                        conversation.getUserId(),
                        conversation.getVerdict()))
                .toList();

        return history;
    }

    @GetMapping("/{conversationId}/messages")
    public List<Message> getMessages(@PathVariable Integer conversationId) {
        findOwnedConversation(conversationId);

        List<Message> chat = msgRepo.findRecentMessages(conversationId, PageRequest.of(0, 100));
        Collections.reverse(chat);
        return chat;
    }

    @Transactional
    @DeleteMapping("/conversations/{userId}/{personaId}/clear")
    public void clearConversations(@PathVariable Long userId,
            @PathVariable Integer personaId) {
        enforceCurrentUser(userId);

        List<Conversation> conversations = convoRepo.findByUserId(userId).stream()
                .filter(conversation -> Objects.equals(conversation.getPersona().getPersonaId(), personaId))
                .toList();

        for (Conversation convo : conversations) {
            clearMessages(convo.getConversationId());
            convoRepo.delete(convo);
        }
    }

    @Transactional
    @DeleteMapping("/{conversationId}/messages/clear")
    public void clearMessages(@PathVariable Integer conversationId) {
        findOwnedConversation(conversationId);

        msgRepo.deleteByConversationId(conversationId);
    }

    private Conversation findOwnedConversation(Integer conversationId) {
        Conversation conversation = convoRepo.findById(conversationId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Conversation not found"));

        Long authenticatedUserId = getAuthenticatedUserId();
        if (!Objects.equals(conversation.getUserId(), authenticatedUserId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Conversation does not belong to this user");
        }
        return conversation;
    }

    private void enforceCurrentUser(Long userId) {
        Long authenticatedUserId = getAuthenticatedUserId();
        if (!Objects.equals(userId, authenticatedUserId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Cannot access another user's conversation data");
        }
    }

    private Long getAuthenticatedUserId() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByEmail(email);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Authenticated user not found");
        }
        return user.getId();
    }

    private String buildChunkText(List<DocumentChunk> chunks) {
        StringBuilder sb = new StringBuilder();
        sb.append("Reference Material:\n");

        for (DocumentChunk chunk : chunks) {
            sb.append("\n---\n");
            sb.append(chunk.getContent());
        }

        return sb.toString();
    }

    private void saveAssistantMessage(Integer conversationId, String content) {
        Message assistantMsg = new Message();
        assistantMsg.setConversationId(conversationId);
        assistantMsg.setRole(Role.ASSISTANT);
        assistantMsg.setContent(content);
        msgRepo.save(assistantMsg);
    }

    private void saveUserMessage(Integer conversationId, String content) {
        Message userMsg = new Message();
        userMsg.setConversationId(conversationId);
        userMsg.setRole(Role.USER);
        userMsg.setContent(content);
        msgRepo.save(userMsg);
    }

    private void saveVerdictMessage(Integer conversationId, String verdict) {
        Conversation conversation = convoRepo.findById(conversationId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Conversation not found"));

        conversation.setVerdict(verdict);
        convoRepo.save(conversation);
    }

}
