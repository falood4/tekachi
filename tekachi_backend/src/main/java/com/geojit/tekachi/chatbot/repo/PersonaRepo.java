package com.geojit.tekachi.chatbot.repo;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.geojit.tekachi.chatbot.entity.Persona;

public interface PersonaRepo extends JpaRepository<Persona, Integer> {

    Optional<Persona> findByPersonaIdAndIsActiveTrue(Integer personaId);

    Optional<Persona> findByPersonaIdAndIsActiveTrue(Persona persona);
}
