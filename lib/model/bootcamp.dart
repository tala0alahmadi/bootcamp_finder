import 'package:flutter/material.dart';

class Bootcamp {
  final String name;
  final String category;
  final int weeks;
  final String level;
  final String desc;
  final String source;
  final String url;
  final double price;

  Bootcamp({
    required this.name,
    required this.category,
    required this.weeks,
    required this.level,
    required this.desc,
    required this.source,
    required this.url,
    required this.price,
  });

  factory Bootcamp.fromJson(Map<String, dynamic> json) {
    return Bootcamp(
      name: (json['name'] as String?)?.trim() ?? 'Untitled Bootcamp',
      category: (json['category'] as String?)?.trim() ?? 'General',
      weeks: (json['weeks'] as num?)?.toInt() ?? 0,
      level: (json['level'] as String?)?.trim() ?? 'All Levels',
      desc: ((json['description'] ?? json['desc']) as String?)?.trim() ?? '',
      source: (json['source'] as String?)?.trim() ?? 'Online',
      url: (json['url'] as String?)?.trim() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
  Map<String, dynamic> toJson() {
  return {
    'name': name,
    'category': category,
    'weeks': weeks,
    'level': level,
    'description': desc,
    'source': source,
    'url': url,
    'price': price,
  };
}

  IconData get icon {
    final cat = category.trim().toUpperCase();
    if (cat == 'DEVELOPMENT' || cat.contains('DEV')) {
      return Icons.phone_android_rounded;
    } else if (cat == 'AI' || cat.contains('AI') || cat.contains('ARTIFICIAL')) {
      return Icons.smart_toy_rounded;
    } else {
      return Icons.design_services_rounded;
    }
  }

  Color get color {
    final cat = category.trim().toUpperCase();
    if (cat == 'DEVELOPMENT' || cat.contains('DEV')) {
      return const Color(0xFF7C4DFF);
    } else if (cat == 'AI' || cat.contains('AI') || cat.contains('ARTIFICIAL')) {
      return const Color(0xFF00BFA5);
    } else {
      return const Color(0xFFFF6E6E);
    }
  }
}
