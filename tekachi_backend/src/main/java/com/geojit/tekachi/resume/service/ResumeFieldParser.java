package com.geojit.tekachi.resume.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Component;

@Component
public class ResumeFieldParser {

    private static final Pattern URL_PATTERN = Pattern.compile("(?i)\\b(?:https?://)?(?:www\\.)?[a-z0-9.-]+\\.[a-z]{2,}(?:/[\\w\\-./?%&=+#]*)?");
    private static final Pattern LINKEDIN_GITHUB_PATTERN = Pattern.compile("(?i).*\\b(linkedin\\.com|github\\.com)\\b.*");
    private static final Pattern CGPA_PATTERN = Pattern.compile("(?i)(?:cgpa|gpa)\\s*[:=-]?\\s*(\\d{1,2}(?:\\.\\d{1,2})?)\\s*(?:/\\s*(\\d{1,2}(?:\\.\\d{1,2})?))?");
    private static final Pattern FALLBACK_CGPA_PATTERN = Pattern.compile("(?i)\\b(\\d(?:\\.\\d{1,2})?)\\s*/\\s*(10|4)\\b");
    private static final Pattern PERCENTAGE_PATTERN = Pattern.compile("(?i)(?:percentage|percent|marks?)\\s*[:=-]?\\s*(\\d{1,3}(?:\\.\\d{1,2})?)\\s*%?");
    private static final Pattern FALLBACK_PERCENTAGE_PATTERN = Pattern.compile("\\b(\\d{1,3}(?:\\.\\d{1,2})?)\\s*%\\b");

    private static final Set<String> HEADING_KEYWORDS = Set.of(
            "education", "academic", "qualification", "skills", "technical skills", "projects",
            "experience", "certification", "summary", "profile", "achievements");

    public ResumeParseResult parse(String rawText) {
        String safeText = rawText == null ? "" : rawText;
        List<String> lines = Arrays.stream(safeText.replace("\r", "").split("\n"))
                .map(String::trim)
                .toList();

        List<String> links = extractLinks(safeText);
        List<String> educationEntries = extractEducationEntries(lines);
        List<String> skills = extractSkills(lines);

        Double cgpaScale10 = extractCgpaScale10(safeText);
        Double percentage = extractPercentage(safeText);

        ResumeParseResult.FieldConfidence confidence = new ResumeParseResult.FieldConfidence(
                !educationEntries.isEmpty(),
                !skills.isEmpty(),
                !links.isEmpty(),
                cgpaScale10 != null,
                percentage != null
        );

        return new ResumeParseResult(
                safeText,
                educationEntries,
                skills,
                links,
                cgpaScale10,
                percentage,
                confidence
        );
    }

    private List<String> extractLinks(String text) {
        Set<String> dedup = new LinkedHashSet<>();
        Matcher matcher = URL_PATTERN.matcher(text);

        while (matcher.find()) {
            String candidate = matcher.group();
            if (!LINKEDIN_GITHUB_PATTERN.matcher(candidate).matches() && !candidate.toLowerCase(Locale.ROOT).startsWith("http")) {
                continue;
            }

            String normalized = candidate.toLowerCase(Locale.ROOT);
            if (!normalized.startsWith("http://") && !normalized.startsWith("https://")) {
                normalized = "https://" + normalized;
            }

            dedup.add(normalized.replaceAll("[),.;]+$", ""));
        }
        return dedup.stream().toList();
    }

    private List<String> extractEducationEntries(List<String> lines) {
        List<String> section = extractSection(lines, Set.of("education", "academic", "qualification"));
        return normalizeList(section);
    }

    private List<String> extractSkills(List<String> lines) {
        List<String> section = extractSection(lines, Set.of("skills", "technical skills", "tech stack"));
        Set<String> skills = new LinkedHashSet<>();

        for (String line : section) {
            String cleaned = line.replaceAll("^[\\-•*]+\\s*", "").trim();
            if (cleaned.isBlank()) {
                continue;
            }

            String[] tokens = cleaned.split("[,|/]|\\s{2,}");
            for (String token : tokens) {
                String skill = token.trim().replaceAll("^[\\-•*]+", "");
                if (!skill.isBlank() && skill.length() > 1) {
                    skills.add(skill.toLowerCase(Locale.ROOT));
                }
            }
        }
        return skills.stream().toList();
    }

    private List<String> extractSection(List<String> lines, Set<String> sectionNames) {
        List<String> sectionLines = new ArrayList<>();
        boolean inSection = false;

        for (String line : lines) {
            if (line.isBlank()) {
                if (inSection) {
                    sectionLines.add("");
                }
                continue;
            }

            String normalized = normalizeHeading(line);
            boolean isHeading = isHeading(normalized);

            if (isHeading && sectionNames.stream().anyMatch(normalized::contains)) {
                inSection = true;
                continue;
            }

            if (inSection && isHeading && sectionNames.stream().noneMatch(normalized::contains)) {
                break;
            }

            if (inSection) {
                sectionLines.add(line);
            }
        }

        return sectionLines;
    }

    private String normalizeHeading(String line) {
        return line.toLowerCase(Locale.ROOT)
                .replaceAll("[^a-z ]", " ")
                .replaceAll("\\s+", " ")
                .trim();
    }

    private boolean isHeading(String normalizedLine) {
        return HEADING_KEYWORDS.stream().anyMatch(normalizedLine::contains);
    }

    private Double extractCgpaScale10(String text) {
        Matcher matcher = CGPA_PATTERN.matcher(text);
        if (matcher.find()) {
            double value = Double.parseDouble(matcher.group(1));
            String denominatorToken = matcher.group(2);
            double denominator = denominatorToken == null ? 10d : Double.parseDouble(denominatorToken);
            return normalizeCgpa(value, denominator);
        }

        Matcher fallback = FALLBACK_CGPA_PATTERN.matcher(text);
        if (fallback.find()) {
            double value = Double.parseDouble(fallback.group(1));
            double denominator = Double.parseDouble(fallback.group(2));
            return normalizeCgpa(value, denominator);
        }

        return null;
    }

    private Double extractPercentage(String text) {
        Matcher matcher = PERCENTAGE_PATTERN.matcher(text);
        if (matcher.find()) {
            return normalizePercentage(Double.parseDouble(matcher.group(1)));
        }

        Matcher fallback = FALLBACK_PERCENTAGE_PATTERN.matcher(text);
        if (fallback.find()) {
            return normalizePercentage(Double.parseDouble(fallback.group(1)));
        }

        return null;
    }

    private Double normalizeCgpa(double value, double denominator) {
        if (denominator <= 0) {
            return null;
        }
        double normalized = value * (10d / denominator);
        if (normalized < 0 || normalized > 10.1) {
            return null;
        }
        return round(normalized);
    }

    private Double normalizePercentage(double raw) {
        double normalized = raw <= 1 ? raw * 100 : raw;
        if (normalized < 0 || normalized > 100.1) {
            return null;
        }
        return round(normalized);
    }

    private Double round(double value) {
        return BigDecimal.valueOf(value).setScale(2, RoundingMode.HALF_UP).doubleValue();
    }

    private List<String> normalizeList(List<String> values) {
        return values.stream()
                .map(line -> line.replaceAll("^[\\-•*]+\\s*", "").trim())
                .filter(line -> !line.isBlank())
                .distinct()
                .toList();
    }
}
