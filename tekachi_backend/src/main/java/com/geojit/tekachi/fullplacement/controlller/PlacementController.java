package com.geojit.tekachi.fullplacement.controlller;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.geojit.tekachi.fullplacement.dtos.PlacementAttemptDetails;
import com.geojit.tekachi.fullplacement.entity.Placement;
import com.geojit.tekachi.fullplacement.service.PlacementService;
import com.geojit.tekachi.usersignin.entity.User;
import com.geojit.tekachi.usersignin.repository.UserRepository;

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
    private final UserRepository userRepository;

    PlacementController(PlacementService placementService, UserRepository userRepository) {
        this.placementService = placementService;
        this.userRepository = userRepository;
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
        ensurePathUserMatchesAuthenticated(userId);
        return placementService.getPlacementsByUserId(userId).reversed();
    }

    @DeleteMapping("/attempts/{user_id}")
    public Map<String, String> deleteAttempts(@PathVariable("user_id") int userId) {
        try {
            ensurePathUserMatchesAuthenticated(userId);
            placementService.deletePlacementsByUserId(userId);
            return Map.of("message", "All attempts deleted for user id: " + userId);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private User getAuthenticatedUser() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByEmail(email);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Authenticated user not found");
        }
        return user;
    }

    private void ensurePathUserMatchesAuthenticated(int userId) {
        if (getAuthenticatedUser().getId().intValue() != userId) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Cannot access another user's placement attempts");
        }
    }
}
