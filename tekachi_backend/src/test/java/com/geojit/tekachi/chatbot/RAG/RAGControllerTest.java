package com.geojit.tekachi.chatbot.RAG;

import com.geojit.tekachi.chatbot.RAG.service.DocumentIngestionService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.io.File;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class RAGControllerTest {

    @Mock
    private DocumentIngestionService ingestionService;

    @Test
    void ingestUsesDefaultsWhenRequestBodyMissing() throws Exception {
        RAGController controller = new RAGController(ingestionService);
        File file = new File("dbms.pdf");

        when(ingestionService.resolvePdfFile("dbms.pdf")).thenReturn(file);
        when(ingestionService.ingestPdf(file, "Tech Interview Syllabus")).thenReturn(12);

        String response = controller.ingest(null);

        assertEquals("Ingested with ID: 12", response);
        verify(ingestionService).resolvePdfFile("dbms.pdf");
        verify(ingestionService).ingestPdf(file, "Tech Interview Syllabus");
    }

    @Test
    void ingestUsesProvidedFileNameAndTitle() throws Exception {
        RAGController controller = new RAGController(ingestionService);
        File file = new File("custom.pdf");

        when(ingestionService.resolvePdfFile("custom.pdf")).thenReturn(file);
        when(ingestionService.ingestPdf(file, "Custom Title")).thenReturn(33);

        String response = controller.ingest(Map.of("fileName", "custom.pdf", "title", "Custom Title"));

        assertEquals("Ingested with ID: 33", response);
        verify(ingestionService).resolvePdfFile("custom.pdf");
        verify(ingestionService).ingestPdf(file, "Custom Title");
    }
}
