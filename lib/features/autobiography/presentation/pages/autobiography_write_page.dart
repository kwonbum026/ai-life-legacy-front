// lib/features/post/presentation/screens/autobiography_write_screen.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_life_legacy/features/autobiography/data/autobiography_repository.dart';
import 'package:ai_life_legacy/features/user/data/models/user.dto.dart';
import 'package:ai_life_legacy/features/user/data/user_repository.dart';

class AutobiographyWritePage extends StatefulWidget {
  final int tocId;
  final int questionId;
  final String question;
  final String tocTitle;

  const AutobiographyWritePage({
    super.key,
    required this.tocId,
    required this.questionId,
    required this.question,
    required this.tocTitle,
  });

  @override
  State<AutobiographyWritePage> createState() => _AutobiographyWritePageState();
}

class _AutobiographyWritePageState extends State<AutobiographyWritePage> {
  late final TextEditingController _answerController;
  late final UserRepository _userRepository;
  late final AutobiographyRepository _postRepository;

  bool _isSaving = false;
  bool _isLoading = true;
  String? _loadError;
  int? _answerId;

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController();
    _userRepository = Get.find<UserRepository>();
    _postRepository = Get.find<AutobiographyRepository>();
    _fetchExistingAnswer();
  }

  Future<void> _fetchExistingAnswer() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final response = await _userRepository.getUserAnswers(
          questionId: widget.questionId, tocId: widget.tocId);
      final answer = response.data;

      _answerId = answer.answerId;
      _answerController.text = answer.answerText;
    } on DioException catch (dioError) {
      if (dioError.response?.statusCode == 404) {
        // 404 Not Found: 답변이 아직 없는 상태이므로 신규 작성 모드로 초기화
        _answerId = null;
        _answerController.text = '';
      } else {
        _loadError = '답변을 불러오지 못했습니다. 다시 시도해주세요.';
      }
    } catch (e) {
      _loadError = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveAnswer() async {
    final text = _answerController.text.trim();
    if (text.isEmpty) {
      _showSnackBar('답변을 입력해주세요.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      if (_answerId == null) {
        // 신규 답변 작성 (Life Legacy API)
        await _postRepository.saveAnswer(
          widget.tocId,
          widget.questionId,
          AnswerSaveDto(answer: text),
        );
      } else {
        // 기존 답변 수정 (User API)
        await _userRepository.updateAnswer(
          _answerId!,
          AnswerUpdateDto(
            tocId: widget.tocId,
            questionId: widget.questionId,
            updateAnswer: text,
          ),
        );
      }

      if (!mounted) return;
      _showSnackBar('답변이 저장되었습니다.');
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('저장에 실패했습니다. 다시 시도해주세요.\n$e');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = _isLoading || _isSaving;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(_answerId == null ? '답변 작성' : '답변 수정'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tocTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (_loadError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.orange),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _loadError!,
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _fetchExistingAnswer,
                            child: const Text('다시 시도'),
                          ),
                        ],
                      ),
                    ),
                  TextField(
                    controller: _answerController,
                    enabled: !isDisabled,
                    maxLines: 12,
                    decoration: InputDecoration(
                      hintText: '답변을 입력하세요...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              isDisabled ? null : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            '이전',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isDisabled ? null : _saveAnswer,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  '저장하기',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
