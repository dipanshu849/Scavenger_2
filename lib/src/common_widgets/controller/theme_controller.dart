import 'package:get/get.dart';
import 'package:scavenger_2/src/utils/theme/theme.dart';

class ThemeController extends GetxController {
  // Initial value based on system brightness
  var isDark = (Get.isDarkMode).obs;

  void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeTheme(isDark.value ? AppTheme.darkTheme : AppTheme.lightTheme);
  }
}
