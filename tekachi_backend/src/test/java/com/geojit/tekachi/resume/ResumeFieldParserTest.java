package com.geojit.tekachi.resume;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertIterableEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;

import org.junit.jupiter.api.Test;

import com.geojit.tekachi.resume.service.ResumeFieldParser;
import com.geojit.tekachi.resume.service.ResumeParseResult;

class ResumeFieldParserTest {

    private final ResumeFieldParser parser = new ResumeFieldParser();

    @Test
    void parsesStructuredResumeWithSectionHeuristics() {
        String resumeText = """
                EDUCATION
                B.Tech Computer Science - XYZ University (2024)
                CGPA: 8.65/10
                
                TECHNICAL SKILLS
                Java, Spring Boot, SQL | Docker
                
                CONTACT
                linkedin.com/in/jane-doe
                https://github.com/janedoe
                """;

        ResumeParseResult result = parser.parse(resumeText);

        assertEquals(8.65, result.cgpaScale10());
        assertNull(result.percentage());
        assertIterableEquals(
                List.of("B.Tech Computer Science - XYZ University (2024)", "CGPA: 8.65/10"),
                result.educationEntries()
        );
        assertIterableEquals(List.of("java", "spring boot", "sql", "docker"), result.skills());
        assertIterableEquals(
                List.of("https://linkedin.com/in/jane-doe", "https://github.com/janedoe"),
                result.links()
        );
        assertTrue(result.confidence().educationConfident());
        assertTrue(result.confidence().skillsConfident());
        assertTrue(result.confidence().linksConfident());
        assertTrue(result.confidence().cgpaConfident());
        assertFalse(result.confidence().percentageConfident());
    }

    @Test
    void normalizesCgpaAndPercentageFromNoisyText() {
        String resumeText = """
                Profile: curious developer
                Academic Qualification
                BE Electronics
                GPA 3.6/4
                Skills
                Python / PYTHON, communication, AWS
                achieved marks: 0.91
                Portfolio: www.example.dev
                """;

        ResumeParseResult result = parser.parse(resumeText);

        assertEquals(9.0, result.cgpaScale10());
        assertEquals(91.0, result.percentage());
        assertIterableEquals(List.of("python", "communication", "aws"), result.skills());
        assertIterableEquals(List.of("https://www.example.dev"), result.links());
        assertTrue(result.confidence().percentageConfident());
    }

    @Test
    void returnsConservativeFallbacksWhenSignalsAreMissing() {
        ResumeParseResult result = parser.parse("Random OCR output -- no headings and values");

        assertTrue(result.educationEntries().isEmpty());
        assertTrue(result.skills().isEmpty());
        assertTrue(result.links().isEmpty());
        assertNull(result.cgpaScale10());
        assertNull(result.percentage());

        assertFalse(result.confidence().educationConfident());
        assertFalse(result.confidence().skillsConfident());
        assertFalse(result.confidence().linksConfident());
        assertFalse(result.confidence().cgpaConfident());
        assertFalse(result.confidence().percentageConfident());
    }
}
