package com.geojit.tekachi.chatbot.RAG.repo;

import com.geojit.tekachi.chatbot.RAG.entity.DocumentChunk;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChunkRepository extends JpaRepository<DocumentChunk, Integer> {

    List<DocumentChunk> findByTopic(String topic);

    List<DocumentChunk> findTop5ByTopic(String topic);
}
