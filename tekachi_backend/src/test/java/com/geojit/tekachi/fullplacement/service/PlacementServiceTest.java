package com.geojit.tekachi.fullplacement.service;

import com.geojit.tekachi.fullplacement.dtos.PlacementAttemptDetails;
import com.geojit.tekachi.fullplacement.entity.Placement;
import com.geojit.tekachi.fullplacement.repo.PlacementRepo;
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
class PlacementServiceTest {

    @Mock
    private PlacementRepo placementRepo;

    @InjectMocks
    private PlacementService placementService;

    @Test
    void getPlacementsByUserIdDelegatesToRepository() {
        List<PlacementAttemptDetails> expected = List.of(org.mockito.Mockito.mock(PlacementAttemptDetails.class));
        when(placementRepo.findByUserId(7)).thenReturn(expected);

        List<PlacementAttemptDetails> actual = placementService.getPlacementsByUserId(7);

        assertSame(expected, actual);
        verify(placementRepo).findByUserId(7);
    }

    @Test
    void savePlacementDelegatesToRepository() {
        Placement placement = new Placement();
        Placement saved = new Placement();
        when(placementRepo.save(placement)).thenReturn(saved);

        Placement actual = placementService.savePlacement(placement);

        assertSame(saved, actual);
        verify(placementRepo).save(placement);
    }

    @Test
    void deletePlacementsByUserIdDelegatesToRepository() {
        placementService.deletePlacementsByUserId(9);

        verify(placementRepo).deleteByUserId(9);
    }
}
