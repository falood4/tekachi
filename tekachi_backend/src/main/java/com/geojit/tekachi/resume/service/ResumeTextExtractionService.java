package com.geojit.tekachi.resume.service;

import java.io.File;
import java.io.IOException;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.geojit.tekachi.chatbot.RAG.chunk_processing.PdfExtractor;

@Service
public class ResumeTextExtractionService {

    private final PdfExtractor pdfExtractor;

    public ResumeTextExtractionService(PdfExtractor pdfExtractor) {
        this.pdfExtractor = pdfExtractor;
    }

    public String extract(MultipartFile resumeFile) throws IOException {
        if (resumeFile == null || resumeFile.isEmpty()) {
            return "";
        }

        File tempFile = File.createTempFile("resume-upload-", ".pdf");
        try {
            resumeFile.transferTo(tempFile);
            return pdfExtractor.extractText(tempFile);
        } finally {
            tempFile.delete();
        }
    }
}
