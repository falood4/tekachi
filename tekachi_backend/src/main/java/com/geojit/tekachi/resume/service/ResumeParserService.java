package com.geojit.tekachi.resume.service;

import java.io.IOException;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ResumeParserService {

    private final ResumeTextExtractionService textExtractionService;
    private final ResumeFieldParser resumeFieldParser;

    public ResumeParserService(ResumeTextExtractionService textExtractionService, ResumeFieldParser resumeFieldParser) {
        this.textExtractionService = textExtractionService;
        this.resumeFieldParser = resumeFieldParser;
    }

    public ResumeParseResult parse(MultipartFile resumeFile) throws IOException {
        String rawText = textExtractionService.extract(resumeFile);
        return resumeFieldParser.parse(rawText);
    }
}
