import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_life_legacy/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ai_life_legacy/app/core/routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isSignUpMode = false;
  
  AuthController get controller => Get.find<AuthController>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),

                // 로그인/회원가입 탭 전환
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTabButton(
                        '로그인',
                        !isSignUpMode,
                        () => setState(() => isSignUpMode = false),
                      ),
                      const SizedBox(width: 20),
                      _buildTabButton(
                        '회원가입',
                        isSignUpMode,
                        () => setState(() => isSignUpMode = true),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Center(
                  child: Text(
                    isSignUpMode ? '회원가입' : '로그인',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                const Text(
                  '이메일',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: '이메일을 입력해주세요.',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 15,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 28),

                const Text(
                  '비밀번호',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '비밀번호를 입력해주세요.',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 15,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // 로그인/회원가입 버튼
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.loading.value
                        ? null
                        : () async {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            if (email.isEmpty || password.isEmpty) {
                              Get.snackbar(
                                '입력 필요',
                                '이메일과 비밀번호를 입력하세요.',
                              );
                              return;
                            }

                            if (isSignUpMode) {
                              // 회원가입
                              final ok = await controller.signUp(email, password);
                              if (ok) {
                                Get.snackbar(
                                  '회원가입 성공',
                                  '환영합니다!',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                                Get.offAllNamed(Routes.home);
                              } else {
                                Get.snackbar(
                                  '회원가입 실패',
                                  controller.errorMessage.value.isEmpty
                                      ? '이메일 또는 비밀번호를 확인하세요.'
                                      : controller.errorMessage.value,
                                );
                              }
                            } else {
                              // 로그인
                              final ok = await controller.login(email, password);
                              if (ok) {
                                Get.offAllNamed(Routes.home);
                              } else {
                                Get.snackbar(
                                  '로그인 실패',
                                  controller.errorMessage.value.isEmpty
                                      ? '이메일 또는 비밀번호를 확인하세요.'
                                      : controller.errorMessage.value,
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007AFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: controller.loading.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            isSignUpMode ? '회원가입' : '로그인',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF007AFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF007AFF) : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
