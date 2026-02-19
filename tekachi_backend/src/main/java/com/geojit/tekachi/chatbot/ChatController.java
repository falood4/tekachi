package com.geojit.tekachi.chatbot;

import com.geojit.tekachi.chatbot.RAG.entity.DocumentChunk;
import com.geojit.tekachi.chatbot.RAG.repo.ChunkRepository;
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
            "Sorting Techniques",
            "Trees",
            "Graphs",
            "Graph Traversal and Algorithms",
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
            PersonaRepo personaRepo, ChunkRepository chunkRepository) {
        this.openAiService = openAiService;
        this.convoRepo = convoRepo;
        this.msgRepo = msgRepo;
        this.personaRepo = personaRepo;
        this.chunkRepository = chunkRepository;
    }

    @PostMapping("/start")
    public StartResponse startConversation(@RequestBody StartRequest request) {

        Persona persona = personaRepo.findById(request.getPersonaId())
                .orElseThrow();

        Conversation conversation = new Conversation();
        conversation.setUserId(request.getUserId());
        conversation.setPersona(persona);

        // Select random topic
        String selectedTopic = topicArray.get(new Random().nextInt(topicArray.size()));
        conversation.setCurrentTopic(selectedTopic); // recommend adding column

        convoRepo.save(conversation);

        // Fetch chunks
        List<DocumentChunk> chunks = chunkRepository.findTop5ByTopic(selectedTopic);
        String chunkText = buildChunkText(chunks);

        List<OpenAiMsg> messages = new ArrayList<>();
        messages.add(new OpenAiMsg("system", persona.getSystemPrompt()));
        messages.add(new OpenAiMsg("system",
                "Use ONLY the reference material below to conduct the interview."));
        messages.add(new OpenAiMsg("system", chunkText));
        messages.add(new OpenAiMsg("user", "Start the interview."));

        String response = openAiService.getChatResponse(messages);

        saveAssistantMessage(conversation.getConversationId(), response);

        return new StartResponse(conversation.getConversationId(), response);
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
                        + "If transitioning to coding or evaluation, you may ignore it."));

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

}
