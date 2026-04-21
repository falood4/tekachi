package com.geojit.tekachi.resume.service;

import java.util.List;

public record ResumeParseResult(
        String rawText,
        List<String> educationEntries,
        List<String> skills,
        List<String> links,
        Double cgpaScale10,
        Double percentage,
        FieldConfidence confidence
) {
    public record FieldConfidence(
            boolean educationConfident,
            boolean skillsConfident,
            boolean linksConfident,
            boolean cgpaConfident,
            boolean percentageConfident
    ) {
    }
}
