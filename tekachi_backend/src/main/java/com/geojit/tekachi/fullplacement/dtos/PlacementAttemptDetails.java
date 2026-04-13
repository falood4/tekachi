package com.geojit.tekachi.fullplacement.dtos;

import java.time.LocalDateTime;

public interface PlacementAttemptDetails {
    Integer getTestId();

    Integer getUserId();

    LocalDateTime getAttemptedOn();

    Integer getAttemptId();

    String getScore();

    Integer getTechConversationId();

    String getTechVerdict();

    Integer getHrConversationId();

    String getHrVerdict();
}
