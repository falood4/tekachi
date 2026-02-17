package com.geojit.tekachi.chatbot.dtos;

public class StartResponse {

    private Integer conversationId;
    private String greeting;

    public StartResponse(Integer conversationId, String greeting) {
        this.conversationId = conversationId;
        this.greeting = greeting;
    }

    public Integer getConversationId() {
        return conversationId;
    }

    public String getGreeting() {
        return greeting;
    }
}
