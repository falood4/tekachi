package com.geojit.tekachi.usersignin;

import com.geojit.tekachi.chatbot.OpenAiServiceException;
import com.geojit.tekachi.chatbot.dtos.ChatRequest;
import com.geojit.tekachi.chatbot.dtos.OpenAiMsg;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
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
                        @Value("${openrouter.model:google/gemini-2.5-flash}") String model) {

                this.model = model;
                this.webClient = WebClient.builder()
                                .baseUrl("https://openrouter.ai/api/v1")
                                .defaultHeader("Authorization", "Bearer " + apiKey)
                                .defaultHeader("Content-Type", "application/json")
                                .build();
        }

        public String getChatResponse(List<OpenAiMsg> messages) {

                try {
                        ChatRequest request = new ChatRequest(model, messages);

                        Map<String, Object> response = webClient.post()
                                        .uri("/chat/completions")
                                        .bodyValue(request)
                                        .retrieve()
                                        .onStatus(status -> status.isError(),
                                                        clientResponse -> clientResponse.bodyToMono(String.class)
                                                                        .map(body -> new OpenAiServiceException(
                                                                                        "OpenRouter Error: " + body,
                                                                                        null,
                                                                                        false)))
                                        .bodyToMono(new ParameterizedTypeReference<Map<String, Object>>() {
                                        })
                                        .block();

                        return extractContentFromResponse(response);
                } catch (OpenAiServiceException e) {
                        throw e;
                } catch (Exception e) {
                        throw new OpenAiServiceException("Failed to fetch chat response from OpenRouter", e, true);
                }
        }

        public String getVerdict(List<OpenAiMsg> messages) {
                try {
                        ChatRequest request = new ChatRequest(model, List.of(new OpenAiMsg("system",
                                        "The interview has concluded. You must now verdict the user's potential as a candidate based on their perfomance. If you have already given a final reccomendation then repeat it."),
                                        new OpenAiMsg("user",
                                                        "Provide a ONE-WORD response for candidate: HIRED or NON-HIRED. Consider the candidate's performance in the interview and provide your verdict.")));

                        Map<String, Object> response = webClient.post()
                                        .uri("/chat/completions")
                                        .bodyValue(request)
                                        .retrieve()
                                        .onStatus(status -> status.isError(),
                                                        clientResponse -> clientResponse.bodyToMono(String.class)
                                                                        .map(body -> new OpenAiServiceException(
                                                                                        "OpenRouter Error: " + body,
                                                                                        null,
                                                                                        false)))
                                        .bodyToMono(new ParameterizedTypeReference<Map<String, Object>>() {
                                        })
                                        .block();

                        return extractContentFromResponse(response);
                } catch (OpenAiServiceException e) {
                        throw e;
                } catch (Exception e) {
                        throw new OpenAiServiceException("Failed to fetch chat response from OpenRouter", e, true);
                }
        }

        private String extractContentFromResponse(Map<String, Object> response) {
                if (response == null) {
                        throw new OpenAiServiceException("OpenRouter returned an empty response", null, true);
                }

                Object choicesObj = response.get("choices");
                if (!(choicesObj instanceof List<?> choices) || choices.isEmpty()) {
                        throw new OpenAiServiceException("OpenRouter response missing choices", null, true);
                }

                Object firstChoiceObj = choices.get(0);
                if (!(firstChoiceObj instanceof Map<?, ?> firstChoice)) {
                        throw new OpenAiServiceException("OpenRouter response choice format is invalid", null, true);
                }

                Object messageObj = firstChoice.get("message");
                if (!(messageObj instanceof Map<?, ?> message)) {
                        throw new OpenAiServiceException("OpenRouter response missing message payload", null, true);
                }

                Object contentObj = message.get("content");
                if (!(contentObj instanceof String content) || content.isBlank()) {
                        throw new OpenAiServiceException("OpenRouter response missing content text", null, true);
                }

                return content;
        }
}
