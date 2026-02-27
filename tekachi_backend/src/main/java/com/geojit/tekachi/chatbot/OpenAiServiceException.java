package com.geojit.tekachi.chatbot;

public class OpenAiServiceException extends RuntimeException {

    private final boolean retryable;

    public OpenAiServiceException(String message, Throwable cause, boolean retryable) {
        super(message, cause);
        this.retryable = retryable;
    }

    public boolean isRetryable() {
        return retryable;
    }
}
