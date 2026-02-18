package com.geojit.tekachi.chatbot.RAG.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "documents")
public class Document {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "document_id")
    private Integer documentId;

    @Column(nullable = false)
    private String title;

    private String source;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @OneToMany(mappedBy = "document", cascade = CascadeType.ALL)
    private List<DocumentChunk> chunks;

    // getters and setters
}
