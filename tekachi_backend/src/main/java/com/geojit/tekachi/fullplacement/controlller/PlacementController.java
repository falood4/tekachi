package com.geojit.tekachi.fullplacement.controlller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.geojit.tekachi.fullplacement.entity.Placement;
import com.geojit.tekachi.fullplacement.service.PlacementService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@RestController
@RequestMapping("/placement")
public class PlacementController {

    PlacementService placementService;

    PlacementController(PlacementService placementService) {
        this.placementService = placementService;
    }

    @PostMapping("/new")
    public Placement saveAttempt(@RequestBody Map<String, Integer> attempt) {
        try {
            int userId = attempt.get("userId");
            int aptAttemptId = attempt.get("aptAttemptId");
            int techInterviewId = attempt.get("techInterviewId");
            int hrInterviewId = attempt.get("hrInterviewId");

            Placement placement = new Placement();
            placement.setUser_id(userId);
            placement.setAttempted_on(LocalDateTime.now());
            placement.setApt_attempt(aptAttemptId);
            placement.setTech_interview(techInterviewId);
            placement.setHr_interview(hrInterviewId);

            placementService.savePlacement(placement);

            return placement;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @GetMapping("/attempts/{user_id}")
    public List<Placement> getAttempts(@PathVariable("user_id") int userId) {
        return placementService.getPlacementsByUserId(userId);
    }

}
