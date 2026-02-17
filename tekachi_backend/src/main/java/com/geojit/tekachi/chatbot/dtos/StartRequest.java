package com.geojit.tekachi.chatbot.dtos;

public class StartRequest {

    private Long userId;
    private Integer personaId;

    public Long getUserId() {
        return userId;
    }

    public Integer getPersonaId() {
        return personaId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public void setPersonaId(Integer personaId) {
        this.personaId = personaId;
    }
}
