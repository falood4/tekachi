package com.geojit.tekachi.chatbot.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "personas")
public class Persona {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "persona_id")
    private Integer personaId;

    @Column(nullable = false, unique = true)
    private String name;

    @Column(name = "system_prompt", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String systemPrompt;

    @Column(name = "greeting_instruction", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String greetingInstruction;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();
}
