package com.geojit.tekachi.resume.dto;

import java.util.List;

public class ResumeExtractResponse {

    private Long userId;
    private String userEmail;
    private String fullName;
    private List<String> skills;
    private LinksDto links;
    private EducationDto education;

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public List<String> getSkills() {
        return skills;
    }

    public void setSkills(List<String> skills) {
        this.skills = skills;
    }

    public LinksDto getLinks() {
        return links;
    }

    public void setLinks(LinksDto links) {
        this.links = links;
    }

    public EducationDto getEducation() {
        return education;
    }

    public void setEducation(EducationDto education) {
        this.education = education;
    }
}
