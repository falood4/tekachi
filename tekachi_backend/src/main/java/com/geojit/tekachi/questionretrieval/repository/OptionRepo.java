package com.geojit.tekachi.questionretrieval.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.geojit.tekachi.questionretrieval.entity.Option;

public interface OptionRepo extends JpaRepository<Option, Integer> {

}
