package com.geojit.tekachi.chatbot.RAG.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.geojit.tekachi.chatbot.RAG.entity.Document;

@Repository
public interface DocumentRepository extends JpaRepository<Document, Integer> {

}
