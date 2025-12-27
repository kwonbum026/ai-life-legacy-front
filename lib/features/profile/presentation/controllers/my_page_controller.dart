import 'package:get/get.dart';
import 'package:ai_life_legacy/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ai_life_legacy/features/user/data/user_repository.dart';
import 'package:ai_life_legacy/features/user/data/models/user.dto.dart';
import 'package:ai_life_legacy/app/core/utils/toast_utils.dart';

class MyPageController extends GetxController {
  final UserRepository _userRepo;
  final AuthController _authController = Get.find<AuthController>();

  MyPageController(this._userRepo);

  final RxBool isLoading = false.obs;

  /// 로그아웃
  Future<void> logout() async {
    await _authController.logout();
    // AuthController.logout handles navigation to Login
  }

  /// 회원 탈퇴
  Future<void> withdrawAccount() async {
    isLoading.value = true;
    try {
      // 1. API 호출 (회원 탈퇴)
      // DTO may be empty if no specific reason is required, but we pass empty string for now
      final dto = UserWithdrawalDto(
        withdrawalReason: "USER_REQUEST",
        withdrawalText: "사용자 요청에 의한 탈퇴",
      );
      await _userRepo.deleteUser(dto);

      // 2. 로그아웃 처리 (토큰 삭제 등)
      await _authController.logout();

      // 3. 메시지 표시
      ToastUtils.showInfoToast('회원 탈퇴가 완료되었습니다.');
    } catch (e) {
      Get.snackbar('오류', '회원 탈퇴 중 오류가 발생했습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
