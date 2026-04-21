# Tekachi Backend

## Resume parsing module

The resume parser uses open-source dependencies only:

- **Apache PDFBox (`org.apache.pdfbox:pdfbox`)** for PDF text extraction from uploaded resume files.
- **Spring Boot Test (`org.springframework.boot:spring-boot-starter-test`)** for unit testing parsing logic and PDF extraction flow.

### Parsing approach

- PDF resumes are converted to text via `PdfExtractor` (PDFBox-backed).
- `ResumeFieldParser` applies layered extraction:
  - Regex/pattern heuristics for links, CGPA, and percentages.
  - Section-based extraction for `Education` and `Skills` blocks.
  - Conservative fallback values with per-field confidence flags when signals are weak.
- Output normalization includes:
  - CGPA normalization to a 10-point scale.
  - Percentage normalization to a 0-100 representation.
  - Deduplication of skills and links.
