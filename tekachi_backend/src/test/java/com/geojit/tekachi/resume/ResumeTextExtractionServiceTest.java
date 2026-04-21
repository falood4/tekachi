package com.geojit.tekachi.resume;

import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockMultipartFile;

import com.geojit.tekachi.chatbot.RAG.chunk_processing.PdfExtractor;
import com.geojit.tekachi.resume.service.ResumeTextExtractionService;

class ResumeTextExtractionServiceTest {

    @Test
    void extractsTextUsingExistingPdfExtractor() throws IOException {
        ResumeTextExtractionService service = new ResumeTextExtractionService(new PdfExtractor());

        byte[] pdfBytes = createSimplePdf("Skills: Java, SQL");
        MockMultipartFile file = new MockMultipartFile("resume", "resume.pdf", "application/pdf", pdfBytes);

        String extracted = service.extract(file);
        assertTrue(extracted.contains("Skills: Java, SQL"));
    }

    private byte[] createSimplePdf(String text) throws IOException {
        try (PDDocument document = new PDDocument(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            PDPage page = new PDPage();
            document.addPage(page);

            try (PDPageContentStream stream = new PDPageContentStream(document, page)) {
                stream.beginText();
                stream.setFont(PDType1Font.HELVETICA, 12);
                stream.newLineAtOffset(100, 700);
                stream.showText(text);
                stream.endText();
            }

            document.save(out);
            return out.toByteArray();
        }
    }
}
