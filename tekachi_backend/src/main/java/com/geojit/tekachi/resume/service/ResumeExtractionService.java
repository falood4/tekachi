package com.geojit.tekachi.resume.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.geojit.tekachi.resume.dto.EducationDto;
import com.geojit.tekachi.resume.dto.LinksDto;
import com.geojit.tekachi.resume.dto.ResumeExtractResponse;
import com.geojit.tekachi.resume.dto.SchoolRecordDto;
import com.geojit.tekachi.resume.dto.UgRecordDto;
import com.geojit.tekachi.resume.exception.EmptyResumePdfException;
import com.geojit.tekachi.resume.exception.ResumeParseException;
import com.geojit.tekachi.resume.exception.UnsupportedResumeTypeException;
import com.geojit.tekachi.usersignin.entity.User;

@Service
public class ResumeExtractionService {

    private static final Pattern URL_PATTERN = Pattern.compile("https?://[^\\s)]+", Pattern.CASE_INSENSITIVE);
    private static final Pattern SCORE_PATTERN = Pattern.compile("(\\d{1,2}(?:\\.\\d+)?\\s*(?:%|/10|CGPA|cgpa)?)");
    private static final List<String> COMMON_SKILLS = List.of(
            "java", "spring", "spring boot", "hibernate", "sql", "mysql", "postgresql", "mongodb",
            "python", "c", "c++", "javascript", "typescript", "dart", "flutter", "react", "angular",
            "aws", "docker", "kubernetes", "git", "html", "css", "rest", "microservices");

    public ResumeExtractResponse extractFromPdf(MultipartFile file, User user) {
        validateFile(file);

        String text = extractText(file);
        if (text.isBlank()) {
            throw new EmptyResumePdfException("PDF is empty or contains no readable text");
        }

        ResumeExtractResponse response = new ResumeExtractResponse();
        response.setUserId(user.getId());
        response.setUserEmail(user.getEmail());
        response.setFullName(extractName(text));
        response.setSkills(extractSkills(text));
        response.setLinks(extractLinks(text));
        response.setEducation(extractEducation(text));
        return response;
    }

    private void validateFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new EmptyResumePdfException("Resume file is required and cannot be empty");
        }

        String fileName = file.getOriginalFilename() == null ? "" : file.getOriginalFilename().toLowerCase(Locale.ROOT);
        String contentType = file.getContentType() == null ? "" : file.getContentType().toLowerCase(Locale.ROOT);

        if (!fileName.endsWith(".pdf") && !"application/pdf".equals(contentType)) {
            throw new UnsupportedResumeTypeException("Only PDF files are supported");
        }
    }

    private String extractText(MultipartFile file) {
        try (PDDocument document = PDDocument.load(file.getInputStream())) {
            if (document.getNumberOfPages() == 0) {
                throw new EmptyResumePdfException("PDF has no pages");
            }
            PDFTextStripper stripper = new PDFTextStripper();
            return stripper.getText(document).trim();
        } catch (EmptyResumePdfException ex) {
            throw ex;
        } catch (IOException ex) {
            throw new ResumeParseException("Could not parse the uploaded PDF", ex);
        }
    }

    private String extractName(String text) {
        String[] lines = text.split("\\R");
        for (String line : lines) {
            String candidate = line.trim().replaceAll("\\s+", " ");
            if (candidate.isBlank() || candidate.contains("@") || candidate.length() < 3) {
                continue;
            }
            if (candidate.matches("(?i).*(resume|curriculum vitae|phone|email|linkedin|github).*")) {
                continue;
            }
            int words = candidate.split(" ").length;
            if (words <= 6) {
                return candidate;
            }
        }
        return "";
    }

    private List<String> extractSkills(String text) {
        String lower = text.toLowerCase(Locale.ROOT);
        Set<String> skills = new LinkedHashSet<>();

        String skillsBlock = sectionAfterHeader(text, "skills");
        if (!skillsBlock.isBlank()) {
            Arrays.stream(skillsBlock.split("[,•\\n|/]"))
                    .map(String::trim)
                    .filter(token -> !token.isBlank())
                    .limit(25)
                    .forEach(skills::add);
        }

        for (String skill : COMMON_SKILLS) {
            if (lower.contains(skill.toLowerCase(Locale.ROOT))) {
                skills.add(skill);
            }
        }

        return new ArrayList<>(skills);
    }

    private LinksDto extractLinks(String text) {
        Matcher matcher = URL_PATTERN.matcher(text);
        List<String> otherLinks = new ArrayList<>();
        String linkedin = null;
        String github = null;
        String portfolio = null;

        while (matcher.find()) {
            String url = matcher.group();
            String normalized = url.toLowerCase(Locale.ROOT);
            if (normalized.contains("linkedin.com") && linkedin == null) {
                linkedin = url;
            } else if (normalized.contains("github.com") && github == null) {
                github = url;
            } else if (portfolio == null) {
                portfolio = url;
            } else {
                otherLinks.add(url);
            }
        }

        LinksDto links = new LinksDto();
        links.setLinkedin(linkedin);
        links.setGithub(github);
        links.setPortfolio(portfolio);
        links.setOther(otherLinks);
        return links;
    }

    private EducationDto extractEducation(String text) {
        EducationDto education = new EducationDto();
        String[] lines = text.split("\\R");

        SchoolRecordDto class10 = new SchoolRecordDto();
        SchoolRecordDto class12 = new SchoolRecordDto();
        UgRecordDto ug = new UgRecordDto();

        for (String raw : lines) {
            String line = raw.trim();
            if (line.isBlank()) {
                continue;
            }

            String lower = line.toLowerCase(Locale.ROOT);
            if (lower.contains("10th") || lower.contains("class x") || lower.contains("sslc")) {
                class10.setBoard(extractLabelValue(line, "board"));
                class10.setSchool(extractSchoolOrCollege(line));
                class10.setScore(extractScore(line));
            }

            if (lower.contains("12th") || lower.contains("class xii") || lower.contains("hsc")) {
                class12.setBoard(extractLabelValue(line, "board"));
                class12.setSchool(extractSchoolOrCollege(line));
                class12.setScore(extractScore(line));
            }

            if (lower.matches(".*(b\\.?tech|b\\.?e|bsc|bca|bcom|undergraduate|ug).*")) {
                ug.setCollege(extractSchoolOrCollege(line));
                ug.setCgpa(extractScore(line));
            }
        }

        education.setClass10(class10);
        education.setClass12(class12);
        education.setUgCgpa(ug);
        return education;
    }

    private String sectionAfterHeader(String text, String header) {
        String[] lines = text.split("\\R");
        StringBuilder builder = new StringBuilder();
        boolean inSection = false;

        for (String rawLine : lines) {
            String line = rawLine.trim();
            if (!inSection && line.equalsIgnoreCase(header)) {
                inSection = true;
                continue;
            }
            if (inSection && line.matches("(?i)^(education|projects|experience|certifications|achievements)$")) {
                break;
            }
            if (inSection) {
                builder.append(line).append("\n");
            }
        }

        return builder.toString().trim();
    }

    private String extractLabelValue(String line, String label) {
        Pattern pattern = Pattern.compile("(?i)" + label + "\\s*[:\\-]\\s*([^,|]+)");
        Matcher matcher = pattern.matcher(line);
        if (matcher.find()) {
            return matcher.group(1).trim();
        }
        return "";
    }

    private String extractSchoolOrCollege(String line) {
        String cleaned = line.replaceAll("(?i)(10th|12th|class x|class xii|hsc|sslc|b\\.?tech|b\\.?e|bsc|bca|bcom|ug)", "")
                .replaceAll("(?i)(board|cgpa|score|percentage)\\s*[:\\-]?", "")
                .replaceAll("\\s+", " ")
                .trim();
        return cleaned;
    }

    private String extractScore(String line) {
        Matcher matcher = SCORE_PATTERN.matcher(line);
        if (matcher.find()) {
            return matcher.group(1).replaceAll("\\s+", " ").trim();
        }
        return "";
    }
}
