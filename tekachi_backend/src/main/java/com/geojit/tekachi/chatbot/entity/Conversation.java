package com.geojit.tekachi.chatbot.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import lombok.*;

@Getter
@Setter
@Entity
@Table(name = "conversations")
public class Conversation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "conversation_id")
    private Integer conversationId;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "persona_id", nullable = false)
    private Persona persona;

    @Column(name = "current_topic")
    private String currentTopic; // 🔥 ADD THIS

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();
}
