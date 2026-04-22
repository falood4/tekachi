package com.geojit.tekachi.questionretrieval.controller;

import com.geojit.tekachi.questionretrieval.entity.Option;
import com.geojit.tekachi.questionretrieval.repository.service.OptionService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertSame;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class OptionControllerTest {

    @Mock
    private OptionService optionService;

    @InjectMocks
    private OptionController optionController;

    @Test
    void getOptionDelegatesToService() {
        Option option = new Option();
        option.setOpId(2);
        when(optionService.findById(2)).thenReturn(option);

        Option actual = optionController.getOption(2);

        assertSame(option, actual);
        verify(optionService).findById(2);
    }

    @Test
    void getAllOptionDelegatesToService() {
        List<Option> options = List.of(new Option());
        when(optionService.findAll()).thenReturn(options);

        List<Option> actual = optionController.getAllOption();

        assertSame(options, actual);
        verify(optionService).findAll();
    }
}
