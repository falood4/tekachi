package com.geojit.tekachi.chatbot;

import com.geojit.tekachi.chatbot.dtos.ChatRequest;
import com.geojit.tekachi.chatbot.dtos.OpenAiMsg;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.List;
import java.util.Map;

@Service
public class OpenAiService {

    private final WebClient webClient;
    private final String model;

    public OpenAiService(
            @Value("${openrouter.api.key}") String apiKey,
            @Value("${openrouter.model:deepseek/deepseek-v3.2}") String model) {

        this.model = model;
        this.webClient = WebClient.builder()
                .baseUrl("https://openrouter.ai/api/v1")
                .defaultHeader("Authorization", "Bearer " + apiKey)
                .defaultHeader("Content-Type", "application/json")
                .build();
    }

    @SuppressWarnings("rawtypes")
public String getChatResponse(List<OpenAiMsg> messages) {

        ChatRequest request = new ChatRequest(model, messages);

        Map response = webClient.post()
                .uri("/chat/completions")
                .bodyValue(request)
                .retrieve()
                .onStatus(status -> status.isError(), clientResponse -> clientResponse.bodyToMono(String.class)
                        .map(body -> new RuntimeException("OpenRouter Error: " + body)))
                .bodyToMono(Map.class)
                .block();

        List choices = (List) response.get("choices");
        Map firstChoice = (Map) choices.get(0);
        Map message = (Map) firstChoice.get("message");

        return (String) message.get("content");
    }
}