import 'package:get/get.dart';
import 'package:gpr_coffee_shop/models/app_settings.dart';
import 'package:gpr_coffee_shop/services/local_storage_service.dart';

class SettingsController extends GetxController {
  final LocalStorageService _storage;
  final settings = AppSettings().obs;
  final isLoading = true.obs;

  SettingsController(this._storage) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      isLoading.value = true;
      final storedSettings = await _storage.getSettings();
      if (storedSettings != null) {
        settings.value = storedSettings;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void updateLanguage(String lang) {
    settings.update((val) {
      if (val != null) val.language = lang;
    });
    _saveSettings();
  }

  void updateFontSize(double size) {
    settings.update((val) {
      if (val != null) val.fontSize = size;
    });
    _saveSettings();
  }

  void updateTheme(String theme) {
    settings.update((val) {
      if (val != null) val.theme = theme;
    });
    _saveSettings();
  }

  void updateSocialAccount(SocialMediaAccount account) {
    settings.update((val) {
      if (val != null) val.socialAccounts[account.platform] = account;
    });
    _saveSettings();
  }

  void removeSocialAccount(String platform) {
    settings.update((val) {
      if (val != null) val.socialAccounts.remove(platform);
    });
    _saveSettings();
  }

  void updateBenefitEmail(String email) {
    settings.update((val) {
      if (val != null) val.benefitEmail = email;
    });
    _saveSettings();
  }

  void updateStoredQrCode(String qrCode) {
    settings.update((val) {
      if (val != null) val.storedQrCode = qrCode;
    });
    _saveSettings();
  }

  Future<void> _saveSettings() async {
    await _storage.saveSettings(settings.value);
  }

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }
}
