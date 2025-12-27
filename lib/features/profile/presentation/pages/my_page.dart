import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_life_legacy/features/profile/presentation/controllers/my_page_controller.dart';
import 'package:ai_life_legacy/features/auth/presentation/controllers/auth_controller.dart'; // To get email

class MyPage extends GetView<MyPageController> {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthController is persistent, so we can find it to get user info locally if stored
    final authController = Get.find<AuthController>();
    // Assume userEmail is stored or accessible. If not, we use placeholder.
    // Since AuthController might not expose email directly, we might need to fetch profile or just show generic.
    // Let's assume for now we just show "User" or email if we had it.

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F3), // Light grey background
      appBar: AppBar(
        title: const Text(
          '설정',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                  const SizedBox(width: 20),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '사용자',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'AI Life Legacy 회원',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Settings List
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.notifications_outlined,
                    title: '알림 설정',
                    onTap: () {
                      // TODO: Implement notification settings
                      Get.snackbar('알림', '준비 중인 기능입니다.');
                    },
                  ),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  _buildSettingItem(
                    icon: Icons.info_outline,
                    title: '앱 정보',
                    trailing: const Text('v1.0.0',
                        style: TextStyle(color: Colors.grey)),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Account Actions
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.logout,
                    title: '로그아웃',
                    isDestructive: false,
                    onTap: () => _showLogoutDialog(context),
                  ),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  _buildSettingItem(
                    icon: Icons.delete_outline,
                    title: '회원 탈퇴',
                    isDestructive: true,
                    onTap: () => _showWithdrawDialog(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
    Widget? trailing,
  }) {
    return ListTile(
      leading:
          Icon(icon, color: isDestructive ? Colors.redAccent : Colors.black54),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.redAccent : Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.defaultDialog(
      title: '로그아웃',
      middleText: '정말 로그아웃 하시겠습니까?',
      textConfirm: '확인',
      textCancel: '취소',
      confirmTextColor: Colors.white,
      buttonColor: Colors.black87,
      cancelTextColor: Colors.black87,
      onConfirm: () {
        Get.back(); // close dialog
        controller.logout();
      },
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    Get.defaultDialog(
      title: '회원 탈퇴',
      titleStyle:
          const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
      middleText: '탈퇴 시 작성한 자서전과 모든 데이터가\n영구적으로 삭제됩니다.\n\n정말 탈퇴하시겠습니까?',
      textConfirm: '탈퇴하기',
      textCancel: '취소',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      cancelTextColor: Colors.black87,
      onConfirm: () {
        Get.back(); // close dialog
        controller.withdrawAccount();
      },
    );
  }
}
