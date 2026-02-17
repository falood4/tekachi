package com.geojit.tekachi.chatbot.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.geojit.tekachi.chatbot.entity.Conversation;

public interface ConvoRepo extends JpaRepository<Conversation, Integer> {

}
