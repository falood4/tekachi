package com.geojit.tekachi.chatbot.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.geojit.tekachi.chatbot.entity.Conversation;

public interface ConvoRepo extends JpaRepository<Conversation, Integer> {

    List<Conversation> findByUserId(Long userId);

}
