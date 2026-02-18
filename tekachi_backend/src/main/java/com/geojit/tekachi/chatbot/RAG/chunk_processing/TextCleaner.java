package com.geojit.tekachi.chatbot.RAG.chunk_processing;

public class TextCleaner {

    public String clean(String text) {
        return text
                .replaceAll("-\\n", "") // fix hyphen breaks
                .replaceAll("\\n{2,}", "\n\n") // normalize paragraph breaks
                .replaceAll("\\n", " ") // flatten single line breaks
                .replaceAll("\\s{2,}", " ") // remove extra spaces
                .trim();
    }
}
