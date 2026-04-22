package com.geojit.tekachi.chatbot.RAG.service;

import com.geojit.tekachi.chatbot.RAG.chunk_processing.PdfExtractor;
import com.geojit.tekachi.chatbot.RAG.chunk_processing.TextChunker;
import com.geojit.tekachi.chatbot.RAG.chunk_processing.TextCleaner;
import com.geojit.tekachi.chatbot.RAG.entity.Document;
import com.geojit.tekachi.chatbot.RAG.entity.DocumentChunk;
import com.geojit.tekachi.chatbot.RAG.repo.ChunkRepository;
import com.geojit.tekachi.chatbot.RAG.repo.DocumentRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.api.io.TempDir;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.function.Consumer;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class DocumentIngestionServiceTest {

    @Mock
    private DocumentRepository documentRepository;

    @Mock
    private ChunkRepository chunkRepository;

    @Mock
    private PdfExtractor pdfExtractor;

    @Mock
    private TextCleaner textCleaner;

    @Mock
    private TextChunker textChunker;

    @TempDir
    Path tempDir;

    @Test
    void resolvePdfFileRejectsBlankName() {
        DocumentIngestionService service = new DocumentIngestionService(
                documentRepository, chunkRepository, pdfExtractor, textCleaner, textChunker, tempDir.toString());

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> service.resolvePdfFile("  "));

        assertEquals(HttpStatus.BAD_REQUEST, ex.getStatusCode());
    }

    @Test
    void resolvePdfFileRejectsPathTraversal() {
        DocumentIngestionService service = new DocumentIngestionService(
                documentRepository, chunkRepository, pdfExtractor, textCleaner, textChunker, tempDir.toString());

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> service.resolvePdfFile("..\\outside.pdf"));

        assertEquals(HttpStatus.BAD_REQUEST, ex.getStatusCode());
    }

    @Test
    void resolvePdfFileReturnsNotFoundForMissingFile() {
        DocumentIngestionService service = new DocumentIngestionService(
                documentRepository, chunkRepository, pdfExtractor, textCleaner, textChunker, tempDir.toString());

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> service.resolvePdfFile("missing.pdf"));

        assertEquals(HttpStatus.NOT_FOUND, ex.getStatusCode());
    }

    @Test
    void resolvePdfFileReturnsFileWhenPresent() throws Exception {
        Path pdf = tempDir.resolve("ok.pdf");
        Files.writeString(pdf, "dummy");

        DocumentIngestionService service = new DocumentIngestionService(
                documentRepository, chunkRepository, pdfExtractor, textCleaner, textChunker, tempDir.toString());

        File file = service.resolvePdfFile("ok.pdf");

        assertTrue(file.exists());
        assertEquals(pdf.toFile().getAbsolutePath(), file.getAbsolutePath());
    }

    @SuppressWarnings("unchecked")
    @Test
    void ingestPdfSavesChunksWithDetectedTopic() throws Exception {
        DocumentIngestionService service = new DocumentIngestionService(
                documentRepository, chunkRepository, pdfExtractor, textCleaner, textChunker, tempDir.toString());

        Document saved = new Document();
        saved.setDocumentId(5);
        when(documentRepository.save(any(Document.class))).thenReturn(saved);

        when(pdfExtractor.extractText(any(File.class))).thenReturn("raw");
        when(textCleaner.clean("raw")).thenReturn("clean");

        doAnswer(invocation -> {
            Consumer<String> consumer = invocation.getArgument(1);
            consumer.accept("Database Language fundamentals and SQL basics");
            return null;
        }).when(textChunker).forEachChunk(eq("clean"), any());

        Integer documentId = service.ingestPdf(new File("sample.pdf"), "Syllabus");

        assertEquals(5, documentId);

        ArgumentCaptor<DocumentChunk> chunkCaptor = ArgumentCaptor.forClass(DocumentChunk.class);
        verify(chunkRepository).save(chunkCaptor.capture());

        DocumentChunk captured = chunkCaptor.getValue();
        assertEquals("Database Language", captured.getTopic());
        assertEquals(saved, captured.getDocument());
        assertEquals(0, captured.getChunkIndex());
    }
}
