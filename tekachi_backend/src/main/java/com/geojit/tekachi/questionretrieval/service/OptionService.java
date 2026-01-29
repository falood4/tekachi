package com.geojit.tekachi.questionretrieval.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.geojit.tekachi.questionretrieval.entity.Option;
import com.geojit.tekachi.questionretrieval.repository.OptionRepo;

@Service
public class OptionService {

    @Autowired
    private OptionRepo optionRepo;

    public Option findById(Integer id) {
        return optionRepo.findById(id).orElse(null);
    }

    public List<Option> findAll() {
        return optionRepo.findAll();
    }
}
