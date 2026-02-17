package com.geojit.tekachi.chatbot;

import com.geojit.tekachi.chatbot.dtos.*;
import com.geojit.tekachi.chatbot.entity.*;
import com.geojit.tekachi.chatbot.repo.ConvoRepo;
import com.geojit.tekachi.chatbot.repo.MsgRepo;
import com.geojit.tekachi.chatbot.repo.PersonaRepo;

import org.springframework.data.domain.PageRequest;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/*
User presses start
↓
Create conversation row
↓
Call LLM with persona + greeting instruction
↓
Store assistant greeting
↓
Return LLM response
↓
User sends response message
↓
Store user message
↓
Load last N messages
↓
Build payload (persona + history + new msg)
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

    public ChatController(OpenAiService openAiService,
            ConvoRepo convoRepo,
            MsgRepo msgRepo,
            PersonaRepo personaRepo) {
        this.openAiService = openAiService;
        this.convoRepo = convoRepo;
        this.msgRepo = msgRepo;
        this.personaRepo = personaRepo;
    }

    // START CONVERSATION
    @PostMapping("/start")
    public StartResponse startConversation(@RequestBody StartRequest request) {

        Persona persona = personaRepo
                .findByPersonaIdAndIsActiveTrue(request.getPersonaId())
                .orElseThrow(() -> new RuntimeException("Invalid or inactive persona"));

        Conversation conversation = new Conversation();
        conversation.setUserId(request.getUserId());
        conversation.setPersona(persona);
        convoRepo.save(conversation);

        // 2️⃣ Build OpenAI messages
        List<OpenAiMsg> messages = List.of(
                new OpenAiMsg("system", persona.getSystemPrompt()),
                new OpenAiMsg("user", persona.getGreetingInstruction()));

        String greeting = openAiService.getChatResponse(messages);

        Message assistantMsg = new Message();
        assistantMsg.setConversationId(conversation.getConversationId());
        assistantMsg.setRole(Role.ASSISTANT);
        assistantMsg.setContent(greeting);
        msgRepo.save(assistantMsg);

        return new StartResponse(conversation.getConversationId(), greeting);
    }

    // SEND MESSAGE
    @PostMapping("/{conversationId}/message")
    public MessageResponse sendMessage(
            @PathVariable Integer conversationId,
            @RequestBody MessageRequest request) {

        Conversation conversation = convoRepo.findById(conversationId)
                .orElseThrow(() -> new RuntimeException("Conversation not found"));

        Persona persona = personaRepo
                .findByPersonaIdAndIsActiveTrue(conversation.getPersona().getPersonaId())
                .orElseThrow(() -> new RuntimeException("Persona not found"));

        Message userMsg = new Message();
        if (request.getContent() == null || request.getContent().isBlank()) {
            throw new IllegalArgumentException("Message cannot be empty");
        }

        userMsg.setConversationId(conversationId);
        userMsg.setRole(Role.USER);
        userMsg.setContent(request.getContent());
        msgRepo.save(userMsg);

        // 2️⃣ Fetch last 10 messages
        List<Message> history = msgRepo.findRecentMessages(conversationId, PageRequest.of(0, 10));

        Collections.reverse(history);

        // 3️⃣ Build OpenAI payload
        List<OpenAiMsg> openAiMsgs = new ArrayList<>();
        openAiMsgs.add(new OpenAiMsg("system", persona.getSystemPrompt()));

        for (Message msg : history) {
            openAiMsgs.add(new OpenAiMsg(
                    msg.getRole().name().toLowerCase(),
                    msg.getContent()));
        }

        String response = openAiService.getChatResponse(openAiMsgs);

        // 5️⃣ Store assistant reply
        Message assistantMsg = new Message();
        assistantMsg.setConversationId(conversationId);
        assistantMsg.setRole(Role.ASSISTANT);
        assistantMsg.setContent(response);
        msgRepo.save(assistantMsg);

        return new MessageResponse(response);
    }
}
