package com.geojit.tekachi.chatbot.RAG.chunk_processing;

import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Component
public class TextChunker {

    private static final int MAX_WORDS = 700;
    private static final int OVERLAP_WORDS = 100;
    private static final Pattern WORD_PATTERN = Pattern.compile("\\S+");

    public List<String> chunk(String text) {
        List<String> chunks = new ArrayList<>();
        forEachChunk(text, chunks::add);
        return chunks;
    }

    public void forEachChunk(String text, Consumer<String> consumer) {
        Matcher matcher = WORD_PATTERN.matcher(text);
        List<String> buffer = new ArrayList<>(MAX_WORDS);

        while (matcher.find()) {
            buffer.add(matcher.group());

            if (buffer.size() >= MAX_WORDS) {
                emitChunk(buffer, consumer);
                buffer = keepOverlap(buffer);
            }
        }

        if (!buffer.isEmpty()) {
            emitChunk(buffer, consumer);
        }
    }

    private void emitChunk(List<String> words, Consumer<String> consumer) {
        StringBuilder chunkBuilder = new StringBuilder();

        for (int i = 0; i < words.size(); i++) {
            if (i > 0) {
                chunkBuilder.append(' ');
            }
            chunkBuilder.append(words.get(i));
        }

        consumer.accept(chunkBuilder.toString());
    }

    private List<String> keepOverlap(List<String> words) {
        int overlap = Math.min(OVERLAP_WORDS, words.size());
        List<String> next = new ArrayList<>(overlap);

        for (int i = words.size() - overlap; i < words.size(); i++) {
            next.add(words.get(i));
        }

        return next;
    }
}
