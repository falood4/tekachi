package com.geojit.tekachi.fullplacement.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.geojit.tekachi.fullplacement.dtos.PlacementAttemptDetails;
import com.geojit.tekachi.fullplacement.dtos.PlacementAttemptView;
import com.geojit.tekachi.fullplacement.entity.Placement;
import com.geojit.tekachi.fullplacement.repo.PlacementRepo;

@Service
public class PlacementService {

    private final PlacementRepo placementRepo;

    PlacementService(PlacementRepo placementRepo) {
        this.placementRepo = placementRepo;
    }

    public List<PlacementAttemptView> getPlacementsByUserId(int userId) {
        return placementRepo.findByUserId(userId);
    }

    public PlacementAttemptDetails getPlacementsByAttemptId(int attemptId) {
        return placementRepo.findByAttempt(attemptId);
    }

    public Placement savePlacement(Placement placement) {
        return placementRepo.save(placement);
    }
}
