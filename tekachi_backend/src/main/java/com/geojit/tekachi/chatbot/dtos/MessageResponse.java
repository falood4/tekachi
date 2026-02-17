package com.geojit.tekachi.chatbot.dtos;

public class MessageResponse {

    private String reply;

    public MessageResponse(String reply) {
        this.reply = reply;
    }

    public String getReply() {
        return reply;
    }
}
