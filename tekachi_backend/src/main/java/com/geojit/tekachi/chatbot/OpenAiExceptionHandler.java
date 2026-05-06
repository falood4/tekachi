package com.geojit.tekachi.chatbot;

import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class OpenAiExceptionHandler {

    @ExceptionHandler(OpenAiServiceException.class)
    public ResponseEntity<Map<String, Object>> handleOpenAiServiceException(OpenAiServiceException ex) {
        Integer upstreamStatus = ex.getUpstreamStatusCode();

        // Default to 502 (upstream/provider failure). If retryable, prefer 503.
        HttpStatus status = ex.isRetryable() ? HttpStatus.SERVICE_UNAVAILABLE : HttpStatus.BAD_GATEWAY;

        String message = ex.getMessage();
        if (upstreamStatus != null && (upstreamStatus == 401 || upstreamStatus == 403)) {
            message = "OpenRouter authentication failed. Check openrouter.api.key.";
        }

        if (hasCause(ex, io.netty.resolver.dns.DnsNameResolverTimeoutException.class)
                || hasCause(ex, java.net.UnknownHostException.class)) {
            status = HttpStatus.SERVICE_UNAVAILABLE;
            message = "Cannot resolve openrouter.ai (DNS/network issue). Check DNS, firewall, proxy, or VPN.";
        }

        // Map.of(...) disallows null values; build a mutable map and only include
        // non-null entries.
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("error", message);
        body.put("retryable", ex.isRetryable());
        if (upstreamStatus != null) {
            body.put("upstream_status", upstreamStatus);
        }
        return ResponseEntity.status(status).body(body);
    }

    private static boolean hasCause(Throwable throwable, Class<? extends Throwable> causeClass) {
        Throwable current = throwable;
        while (current != null) {
            if (causeClass.isInstance(current)) {
                return true;
            }
            current = current.getCause();
        }
        return false;
    }
}
