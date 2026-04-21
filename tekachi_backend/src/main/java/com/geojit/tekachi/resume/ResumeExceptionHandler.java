package com.geojit.tekachi.resume;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.geojit.tekachi.resume.dto.ResumeExtractionErrorResponse;
import com.geojit.tekachi.resume.exception.EmptyResumePdfException;
import com.geojit.tekachi.resume.exception.ResumeParseException;
import com.geojit.tekachi.resume.exception.UnsupportedResumeTypeException;

@RestControllerAdvice(basePackageClasses = ResumeController.class)
public class ResumeExceptionHandler {

    @ExceptionHandler(UnsupportedResumeTypeException.class)
    public ResponseEntity<ResumeExtractionErrorResponse> handleUnsupportedType(UnsupportedResumeTypeException ex) {
        return ResponseEntity.status(HttpStatus.UNSUPPORTED_MEDIA_TYPE)
                .body(new ResumeExtractionErrorResponse("UNSUPPORTED_FILE_TYPE", ex.getMessage()));
    }

    @ExceptionHandler(EmptyResumePdfException.class)
    public ResponseEntity<ResumeExtractionErrorResponse> handleEmptyPdf(EmptyResumePdfException ex) {
        return ResponseEntity.badRequest()
                .body(new ResumeExtractionErrorResponse("EMPTY_PDF", ex.getMessage()));
    }

    @ExceptionHandler(ResumeParseException.class)
    public ResponseEntity<ResumeExtractionErrorResponse> handleParseFailure(ResumeParseException ex) {
        return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY)
                .body(new ResumeExtractionErrorResponse("PARSE_FAILURE", ex.getMessage()));
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<ResumeExtractionErrorResponse> handleAuthState(IllegalStateException ex) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new ResumeExtractionErrorResponse("AUTH_CONTEXT_MISSING", ex.getMessage()));
    }
}
