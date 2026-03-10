package com.geojit.tekachi.chatbot.dtos;

import java.time.LocalDateTime;

public record ConvoHistory(
		Integer conversationId,
		LocalDateTime createdAt,
		Integer personaId,
		Long userId,
		String verdict) {
}
