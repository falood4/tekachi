package com.geojit.tekachi.chatbot;

public class OpenAiServiceException extends RuntimeException {

    private final boolean retryable;
    private final Integer upstreamStatusCode;

    public OpenAiServiceException(String message, Throwable cause, boolean retryable) {
        this(message, cause, retryable, null);
    }

    public OpenAiServiceException(String message, Throwable cause, boolean retryable, Integer upstreamStatusCode) {
        super(message, cause);
        this.retryable = retryable;
        this.upstreamStatusCode = upstreamStatusCode;
    }

    public boolean isRetryable() {
        return retryable;
    }

    public Integer getUpstreamStatusCode() {
        return upstreamStatusCode;
    }
}
