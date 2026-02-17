package com.geojit.tekachi.chatbot.dtos;

import java.util.List;

public record ChatRequest(String model, List<OpenAiMsg> messages) {
}
