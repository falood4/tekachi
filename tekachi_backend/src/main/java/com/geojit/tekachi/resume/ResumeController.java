package com.geojit.tekachi.resume;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.geojit.tekachi.resume.dto.ResumeExtractRequest;
import com.geojit.tekachi.resume.dto.ResumeExtractResponse;
import com.geojit.tekachi.resume.service.ResumeExtractionService;
import com.geojit.tekachi.usersignin.entity.User;
import com.geojit.tekachi.usersignin.repository.UserRepository;

@RestController
@RequestMapping("/resume")
public class ResumeController {

    private final ResumeExtractionService resumeExtractionService;
    private final UserRepository userRepository;

    public ResumeController(ResumeExtractionService resumeExtractionService, UserRepository userRepository) {
        this.resumeExtractionService = resumeExtractionService;
        this.userRepository = userRepository;
    }

    @PostMapping("/extract")
    public ResponseEntity<ResumeExtractResponse> extractResume(@ModelAttribute ResumeExtractRequest request) {
        User user = getAuthenticatedUser();
        ResumeExtractResponse response = resumeExtractionService.extractFromPdf(request.getFile(), user);
        return ResponseEntity.ok(response);
    }

    private User getAuthenticatedUser() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByEmail(email);
        if (user == null) {
            throw new IllegalStateException("Authenticated user not found");
        }
        return user;
    }
}
