package com.geojit.tekachi.chatbot.RAG.service;

import java.io.File;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

import org.springframework.stereotype.Service;

import com.geojit.tekachi.chatbot.RAG.chunk_processing.PdfExtractor;
import com.geojit.tekachi.chatbot.RAG.chunk_processing.TextChunker;
import com.geojit.tekachi.chatbot.RAG.chunk_processing.TextCleaner;
import com.geojit.tekachi.chatbot.RAG.entity.Document;
import com.geojit.tekachi.chatbot.RAG.entity.DocumentChunk;
import com.geojit.tekachi.chatbot.RAG.repo.ChunkRepository;
import com.geojit.tekachi.chatbot.RAG.repo.DocumentRepository;

@Service
public class DocumentIngestionService {

    private final DocumentRepository documentRepository;
    private final ChunkRepository chunkRepository;
    private final PdfExtractor pdfExtractor;
    private final TextCleaner textCleaner;
    private final TextChunker textChunker;

    DocumentIngestionService(DocumentRepository documentRepository, ChunkRepository chunkRepository,
            PdfExtractor pdfExtractor, TextCleaner textCleaner, TextChunker textChunker) {
        this.documentRepository = documentRepository;
        this.chunkRepository = chunkRepository;
        this.pdfExtractor = pdfExtractor;
        this.textCleaner = textCleaner;
        this.textChunker = textChunker;
    }

    private final List<String> topicArray = List.of(
            "Database System Architecture",
            "Three-Level Architecture",
            "ER Model and Keys",
            "Relational Algebra",
            "DDL, DML, DCL",
            "Joins and Subqueries",
            "ACID",
            "Deadlocks",
            "Sorting",
            "Sorting Techniques",
            "Trees",
            "Graphs",
            "Graph Traversal and Algorithms",
            "Stack",
            "Queue",
            "Object-Oriented Concepts",
            "Overloading and Overriding",
            "Inheritance and Multilevel Hierarchy",
            "Packages and Interfaces",
            "Exception Handling",
            "Multithreaded Programming",
            "Event Handling",
            "AWT",
            "UML",
            "Data Abstraction",
            "Encapsulation and Data Hiding",
            "Functions of an Operating System",
            "Types of Operating Systems",
            "Processes",
            "Multithreading",
            "CPU Scheduling",
            "Inter Process Communication",
            "Memory Management",
            "Disk Scheduling Algorithms");

    public Integer ingestPdf(File file, String title) throws Exception {

        Document document = new Document();
        document.setTitle(title);
        document.setSource(file.getAbsolutePath());
        final Document savedDocument = documentRepository.save(document);

        String raw = pdfExtractor.extractText(file);
        String clean = textCleaner.clean(raw);

        AtomicReference<String> currentTopic = new AtomicReference<>(null);
        AtomicInteger index = new AtomicInteger(0);

        textChunker.forEachChunk(clean, chunkText -> {
            // detect topic change
            for (String topic : topicArray) {
                if (chunkText.trim().toLowerCase().startsWith(topic.toLowerCase())) {
                    currentTopic.set(topic);
                    System.out.println("Detected topic: " + currentTopic.get());
                    break;
                }
            }

            if (currentTopic.get() == null) {
                return;
            }

            DocumentChunk chunk = new DocumentChunk();
            chunk.setDocument(savedDocument);
            chunk.setChunkIndex(index.getAndIncrement());
            chunk.setContent(chunkText);
            chunk.setTopic(currentTopic.get());

            chunkRepository.save(chunk);
        });

        return savedDocument.getDocumentId();
    }
}
