package com.geojit.tekachi.quizhistory.dtos;

public interface AnswerView {

    Integer getAnswerId();

    Integer getAttemptId();

    Integer getQId();

    String getQString();

    Integer getSelectedOption();
}
