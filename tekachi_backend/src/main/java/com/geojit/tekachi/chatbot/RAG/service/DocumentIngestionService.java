package com.geojit.tekachi.chatbot.RAG.service;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

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
    private final String ingestBaseDir;

    DocumentIngestionService(DocumentRepository documentRepository, ChunkRepository chunkRepository,
            PdfExtractor pdfExtractor,
            TextCleaner textCleaner,
            TextChunker textChunker,
            @Value("${rag.ingest.base-dir:src/main/java/com/geojit/tekachi/chatbot/RAG/PDFS}") String ingestBaseDir) {
        this.documentRepository = documentRepository;
        this.chunkRepository = chunkRepository;
        this.pdfExtractor = pdfExtractor;
        this.textCleaner = textCleaner;
        this.textChunker = textChunker;
        this.ingestBaseDir = ingestBaseDir;
    }

    private final List<String> topicArray = List.of(
            "Database Language", // DBMS
            "Three Schema architecture",
            "Structure of Relational Databases",
            "Entity Relationship Diagram",
            "Relational Algebra",
            "Data Definition Language",
            "Data Manipulation Language",
            "Data Control Language",
            "Cardinality",
            "Basic Query Structure",
            "Insertion",
            "SQL Views",
            "ER Model",
            "Binary Relational Operations",
            "General Constraints",
            "ACID",
            "Deadlocks",
            "Sort", // DS
            "Trees",
            "Graphs",
            "Graph Traversals",
            "Stack",
            "Queue",
            "Object-Oriented Approach", // OOPS
            "OOPs Concepts",
            "Inheritance",
            "Java Terminology",
            "Overloading",
            "Overriding",
            "Superclass and Subclass",
            "Exceptions",
            "Exception Handling",
            "Multilevel Inheritance",
            "Multithreading",
            "Event Handling",
            "AWT",
            "UML",
            "Data Abstraction",
            "Functions of an Operating System",
            "Types of Operating Systems", // OS
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

            String lowerChunk = chunkText.toLowerCase();

            for (String topic : topicArray) {
                if (lowerChunk.contains(topic.toLowerCase())) {
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

    public File resolvePdfFile(String fileName) {
        if (fileName == null || fileName.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "fileName is required");
        }

        Path basePath = Paths.get(ingestBaseDir).toAbsolutePath().normalize();
        Path resolvedPath = basePath.resolve(fileName).normalize();

        if (!resolvedPath.startsWith(basePath)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid file name");
        }

        File file = resolvedPath.toFile();
        if (!file.exists() || !file.isFile()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "PDF file not found: " + fileName);
        }

        return file;
    }
}
