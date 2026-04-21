import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tekachigeojit/models/ResumeModels.dart';

void main() {
  test('ParsedResume.fromJson maps nested payload safely', () {
    final parsed = ParsedResume.fromJson({
      'personalInfo': {
        'fullName': 'Jane Doe',
        'email': 'jane@example.com',
      },
      'summary': 'Mobile developer',
      'skills': ['Flutter', 'Dart'],
      'experiences': [
        {
          'company': 'Tekachi',
          'role': 'Engineer',
          'highlights': ['Built resume parser'],
        },
      ],
      'education': [
        {'institution': 'XYZ University', 'degree': 'B.Tech'},
      ],
      'projects': [
        {
          'name': 'Resume Analyzer',
          'description': 'Extracts skills',
          'technologies': ['Flutter', 'Spring Boot'],
        },
      ],
      'certifications': 'AWS, GCP',
    });

    expect(parsed.personalInfo.fullName, 'Jane Doe');
    expect(parsed.skills, ['Flutter', 'Dart']);
    expect(parsed.experiences.first.company, 'Tekachi');
    expect(parsed.certifications, ['AWS', 'GCP']);
  });

  testWidgets('Parsed resume data can be rendered in a lightweight widget', (
    tester,
  ) async {
    final parsed = ParsedResume.fromJson({
      'personalInfo': {'name': 'Sam Candidate'},
      'skills': ['Dart'],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Text(parsed.personalInfo.fullName),
              Text(parsed.skills.join(', ')),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Sam Candidate'), findsOneWidget);
    expect(find.text('Dart'), findsOneWidget);
  });
}
