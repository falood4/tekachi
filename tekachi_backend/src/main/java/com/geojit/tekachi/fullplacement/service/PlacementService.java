package com.geojit.tekachi.fullplacement.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.geojit.tekachi.fullplacement.entity.Placement;
import com.geojit.tekachi.fullplacement.repo.PlacementRepo;

@Service
public class PlacementService {

    private final PlacementRepo placementRepo;

    PlacementService(PlacementRepo placementRepo) {
        this.placementRepo = placementRepo;
    }

    public List<Placement> getPlacementsByUserId(int userId) {
        return placementRepo.findByUserId(userId);
    }

    public Placement savePlacement(Placement placement) {
        return placementRepo.save(placement);
    }
}
