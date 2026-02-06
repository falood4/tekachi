package com.geojit.tekachi.quizhistory.dtos;

public interface AttemptView {

        Long getAttemptId();

        Long getUserId();

        Long getAnswerId();

        Integer getQId();

        String getQString();

        Integer getOpId();

        String getOp();

        Integer getQCorrectOption();

        Integer getIsSelected();
}
