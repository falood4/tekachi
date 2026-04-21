import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tekachigeojit/services/AuthService.dart';
import 'package:tekachigeojit/services/ResumeService.dart';

void main() {
  late File tempResume;

  setUp(() async {
    tempResume = await File(
      '${Directory.systemTemp.path}/resume_test.txt',
    ).create();
    await tempResume.writeAsString('resume-body');
    AuthService().setToken('valid-token', 123);
  });

  tearDown(() async {
    AuthService().clearCredentials();
    if (await tempResume.exists()) {
      await tempResume.delete();
    }
  });

  test('extractResume returns parsed resume for 200 response', () async {
    final client = MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer valid-token');
      return http.Response(
        '{"personalInfo":{"fullName":"Jane Doe"},"skills":["Flutter"]}',
        200,
      );
    });

    final service = ResumeService(client: client);
    final result = await service.extractResume(tempResume);

    expect(result.personalInfo.fullName, 'Jane Doe');
    expect(result.skills, ['Flutter']);
  });

  test('extractResume throws authExpired for 401', () async {
    final client = MockClient((request) async => http.Response('expired', 401));
    final service = ResumeService(client: client);

    expect(
      () => service.extractResume(tempResume),
      throwsA(
        isA<ResumeServiceException>().having(
          (e) => e.code,
          'code',
          ResumeServiceErrorCode.authExpired,
        ),
      ),
    );
  });

  test('extractResume throws unsupportedFile for 415', () async {
    final client = MockClient(
      (request) async => http.Response('unsupported file type', 415),
    );
    final service = ResumeService(client: client);

    expect(
      () => service.extractResume(tempResume),
      throwsA(
        isA<ResumeServiceException>().having(
          (e) => e.code,
          'code',
          ResumeServiceErrorCode.unsupportedFile,
        ),
      ),
    );
  });

  test('extractResume throws malformedPayload for invalid json', () async {
    final client = MockClient((request) async => http.Response('not-json', 200));
    final service = ResumeService(client: client);

    expect(
      () => service.extractResume(tempResume),
      throwsA(
        isA<ResumeServiceException>().having(
          (e) => e.code,
          'code',
          ResumeServiceErrorCode.malformedPayload,
        ),
      ),
    );
  });

  test('extractResume throws timeout when client delays past timeout', () async {
    final client = MockClient((request) async {
      await Future<void>.delayed(const Duration(milliseconds: 60));
      return http.Response('{}', 200);
    });
    final service = ResumeService(
      client: client,
      timeout: const Duration(milliseconds: 10),
    );

    expect(
      () => service.extractResume(tempResume),
      throwsA(
        isA<ResumeServiceException>().having(
          (e) => e.code,
          'code',
          ResumeServiceErrorCode.timeout,
        ),
      ),
    );
  });

  test('extractResume throws unauthenticated when token is missing', () async {
    AuthService().clearCredentials();
    final service = ResumeService(
      client: MockClient((_) async => http.Response('{}', 200)),
    );

    expect(
      () => service.extractResume(tempResume),
      throwsA(
        isA<ResumeServiceException>().having(
          (e) => e.code,
          'code',
          ResumeServiceErrorCode.unauthenticated,
        ),
      ),
    );
  });
}
