import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tekachigeojit/services/AuthService.dart';

class ProfileAutofillPage extends StatefulWidget {
  const ProfileAutofillPage({super.key});

  @override
  State<ProfileAutofillPage> createState() => _ProfileAutofillPageState();
}

class _ProfileAutofillPageState extends State<ProfileAutofillPage> {
  static const String _resumeExtractUrl = 'http://10.0.2.2:8080/resume/extract';
  static const String _resumeSaveUrl = 'http://10.0.2.2:8080/resume/profile';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _linksController = TextEditingController();
  final TextEditingController _class10Controller = TextEditingController();
  final TextEditingController _class12Controller = TextEditingController();
  final TextEditingController _ugCgpaController = TextEditingController();

  final Set<String> _machineExtractedFields = <String>{};
  final List<String> _skillTags = <String>[];

  bool _isUploading = false;
  bool _isSaving = false;
  String? _selectedFileName;

  @override
  void dispose() {
    _nameController.dispose();
    _skillsController.dispose();
    _linksController.dispose();
    _class10Controller.dispose();
    _class12Controller.dispose();
    _ugCgpaController.dispose();
    super.dispose();
  }

  Future<void> _pickAndExtractPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const <String>['pdf'],
      withData: false,
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final pickedFile = result.files.single;
    if (pickedFile.path == null) {
      _showSnackBar('Unable to read selected file path.');
      return;
    }

    setState(() {
      _isUploading = true;
      _selectedFileName = pickedFile.name;
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(_resumeExtractUrl),
      );
      final token = AuthService().shareToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.files.add(
        await http.MultipartFile.fromPath('file', pickedFile.path!),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (!mounted) {
        return;
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        _applyExtractedData(data);
        _showSnackBar('Resume parsed. Please verify and edit before saving.');
      } else {
        _showSnackBar('Extraction failed (${response.statusCode}).');
      }
    } catch (_) {
      _showSnackBar('Resume upload failed. Please retry.');
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _saveProfileData() async {
    setState(() {
      _isSaving = true;
    });

    final Map<String, dynamic> payload = <String, dynamic>{
      'name': _nameController.text.trim(),
      'skills': _skillTags,
      'links': _splitCsv(_linksController.text),
      'class10': _class10Controller.text.trim(),
      'class12': _class12Controller.text.trim(),
      'ugCgpa': _ugCgpaController.text.trim(),
    };

    try {
      final token = AuthService().shareToken();
      final response = await http.post(
        Uri.parse(_resumeSaveUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (!mounted) {
        return;
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _showSnackBar('Profile details updated successfully.');
      } else {
        _showSnackBar(
          'Unable to save to server (${response.statusCode}). Data remains editable on screen.',
        );
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showSnackBar('Network error while saving profile.');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _applyExtractedData(Map<String, dynamic> data) {
    final String name = _pickString(data, const <String>['name', 'fullName']);
    final String class10 = _pickString(data, const <String>['class10', 'tenth', 'sslc']);
    final String class12 = _pickString(data, const <String>['class12', 'twelfth', 'hsc']);
    final String ugCgpa = _pickString(data, const <String>['ugCgpa', 'ug', 'cgpa']);

    final List<String> skills = _pickList(data, const <String>['skills']);
    final List<String> links = _pickList(data, const <String>['links', 'profiles']);

    setState(() {
      _machineExtractedFields
        ..clear()
        ..addAll(const <String>['name', 'skills', 'links', 'class10', 'class12', 'ugCgpa']);

      _nameController.text = name;
      _class10Controller.text = class10;
      _class12Controller.text = class12;
      _ugCgpaController.text = ugCgpa;

      _skillTags
        ..clear()
        ..addAll(skills);
      _skillsController.text = _skillTags.join(', ');

      _linksController.text = links.join(', ');
    });
  }

  String _pickString(Map<String, dynamic> data, List<String> keys) {
    for (final String key in keys) {
      final dynamic value = data[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
    return '';
  }

  List<String> _pickList(Map<String, dynamic> data, List<String> keys) {
    for (final String key in keys) {
      final dynamic value = data[key];
      if (value is List) {
        return value
            .map((dynamic item) => item.toString().trim())
            .where((String item) => item.isNotEmpty)
            .toList();
      }
      if (value is String && value.trim().isNotEmpty) {
        return _splitCsv(value);
      }
    }
    return <String>[];
  }

  List<String> _splitCsv(String input) {
    return input
        .split(',')
        .map((String item) => item.trim())
        .where((String item) => item.isNotEmpty)
        .toList();
  }

  void _addSkillTagFromInput() {
    final List<String> parsed = _splitCsv(_skillsController.text);
    setState(() {
      _skillTags
        ..clear()
        ..addAll(parsed.toSet());
      _skillsController.text = _skillTags.join(', ');
    });
  }

  void _removeSkillTag(String skill) {
    setState(() {
      _skillTags.remove(skill);
      _skillsController.text = _skillTags.join(', ');
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Autofill'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Upload Resume (PDF)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isUploading ? null : _pickAndExtractPdf,
                    icon: _isUploading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload_file),
                    label: Text(_isUploading ? 'Extracting...' : 'Pick PDF & Autofill'),
                  ),
                ),
              ],
            ),
            if (_selectedFileName != null) ...<Widget>[
              const SizedBox(height: 8),
              Text('Selected: $_selectedFileName'),
            ],
            const SizedBox(height: 8),
            Text(
              'Machine extracted values are marked and remain fully editable.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 18),
            _buildMarkedTextField(
              label: 'Name',
              fieldKey: 'name',
              controller: _nameController,
            ),
            const SizedBox(height: 14),
            _buildSkillsEditor(screenWidth),
            const SizedBox(height: 14),
            _buildMarkedTextField(
              label: 'Links',
              hintText: 'Portfolio, LinkedIn, GitHub (comma-separated)',
              fieldKey: 'links',
              controller: _linksController,
              maxLines: 2,
            ),
            const SizedBox(height: 14),
            _buildMarkedTextField(
              label: 'Class 10th (%)',
              fieldKey: 'class10',
              controller: _class10Controller,
            ),
            const SizedBox(height: 14),
            _buildMarkedTextField(
              label: 'Class 12th (%)',
              fieldKey: 'class12',
              controller: _class12Controller,
            ),
            const SizedBox(height: 14),
            _buildMarkedTextField(
              label: 'UG CGPA',
              fieldKey: 'ugCgpa',
              controller: _ugCgpaController,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveProfileData,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save / Update Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsEditor(double screenWidth) {
    final bool isExtracted = _machineExtractedFields.contains('skills');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isExtracted ? Colors.orangeAccent : Colors.grey.shade400,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isExtracted ? Colors.orange.shade50 : Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('Skills', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(width: 8),
              if (isExtracted)
                _machineTag(),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _skillsController,
            decoration: InputDecoration(
              hintText: 'Comma-separated skills',
              suffixIcon: IconButton(
                onPressed: _addSkillTagFromInput,
                icon: const Icon(Icons.add),
                tooltip: 'Update chips',
              ),
            ),
            onSubmitted: (_) => _addSkillTagFromInput(),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _skillTags
                .map(
                  (String skill) => Chip(
                    label: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: screenWidth * 0.55),
                      child: Text(skill, overflow: TextOverflow.ellipsis),
                    ),
                    onDeleted: () => _removeSkillTag(skill),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkedTextField({
    required String label,
    required String fieldKey,
    required TextEditingController controller,
    String? hintText,
    int maxLines = 1,
  }) {
    final bool isExtracted = _machineExtractedFields.contains(fieldKey);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isExtracted ? Colors.orangeAccent : Colors.grey.shade400,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isExtracted ? Colors.orange.shade50 : Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(label, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(width: 8),
              if (isExtracted)
                _machineTag(),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(hintText: hintText),
          ),
        ],
      ),
    );
  }

  Widget _machineTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'AI extracted',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
