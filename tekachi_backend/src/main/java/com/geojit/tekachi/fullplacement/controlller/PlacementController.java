package com.geojit.tekachi.fullplacement.controlller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.geojit.tekachi.fullplacement.dtos.PlacementAttemptDetails;
import com.geojit.tekachi.fullplacement.entity.Placement;
import com.geojit.tekachi.fullplacement.service.PlacementService;
import com.geojit.tekachi.quizhistory.services.AnswerService;

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

    private final PlacementService placementService;
    private final AnswerService quizAnswerService;

    PlacementController(PlacementService placementService, AnswerService quizAnswerService) {
        this.placementService = placementService;
        this.quizAnswerService = quizAnswerService;
    }

    @PostMapping("/new")
    public Map<String, Object> saveAttempt(@RequestBody Map<String, Integer> attempt) {
        try {
            int userId = attempt.get("userId");
            int aptAttemptId = attempt.get("aptAttemptId");
            int techInterviewId = attempt.get("techInterviewId");
            int hrInterviewId = attempt.get("hrInterviewId");

            Placement placement = new Placement();
            placement.setUser_id(userId);
            placement.setAttempted_on(LocalDateTime.now());
            placement.setApt_attempt(aptAttemptId); // quiz
            placement.setTech_interview(techInterviewId); // tech interview
            placement.setHr_interview(hrInterviewId); // hr interview

            Placement savedPlacement = placementService.savePlacement(placement);

            return Map.of(
                    "message", "3step attempt saved",
                    "placement", savedPlacement);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @GetMapping("/attempts/{user_id}")
    public List<PlacementAttemptDetails> getAttemptTest(@PathVariable("user_id") int userId) {
        // getOwnedAttempt(userId);
        return placementService.getPlacementsByUserId(userId);
    }
} 
