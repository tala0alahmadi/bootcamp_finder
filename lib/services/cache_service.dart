import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/bootcamp.dart';

class CacheService {
static const _key = 'cached_bootcamps';

  // نحفظ قائمة المعسكرات على الجوال
  static Future<void> save(List<Bootcamp> bootcamps) async {
    final prefs = await SharedPreferences.getInstance();
    final text = jsonEncode(bootcamps.map((b) => b.toJson()).toList());
    await prefs.setString(_key, text);
  }

  // نقرأ آخر قائمة محفوظة (فاضية لو ما حفظنا شي قبل)
  static Future<List<Bootcamp>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(_key);
    if (text == null) return [];

    final list = jsonDecode(text) as List;
    return list
        .map((e) => Bootcamp.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
