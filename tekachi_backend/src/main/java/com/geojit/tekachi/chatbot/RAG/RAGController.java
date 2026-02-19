package com.geojit.tekachi.chatbot.RAG;

import java.io.File;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.geojit.tekachi.chatbot.RAG.service.DocumentIngestionService;

@RestController
@RequestMapping("/rag")
public class RAGController {

    private final DocumentIngestionService ingestionService;

    public RAGController(DocumentIngestionService ingestionService) {
        this.ingestionService = ingestionService;
    }

    @PostMapping("/ingest")
    public String ingest() throws Exception {

        File file = new File(
                "C:/Users/kurie/OneDrive/Desktop/flutter/tekachi/tekachi_backend/src/main/java/com/geojit/tekachi/chatbot/RAG/PDFS/dbms.pdf");

        Integer docId = ingestionService.ingestPdf(file, "Tech Interview Syllabus");

        return "Ingested with ID: " + docId;
    }
}
