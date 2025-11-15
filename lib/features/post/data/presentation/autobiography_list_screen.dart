// lib/features/post/presentation/screens/autobiography_list_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_life_legacy/features/post/data/presentation/autobiography_write_screen.dart';
import 'package:ai_life_legacy/features/user/data/models/user.dto.dart';
import 'package:ai_life_legacy/features/user/data/user_repository.dart';

class AutobiographyListScreen extends StatefulWidget {
  const AutobiographyListScreen({super.key});

  @override
  State<AutobiographyListScreen> createState() =>
      _AutobiographyListScreenState();
}

class _AutobiographyListScreenState extends State<AutobiographyListScreen> {
  final UserRepository _userRepository = Get.find<UserRepository>();

  int? _expandedIndex;
  bool _isLoading = false;
  String? _errorMessage;
  List<UserTocQuestionDto> _sections = [];

  @override
  void initState() {
    super.initState();
    _loadSections();
  }

  Future<void> _loadSections() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _userRepository.getUserTocQuestions();
      if (!mounted) return;
      setState(() {
        _sections = response.data;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _sections = [];
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 자서전'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _loadSections,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _sections.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _sections.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ErrorState(
            message: _errorMessage!,
            onRetry: _loadSections,
          ),
        ],
      );
    }

    if (_sections.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(32),
        children: const [
          Center(
            child: Text(
              '표시할 자서전 질문이 없습니다.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sections.length,
      itemBuilder: (context, index) {
        final section = _sections[index];
        final isExpanded = _expandedIndex == index;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  section.tocTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  '총 ${section.questions.length}개의 질문',
                  style: const TextStyle(fontSize: 13),
                ),
                trailing: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
                onTap: () {
                  setState(() {
                    _expandedIndex = isExpanded ? null : index;
                  });
                },
              ),
              if (isExpanded)
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: section.questions.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            '아직 등록된 질문이 없습니다.',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            ...section.questions.asMap().entries.map(
                              (entry) {
                                final questionIndex = entry.key;
                                final question = entry.value;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: InkWell(
                                    onTap: () async {
                                      final result = await Get.to(
                                        () => AutobiographyWriteScreen(
                                          tocId: section.tocId,
                                          tocTitle: section.tocTitle,
                                          questionId: question.id,
                                          question: question.questionText,
                                        ),
                                      );
                                      if (result == true) {
                                        _loadSections();
                                      }
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${questionIndex + 1}. ',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Expanded(
                                          child: Text(
                                            question.questionText,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          message,
          style: const TextStyle(fontSize: 14, color: Colors.redAccent),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: onRetry,
          child: const Text('다시 시도'),
        ),
      ],
    );
  }
}
