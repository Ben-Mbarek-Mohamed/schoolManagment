import 'package:shared_preferences/shared_preferences.dart';

import 'licenseModal.dart';

class LicenseManager {
  static const _licenseKey = 'license_key';

  Future<void> saveLicense(LicenseModel license) async {
    final prefs = await SharedPreferences.getInstance();
    final licenseJson = license.toJson();
    await prefs.setString(_licenseKey, licenseJson);
  }

  // Retrieve license from SharedPreferences
  Future<LicenseModel?> getLicense() async {
    final prefs = await SharedPreferences.getInstance();
    final licenseJson = prefs.getString(_licenseKey);
    return licenseJson != null ? LicenseModel.fromJson(licenseJson) : null;
  }

  // Clear the license
  Future<void> clearLicense() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_licenseKey);
  }
}
