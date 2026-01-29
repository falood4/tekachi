package com.geojit.tekachi.questionretrieval.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import com.geojit.tekachi.questionretrieval.entity.Option;
import com.geojit.tekachi.questionretrieval.service.OptionService;

@RestController
@RequestMapping("/")
public class OptionController {
    @Autowired
    private OptionService optionService;

    @GetMapping("/options/{id}")
    public Option getOption(@PathVariable Integer id) {
        return optionService.findById(id);
    }

    @GetMapping("/options")
    public List<Option> getAllOption() {
        return optionService.findAll();
    }
}
