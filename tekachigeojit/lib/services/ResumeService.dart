import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tekachigeojit/models/ResumeModels.dart';
import 'package:tekachigeojit/services/AuthService.dart';

enum ResumeServiceErrorCode {
  unauthenticated,
  authExpired,
  timeout,
  unsupportedFile,
  malformedPayload,
  badRequest,
  server,
  network,
  unknown,
}

class ResumeServiceException implements Exception {
  final String message;
  final ResumeServiceErrorCode code;
  final int? statusCode;

  const ResumeServiceException(this.message, this.code, {this.statusCode});

  @override
  String toString() =>
      'ResumeServiceException(code: $code, status: $statusCode, message: $message)';
}

class ResumeService {
  final String baseUrl;
  final http.Client _client;
  final Duration _timeout;

  ResumeService({
    this.baseUrl = 'http://10.0.2.2:8080',
    http.Client? client,
    Duration timeout = const Duration(seconds: 25),
  }) : _client = client ?? http.Client(),
       _timeout = timeout;

  Future<ParsedResume> extractResume(File resumeFile) async {
    final token = AuthService().shareToken();
    if (token == null || token.isEmpty) {
      throw const ResumeServiceException(
        'You are not authenticated. Please login again.',
        ResumeServiceErrorCode.unauthenticated,
      );
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/resume/extract'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', resumeFile.path));

    try {
      final streamedResponse = await _client
          .send(request)
          .timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return _parseResponse(response.body);
      }

      throw _mapHttpError(response.statusCode, response.body);
    } on TimeoutException {
      throw const ResumeServiceException(
        'Resume parsing timed out. Please try again.',
        ResumeServiceErrorCode.timeout,
      );
    } on SocketException {
      throw const ResumeServiceException(
        'Network issue while uploading resume. Please check your connection.',
        ResumeServiceErrorCode.network,
      );
    } on http.ClientException {
      throw const ResumeServiceException(
        'Client error while uploading resume.',
        ResumeServiceErrorCode.network,
      );
    }
  }

  ParsedResume _parseResponse(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        throw const ResumeServiceException(
          'Unexpected response format from resume extraction.',
          ResumeServiceErrorCode.malformedPayload,
        );
      }
      return ParsedResume.fromJson(decoded);
    } on FormatException {
      throw const ResumeServiceException(
        'Malformed JSON received from resume extraction.',
        ResumeServiceErrorCode.malformedPayload,
      );
    }
  }

  ResumeServiceException _mapHttpError(int statusCode, String body) {
    final normalizedBody = body.toLowerCase();

    if (statusCode == 401 || statusCode == 403) {
      return ResumeServiceException(
        'Session expired. Please login again.',
        ResumeServiceErrorCode.authExpired,
        statusCode: statusCode,
      );
    }

    if (statusCode == 408) {
      return ResumeServiceException(
        'Resume parsing request timed out.',
        ResumeServiceErrorCode.timeout,
        statusCode: statusCode,
      );
    }

    if (statusCode == 415 || normalizedBody.contains('unsupported')) {
      return ResumeServiceException(
        'Unsupported resume file. Please upload PDF or DOCX.',
        ResumeServiceErrorCode.unsupportedFile,
        statusCode: statusCode,
      );
    }

    if (statusCode == 400 || statusCode == 422) {
      return ResumeServiceException(
        'Resume file could not be processed. Please verify file content.',
        ResumeServiceErrorCode.badRequest,
        statusCode: statusCode,
      );
    }

    if (statusCode >= 500) {
      return ResumeServiceException(
        'Server error during resume extraction. Please retry later.',
        ResumeServiceErrorCode.server,
        statusCode: statusCode,
      );
    }

    return ResumeServiceException(
      'Resume extraction failed with HTTP $statusCode.',
      ResumeServiceErrorCode.unknown,
      statusCode: statusCode,
    );
  }
}
