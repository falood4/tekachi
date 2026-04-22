package com.geojit.tekachi.usersignin.dto;

import java.util.List;

import lombok.Data;

@Data
public class UserProfileRequest {
    private String fullName;
    private List<String> skills;
    private List<LinkItem> links;

    private String class10School;
    private String class10Board;
    private String class10Score;
    private Integer class10Year;

    private String class12School;
    private String class12Board;
    private String class12Score;
    private Integer class12Year;

    private String ugCollege;
    private String ugDegree;
    private String ugScore;
    private Integer ugYear;

    @Data
    public static class LinkItem {
        private String label;
        private String url;
    }
}
