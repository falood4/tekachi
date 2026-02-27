package com.geojit.tekachi.config;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * Standard error response structure for all exception responses.
 * Provides consistent error format across all API endpoints.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ApiErrorResponse {

    /**
     * Timestamp when the error occurred.
     */
    private LocalDateTime timestamp;

    /**
     * HTTP status code (e.g., 400, 401, 403, 500).
     */
    private int status;

    /**
     * Short error type/category (e.g., "Validation Failed", "Authentication
     * Failed").
     */
    private String error;

    /**
     * Detailed error message suitable for displaying to the user.
     */
    private String message;

    /**
     * Request path where the error occurred.
     */
    private String path;

    /**
     * Field-level validation errors (populated only for
     * MethodArgumentNotValidException).
     * Example: {"email": "must be a valid email", "password": "must not be blank"}
     */
    private Map<String, String> fieldErrors;
}