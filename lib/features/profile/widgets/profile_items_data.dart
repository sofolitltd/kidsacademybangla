import 'dart:ui';
import '../../../core/services/profile_service.dart';

class ProfileItemsData {
  static List<Map<String, String>> getProfileItems(ChildProfile? profile) {
    if (profile == null) return [];
    final items = <Map<String, String>>[];

    items.add({
      'label': 'আমার পুরোনাম',
      'value': profile.childName,
      'icon': '👶',
      'color': '#FF7F50',
    });
    if (profile.nickName.isNotEmpty) {
      items.add({
        'label': 'আমার ডাকনাম',
        'value': profile.nickName,
        'icon': '😊',
        'color': '#FF7F50',
      });
    }
    if (profile.ageText.isNotEmpty) {
      items.add({
        'label': 'আমার বয়স',
        'value': profile.ageText,
        'icon': '🎂',
        'color': '#FF7F50',
      });
    }

    if (profile.fatherName.isNotEmpty) {
      items.add({
        'label': 'আমার বাবার নাম',
        'value': profile.fatherName,
        'icon': '👨',
        'color': '#4ECDC4',
      });
    }
    if (profile.motherName.isNotEmpty) {
      items.add({
        'label': 'আমার মায়ের নাম',
        'value': profile.motherName,
        'icon': '👩',
        'color': '#FF69B4',
      });
    }
    if (profile.brothers.isNotEmpty) {
      for (final entry
          in profile.brothers
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)) {
        final parts = entry.split(':');
        final name = parts[0].trim();
        final position = parts.length > 1 ? parts[1].trim() : '';
        final label = position.isNotEmpty
            ? 'আমার $position ভাই'
            : 'আমার ভাইয়ের নাম';
        items.add({
          'label': label,
          'value': name,
          'icon': '🧒',
          'color': '#2ECC71',
        });
      }
    }
    if (profile.sisters.isNotEmpty) {
      for (final entry
          in profile.sisters
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)) {
        final parts = entry.split(':');
        final name = parts[0].trim();
        final position = parts.length > 1 ? parts[1].trim() : '';
        final label = position.isNotEmpty
            ? 'আমার $position বোন'
            : 'আমার বোনের নাম';
        items.add({
          'label': label,
          'value': name,
          'icon': '👧',
          'color': '#2ECC71',
        });
      }
    }
    if (profile.dadaName.isNotEmpty) {
      items.add({
        'label': 'আমার দাদার নাম',
        'value': profile.dadaName,
        'icon': '👴',
        'color': '#9B59B6',
      });
    }
    if (profile.dadiName.isNotEmpty) {
      items.add({
        'label': 'আমার দাদীর নাম',
        'value': profile.dadiName,
        'icon': '👵',
        'color': '#9B59B6',
      });
    }
    if (profile.nanaName.isNotEmpty) {
      items.add({
        'label': 'আমার নানার নাম',
        'value': profile.nanaName,
        'icon': '👴',
        'color': '#3498DB',
      });
    }
    if (profile.naniName.isNotEmpty) {
      items.add({
        'label': 'আমার নানীর নাম',
        'value': profile.naniName,
        'icon': '👵',
        'color': '#3498DB',
      });
    }
    if (profile.fatherMobile.isNotEmpty) {
      items.add({
        'label': 'বাবার মোবাইল',
        'value': profile.fatherMobile,
        'icon': '📱',
        'color': '#4ECDC4',
      });
    }
    if (profile.motherMobile.isNotEmpty) {
      items.add({
        'label': 'মায়ের মোবাইল',
        'value': profile.motherMobile,
        'icon': '📱',
        'color': '#FF69B4',
      });
    }
    if (profile.address.isNotEmpty) {
      items.add({
        'label': 'আমার ঠিকানা',
        'value': profile.address,
        'icon': '🏠',
        'color': '#E67E22',
      });
    }
    if (profile.dob.isNotEmpty) {
      items.add({
        'label': 'আমার জন্মদিন',
        'value': profile.dob,
        'icon': '📅',
        'color': '#E74C3C',
      });
    }

    return items;
  }

  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
