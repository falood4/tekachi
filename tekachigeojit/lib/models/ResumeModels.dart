class ParsedResume {
  final ResumePersonalInfo personalInfo;
  final String summary;
  final List<String> skills;
  final List<ResumeExperience> experiences;
  final List<ResumeEducation> education;
  final List<ResumeProject> projects;
  final List<String> certifications;
  final Map<String, dynamic> raw;

  ParsedResume({
    required this.personalInfo,
    required this.summary,
    required this.skills,
    required this.experiences,
    required this.education,
    required this.projects,
    required this.certifications,
    required this.raw,
  });

  factory ParsedResume.fromJson(Map<String, dynamic> json) {
    return ParsedResume(
      personalInfo: ResumePersonalInfo.fromJson(
        _asMap(json['personalInfo']) ?? _asMap(json['profile']) ?? const {},
      ),
      summary: _asString(json['summary']) ?? _asString(json['objective']) ?? '',
      skills: _asStringList(json['skills']),
      experiences: _asList(json['experiences'])
          .map((e) => ResumeExperience.fromJson(_asMap(e) ?? const {}))
          .toList(),
      education: _asList(json['education'])
          .map((e) => ResumeEducation.fromJson(_asMap(e) ?? const {}))
          .toList(),
      projects: _asList(json['projects'])
          .map((e) => ResumeProject.fromJson(_asMap(e) ?? const {}))
          .toList(),
      certifications: _asStringList(json['certifications']),
      raw: Map<String, dynamic>.from(json),
    );
  }
}

class ResumePersonalInfo {
  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String linkedIn;
  final String github;

  ResumePersonalInfo({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    required this.linkedIn,
    required this.github,
  });

  factory ResumePersonalInfo.fromJson(Map<String, dynamic> json) {
    return ResumePersonalInfo(
      fullName: _asString(json['fullName']) ?? _asString(json['name']) ?? '',
      email: _asString(json['email']) ?? '',
      phone: _asString(json['phone']) ?? '',
      location: _asString(json['location']) ?? '',
      linkedIn: _asString(json['linkedIn']) ?? _asString(json['linkedin']) ?? '',
      github: _asString(json['github']) ?? '',
    );
  }
}

class ResumeExperience {
  final String company;
  final String role;
  final String startDate;
  final String endDate;
  final List<String> highlights;

  ResumeExperience({
    required this.company,
    required this.role,
    required this.startDate,
    required this.endDate,
    required this.highlights,
  });

  factory ResumeExperience.fromJson(Map<String, dynamic> json) {
    return ResumeExperience(
      company: _asString(json['company']) ?? '',
      role: _asString(json['role']) ?? _asString(json['title']) ?? '',
      startDate: _asString(json['startDate']) ?? '',
      endDate: _asString(json['endDate']) ?? '',
      highlights: _asStringList(json['highlights']),
    );
  }
}

class ResumeEducation {
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final String graduationYear;

  ResumeEducation({
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.graduationYear,
  });

  factory ResumeEducation.fromJson(Map<String, dynamic> json) {
    return ResumeEducation(
      institution: _asString(json['institution']) ?? '',
      degree: _asString(json['degree']) ?? '',
      fieldOfStudy: _asString(json['fieldOfStudy']) ?? '',
      graduationYear: _asString(json['graduationYear']) ?? '',
    );
  }
}

class ResumeProject {
  final String name;
  final String description;
  final List<String> technologies;

  ResumeProject({
    required this.name,
    required this.description,
    required this.technologies,
  });

  factory ResumeProject.fromJson(Map<String, dynamic> json) {
    return ResumeProject(
      name: _asString(json['name']) ?? '',
      description: _asString(json['description']) ?? '',
      technologies: _asStringList(json['technologies']),
    );
  }
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.map((k, v) => MapEntry('$k', v));
  return null;
}

List<dynamic> _asList(dynamic value) {
  if (value is List) return value;
  return const [];
}

String? _asString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  return null;
}

List<String> _asStringList(dynamic value) {
  if (value is List) {
    return value
        .map(_asString)
        .whereType<String>()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  if (value is String && value.trim().isNotEmpty) {
    return value
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  return const [];
}
