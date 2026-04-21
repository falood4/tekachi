package com.geojit.tekachi.usersignin.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.geojit.tekachi.usersignin.dto.UserProfileRequest;
import com.geojit.tekachi.usersignin.dto.UserProfileResponse;
import com.geojit.tekachi.usersignin.entity.User;
import com.geojit.tekachi.usersignin.entity.UserLink;
import com.geojit.tekachi.usersignin.entity.UserProfile;
import com.geojit.tekachi.usersignin.repository.UserProfileRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserProfileService {

    private final UserProfileRepository userProfileRepository;

    @Transactional
    public UserProfileResponse getProfile(User user) {
        UserProfile profile = userProfileRepository.findByUserId(user.getId())
                .orElseGet(() -> createEmptyProfile(user));
        return toResponse(user, profile);
    }

    @Transactional
    public UserProfileResponse updateProfile(User user, UserProfileRequest request) {
        UserProfile profile = userProfileRepository.findByUserId(user.getId())
                .orElseGet(() -> createEmptyProfile(user));

        profile.setFullName(request.getFullName());

        profile.setClass10School(request.getClass10School());
        profile.setClass10Board(request.getClass10Board());
        profile.setClass10Score(request.getClass10Score());
        profile.setClass10Year(request.getClass10Year());

        profile.setClass12School(request.getClass12School());
        profile.setClass12Board(request.getClass12Board());
        profile.setClass12Score(request.getClass12Score());
        profile.setClass12Year(request.getClass12Year());

        profile.setUgCollege(request.getUgCollege());
        profile.setUgDegree(request.getUgDegree());
        profile.setUgScore(request.getUgScore());
        profile.setUgYear(request.getUgYear());

        profile.replaceSkills(request.getSkills());
        profile.replaceLinks(toLinkEntities(request));

        UserProfile saved = userProfileRepository.save(profile);
        return toResponse(user, saved);
    }

    private UserProfile createEmptyProfile(User user) {
        UserProfile profile = new UserProfile();
        profile.setUser(user);
        return userProfileRepository.save(profile);
    }

    private List<UserLink> toLinkEntities(UserProfileRequest request) {
        List<UserLink> links = new ArrayList<>();
        if (request.getLinks() == null) {
            return links;
        }

        for (UserProfileRequest.LinkItem link : request.getLinks()) {
            if (link.getUrl() == null || link.getUrl().isBlank()) {
                continue;
            }
            UserLink linkEntity = new UserLink();
            linkEntity.setLabel(link.getLabel());
            linkEntity.setUrl(link.getUrl().trim());
            links.add(linkEntity);
        }
        return links;
    }

    private UserProfileResponse toResponse(User user, UserProfile profile) {
        List<String> skills = profile.getSkills().stream()
                .map(skill -> skill.getSkill())
                .toList();

        List<UserProfileResponse.LinkItem> links = profile.getLinks().stream()
                .map(link -> UserProfileResponse.LinkItem.builder()
                        .label(link.getLabel())
                        .url(link.getUrl())
                        .build())
                .toList();

        return UserProfileResponse.builder()
                .userId(user.getId())
                .email(user.getEmail())
                .fullName(profile.getFullName())
                .skills(skills)
                .links(links)
                .class10School(profile.getClass10School())
                .class10Board(profile.getClass10Board())
                .class10Score(profile.getClass10Score())
                .class10Year(profile.getClass10Year())
                .class12School(profile.getClass12School())
                .class12Board(profile.getClass12Board())
                .class12Score(profile.getClass12Score())
                .class12Year(profile.getClass12Year())
                .ugCollege(profile.getUgCollege())
                .ugDegree(profile.getUgDegree())
                .ugScore(profile.getUgScore())
                .ugYear(profile.getUgYear())
                .build();
    }
}
