package com.geojit.tekachi.chatbot.RAG.service;

import org.springframework.stereotype.Service;

import com.geojit.tekachi.chatbot.OpenAiService;

import java.util.List;

@Service
public class EmbeddingService {

    private final OpenAiService openAiService;

    public EmbeddingService(OpenAiService openAiService) {
        this.openAiService = openAiService;
    }

    //public List<Double> generateEmbedding(String text) {
       // return openAiService.getEmbedding(text);
    //}
}
