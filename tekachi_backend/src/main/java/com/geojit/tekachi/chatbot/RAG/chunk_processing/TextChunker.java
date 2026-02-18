package com.geojit.tekachi.chatbot.RAG.chunk_processing;

import java.util.ArrayList;
import java.util.List;

public class TextChunker {

    private static final int MAX_WORDS = 700;
    private static final int OVERLAP_WORDS = 100;

    public List<String> chunk(String text) {

        String[] words = text.split("\\s+");
        List<String> chunks = new ArrayList<>();

        int start = 0;

        while (start < words.length) {

            int end = Math.min(start + MAX_WORDS, words.length);

            StringBuilder chunkBuilder = new StringBuilder();

            for (int i = start; i < end; i++) {
                chunkBuilder.append(words[i]).append(" ");
            }

            chunks.add(chunkBuilder.toString().trim());

            start = end - OVERLAP_WORDS;

            if (start < 0)
                start = 0;
        }

        return chunks;
    }
}
