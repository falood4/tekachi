package com.geojit.tekachi.usersignin.dto;

import java.util.List;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class UserProfileResponse {
    Long userId;
    String email;

    String fullName;
    List<String> skills;
    List<LinkItem> links;

    String class10School;
    String class10Board;
    String class10Score;
    Integer class10Year;

    String class12School;
    String class12Board;
    String class12Score;
    Integer class12Year;

    String ugCollege;
    String ugDegree;
    String ugScore;
    Integer ugYear;

    @Value
    @Builder
    public static class LinkItem {
        String label;
        String url;
    }
}
