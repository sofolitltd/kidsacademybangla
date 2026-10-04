import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChildProfile {
  final String id;
  String childName;
  String nickName;
  String dob;
  String address;
  String fatherName;
  String fatherMobile;
  String motherName;
  String motherMobile;
  String dadaName;
  String dadiName;
  String nanaName;
  String naniName;
  String brothers;
  String sisters;

  ChildProfile({
    required this.id,
    required this.childName,
    this.nickName = '',
    this.dob = '',
    this.address = '',
    required this.fatherName,
    this.fatherMobile = '',
    required this.motherName,
    this.motherMobile = '',
    this.dadaName = '',
    this.dadiName = '',
    this.nanaName = '',
    this.naniName = '',
    this.brothers = '',
    this.sisters = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'childName': childName,
    'nickName': nickName,
    'dob': dob,
    'address': address,
    'fatherName': fatherName,
    'fatherMobile': fatherMobile,
    'motherName': motherName,
    'motherMobile': motherMobile,
    'dadaName': dadaName,
    'dadiName': dadiName,
    'nanaName': nanaName,
    'naniName': naniName,
    'brothers': brothers,
    'sisters': sisters,
  };

  factory ChildProfile.fromJson(Map<String, dynamic> json) => ChildProfile(
    id: json['id'] ?? '',
    childName: json['childName'] ?? '',
    nickName: json['nickName'] ?? '',
    dob: json['dob'] ?? '',
    address: json['address'] ?? '',
    fatherName: json['fatherName'] ?? '',
    fatherMobile: json['fatherMobile'] ?? '',
    motherName: json['motherName'] ?? '',
    motherMobile: json['motherMobile'] ?? '',
    dadaName: json['dadaName'] ?? '',
    dadiName: json['dadiName'] ?? '',
    nanaName: json['nanaName'] ?? '',
    naniName: json['naniName'] ?? '',
    brothers: json['brothers'] ?? '',
    sisters: json['sisters'] ?? '',
  );

  /// Name shown in greetings: nickname if set, else the full name.
  String get displayName =>
      nickName.trim().isNotEmpty ? nickName.trim() : childName;

  int get age {
    if (dob.isEmpty) return 0;
    try {
      final parts = dob.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final birth = DateTime(year, month, day);
        final now = DateTime.now();
        int age = now.year - birth.year;
        if (now.month < birth.month ||
            (now.month == birth.month && now.day < birth.day)) {
          age--;
        }
        return age;
      }
    } catch (_) {}
    return 0;
  }

  String get ageText {
    final a = age;
    if (a <= 0) return '';
    return '$a বছর';
  }
}

class ProfileService {
  static const String _profilesKey = 'child_profiles';

  static Future<List<ChildProfile>> getAllProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_profilesKey);
    if (jsonString == null || jsonString.isEmpty) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => ChildProfile.fromJson(e)).toList();
  }

  static Future<ChildProfile?> getProfile(String id) async {
    final profiles = await getAllProfiles();
    try {
      return profiles.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveProfile(ChildProfile profile) async {
    final profiles = await getAllProfiles();
    final index = profiles.indexWhere((p) => p.id == profile.id);
    if (index >= 0) {
      profiles[index] = profile;
    } else {
      profiles.add(profile);
    }
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(profiles.map((p) => p.toJson()).toList());
    await prefs.setString(_profilesKey, jsonString);
  }

  static Future<void> deleteProfile(String id) async {
    final profiles = await getAllProfiles();
    profiles.removeWhere((p) => p.id == id);
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(profiles.map((p) => p.toJson()).toList());
    await prefs.setString(_profilesKey, jsonString);
  }
}
