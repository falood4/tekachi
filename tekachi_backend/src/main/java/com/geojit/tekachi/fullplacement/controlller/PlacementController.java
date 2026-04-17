package com.geojit.tekachi.fullplacement.controlller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.service.annotation.DeleteExchange;

import com.geojit.tekachi.fullplacement.dtos.PlacementAttemptDetails;
import com.geojit.tekachi.fullplacement.entity.Placement;
import com.geojit.tekachi.fullplacement.service.PlacementService;
import com.geojit.tekachi.quizhistory.services.AnswerService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.DeleteMapping;
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
            Integer userId = attempt.get("userId");
            Integer aptAttemptId = attempt.get("aptAttemptId");
            Integer techInterviewId = attempt.get("techInterviewId");
            Integer hrInterviewId = attempt.get("hrInterviewId");

            Placement placement = new Placement();
            placement.setUserId(userId);
            placement.setAttemptedOn(LocalDateTime.now());
            placement.setAptAttemptId(aptAttemptId); // quiz
            placement.setTechInterviewId(techInterviewId); // tech interview
            placement.setHrInterviewId(hrInterviewId); // hr interview

            Placement savedPlacement = placementService.savePlacement(placement);

            return Map.of(
                    "message", "3step attempt saved",
                    "placement", savedPlacement);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @GetMapping("/attempts/{user_id}")
    public List<PlacementAttemptDetails> getAttempts(@PathVariable("user_id") int userId) {
        // getOwnedAttempt(userId);
        return placementService.getPlacementsByUserId(userId).reversed();
    }

    @DeleteMapping("attempts/{user_id}")
    public Map<String, String> deleteAttempts(@PathVariable("user_id") int userId) {
        try {
            placementService.deletePlacementsByUserId(userId);
            return Map.of("message", "All attempts deleted for user id: " + userId);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
