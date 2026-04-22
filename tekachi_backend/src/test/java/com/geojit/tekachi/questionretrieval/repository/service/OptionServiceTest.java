package com.geojit.tekachi.questionretrieval.repository.service;

import com.geojit.tekachi.questionretrieval.entity.Option;
import com.geojit.tekachi.questionretrieval.repository.OptionRepo;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class OptionServiceTest {

    @Mock
    private OptionRepo optionRepo;

    @InjectMocks
    private OptionService optionService;

    @Test
    void findByIdReturnsOptionWhenPresent() {
        Option option = new Option();
        option.setOpId(10);
        when(optionRepo.findById(10)).thenReturn(Optional.of(option));

        Option actual = optionService.findById(10);

        assertSame(option, actual);
    }

    @Test
    void findByIdReturnsNullWhenMissing() {
        when(optionRepo.findById(11)).thenReturn(Optional.empty());

        Option actual = optionService.findById(11);

        assertNull(actual);
    }

    @Test
    void findAllDelegatesToRepository() {
        List<Option> options = List.of(new Option(), new Option());
        when(optionRepo.findAll()).thenReturn(options);

        List<Option> actual = optionService.findAll();

        assertSame(options, actual);
    }
}
