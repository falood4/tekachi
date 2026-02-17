package com.geojit.tekachi.chatbot.repo;

import com.geojit.tekachi.chatbot.entity.Message;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface MsgRepo extends JpaRepository<Message, Integer> {

    @Query("""
                SELECT m FROM Message m
                WHERE m.conversationId = :conversationId
                ORDER BY m.createdAt DESC
            """)
    List<Message> findRecentMessages(
            @Param("conversationId") Integer conversationId,
            Pageable pageable);
}
