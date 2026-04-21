package com.geojit.tekachi.resume.dto;

public class ResumeExtractionErrorResponse {

    private String errorCode;
    private String message;

    public ResumeExtractionErrorResponse(String errorCode, String message) {
        this.errorCode = errorCode;
        this.message = message;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public String getMessage() {
        return message;
    }
}
