package com.geojit.tekachi.usersignin.entity;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Entity
@Table(name = "user_profile")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private User user;

    @Column(name = "full_name")
    private String fullName;

    @Column(name = "class10_school")
    private String class10School;

    @Column(name = "class10_board")
    private String class10Board;

    @Column(name = "class10_score")
    private String class10Score;

    @Column(name = "class10_year")
    private Integer class10Year;

    @Column(name = "class12_school")
    private String class12School;

    @Column(name = "class12_board")
    private String class12Board;

    @Column(name = "class12_score")
    private String class12Score;

    @Column(name = "class12_year")
    private Integer class12Year;

    @Column(name = "ug_college")
    private String ugCollege;

    @Column(name = "ug_degree")
    private String ugDegree;

    @Column(name = "ug_score")
    private String ugScore;

    @Column(name = "ug_year")
    private Integer ugYear;

    @OneToMany(mappedBy = "profile", cascade = CascadeType.ALL, orphanRemoval = true)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private List<UserSkill> skills = new ArrayList<>();

    @OneToMany(mappedBy = "profile", cascade = CascadeType.ALL, orphanRemoval = true)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private List<UserLink> links = new ArrayList<>();

    public void replaceSkills(List<String> skillValues) {
        skills.clear();
        if (skillValues == null) {
            return;
        }
        for (String value : skillValues) {
            if (value != null && !value.isBlank()) {
                skills.add(new UserSkill(null, this, value.trim()));
            }
        }
    }

    public void replaceLinks(List<UserLink> linkValues) {
        links.clear();
        if (linkValues == null) {
            return;
        }
        for (UserLink link : linkValues) {
            link.setId(null);
            link.setProfile(this);
            links.add(link);
        }
    }
}
