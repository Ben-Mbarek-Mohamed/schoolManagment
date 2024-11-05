import 'dart:convert';


class LicenseModel {
  final String? key;
  final DateTime freeTrialEndDate;

  LicenseModel({
    this.key,
    required this.freeTrialEndDate,
  });

  bool get isValid => key != null;
  bool get isFreeTrial => DateTime.now().isBefore(freeTrialEndDate) && !isValid;

  int get daysLeft {
    final days = freeTrialEndDate.difference(DateTime.now()).inDays;
    return days < 0 ? 0 : days;
  }

  String get daysLeftString {
    final days = daysLeft;
    if (days == 0) return 'freeTrialEnded';
    if (days == 1) return 'oneDayLeftinFreeTrial';
    return 'daysLeftinFreeTrial(days)';
  }

  factory LicenseModel.withFreeTrial() {
    return LicenseModel(
      freeTrialEndDate: DateTime.now().add(const Duration(days: 7)), // Set to 7 days
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'freeTrialEndDate': freeTrialEndDate.millisecondsSinceEpoch,
    };
  }

  static LicenseModel? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    try {
      return LicenseModel(
        key: map['key'],
        freeTrialEndDate: DateTime.fromMillisecondsSinceEpoch(map['freeTrialEndDate']),
      );
    } catch (e) {
      // Optionally log or handle the error
      return null;
    }
  }

  String toJson() => json.encode(toMap());

  static LicenseModel? fromJson(String source) =>
      LicenseModel.fromMap(json.decode(source));

  LicenseModel copyWith({
    String? key,
    DateTime? freeTrialEndDate,
  }) {
    return LicenseModel(
      key: key ?? this.key,
      freeTrialEndDate: freeTrialEndDate ?? this.freeTrialEndDate,
    );
  }
}
