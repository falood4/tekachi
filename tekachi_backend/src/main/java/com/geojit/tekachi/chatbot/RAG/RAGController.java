package com.geojit.tekachi.chatbot.RAG;

import java.io.File;
import java.util.Map;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
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
    public String ingest(@RequestBody(required = false) Map<String, String> request) throws Exception {
        String fileName = request != null ? request.getOrDefault("fileName", "dbms.pdf") : "dbms.pdf";
        String title = request != null ? request.getOrDefault("title", "Tech Interview Syllabus") : "Tech Interview Syllabus";
        File file = ingestionService.resolvePdfFile(fileName);
        Integer docId = ingestionService.ingestPdf(file, title);

        return "Ingested with ID: " + docId;
    }
}
