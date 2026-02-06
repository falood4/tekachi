package com.geojit.tekachi.quizhistory.dtos;

import java.time.LocalDateTime;

public interface AttemptView {

        Long getAttemptId();

        Long getUserId();

        LocalDateTime getAttemptedOn();

        String getScore();
}
