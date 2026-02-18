package com.geojit.tekachi.chatbot.RAG.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "document_chunks")
public class DocumentChunk {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "chunk_id")
    private Integer chunkId;

    @Column(name = "chunk_index")
    private Integer chunkIndex;

    @Column(columnDefinition = "NVARCHAR(MAX)", nullable = false)
    private String content;

    @Column(nullable = false)
    private String topic;

    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String embedding; // JSON string

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "document_id", nullable = false)
    private Document document;

    // getters and setters
}
