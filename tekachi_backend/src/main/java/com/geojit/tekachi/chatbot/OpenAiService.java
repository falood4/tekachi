package com.geojit.tekachi.chatbot;

import com.geojit.tekachi.chatbot.dtos.ChatRequest;
import com.geojit.tekachi.chatbot.dtos.OpenAiMsg;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import io.netty.resolver.DefaultAddressResolverGroup;
import reactor.netty.http.client.HttpClient;

import java.time.Duration;
import java.util.ArrayList;
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

                // Prefer the JDK/OS resolver on Windows; Netty's DNS resolver can time out even
                // when nslookup succeeds (proxy/VPN/firewall/IPv6 edge cases).
                HttpClient httpClient = HttpClient.create()
                                .resolver(DefaultAddressResolverGroup.INSTANCE)
                                .responseTimeout(Duration.ofSeconds(45));

                this.webClient = WebClient.builder()
                                .baseUrl("https://openrouter.ai/api/v1")
                                .clientConnector(new ReactorClientHttpConnector(httpClient))
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
                                                                                        false,
                                                                                        clientResponse.statusCode()
                                                                                                        .value())))
                                        .bodyToMono(new ParameterizedTypeReference<Map<String, Object>>() {
                                        })
                                        .block();

                        return extractContentFromResponse(response);
                } catch (OpenAiServiceException e) {
                        throw e;
                } catch (Exception e) {
                        if (hasCause(e, io.netty.resolver.dns.DnsNameResolverTimeoutException.class)
                                        || hasCause(e, java.net.UnknownHostException.class)) {
                                throw new OpenAiServiceException(
                                                "Cannot resolve openrouter.ai (DNS/network issue)",
                                                e,
                                                true);
                        }
                        throw new OpenAiServiceException("Failed to fetch chat response from OpenRouter", e, true);
                }
        }

        public String getVerdict(List<OpenAiMsg> messages) {

                try {

                        List<OpenAiMsg> prompt = new ArrayList<>(messages);

                        prompt.add(new OpenAiMsg(
                                        "system",
                                        "The interview has concluded. Based on the conversation above, return the final hiring verdict."));

                        prompt.add(new OpenAiMsg(
                                        "user",
                                        "Respond with EXACTLY one word: HIRED or NON-HIRED. Do not explain."));

                        ChatRequest request = new ChatRequest(model, prompt);

                        Map<String, Object> response = webClient.post()
                                        .uri("/chat/completions")
                                        .bodyValue(request)
                                        .retrieve()
                                        .onStatus(status -> status.isError(),
                                                        clientResponse -> clientResponse.bodyToMono(String.class)
                                                                        .map(body -> new OpenAiServiceException(
                                                                                        "OpenRouter Error: " + body,
                                                                                        null,
                                                                                        false,
                                                                                        clientResponse.statusCode()
                                                                                                        .value())))
                                        .bodyToMono(new ParameterizedTypeReference<Map<String, Object>>() {
                                        })
                                        .block();

                        return extractContentFromResponse(response);

                } catch (Exception e) {
                        if (hasCause(e, io.netty.resolver.dns.DnsNameResolverTimeoutException.class)
                                        || hasCause(e, java.net.UnknownHostException.class)) {
                                throw new OpenAiServiceException(
                                                "Cannot resolve openrouter.ai (DNS/network issue)",
                                                e,
                                                true);
                        }
                        throw new OpenAiServiceException("Failed to fetch chat response from OpenRouter", e, true);
                }
        }

        private static boolean hasCause(Throwable throwable, Class<? extends Throwable> causeClass) {
                Throwable current = throwable;
                while (current != null) {
                        if (causeClass.isInstance(current)) {
                                return true;
                        }
                        current = current.getCause();
                }
                return false;
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
