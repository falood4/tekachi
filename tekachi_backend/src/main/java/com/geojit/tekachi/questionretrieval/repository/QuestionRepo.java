package com.geojit.tekachi.questionretrieval.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.geojit.tekachi.questionretrieval.entity.Question;

@Repository
public interface QuestionRepo extends JpaRepository<Question, Integer> {

}
