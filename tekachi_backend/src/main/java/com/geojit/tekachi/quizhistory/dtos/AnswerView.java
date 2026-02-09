package com.geojit.tekachi.quizhistory.dtos;

public interface AnswerView {
    Long getAnswerId();

    Long getAttemptId();

    Long getQId();

    String getQString();

    Long getSelectedOption();

    String getSelectedOptionText();

    Long getCorrectOption();

    String getCorrectOptionText();
}
