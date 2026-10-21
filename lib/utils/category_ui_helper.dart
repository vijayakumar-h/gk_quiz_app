import 'package:flutter/material.dart';

class CategoryUIHelper {
  static IconData getIcon(String? iconName) {
    switch (iconName) {
      case 'science':
        return Icons.science_rounded;
      case 'public':
        return Icons.public_rounded;
      case 'memory':
        return Icons.memory_rounded;
      case 'sports_soccer':
        return Icons.sports_soccer_rounded;
      case 'lightbulb':
        return Icons.lightbulb_rounded;
      case 'auto_awesome':
        return Icons.auto_awesome_rounded;
      default:
        return Icons.quiz_rounded;
    }
  }

  static Color getPrimaryColor(Map<String, dynamic> category) {
    final val = category['primaryColor'];
    if (val is int) return Color(val);
    return const Color(0xFF5E35B1);
  }

  static Color getAccentColor(Map<String, dynamic> category) {
    final val = category['accentColor'];
    if (val is int) return Color(val);
    return const Color(0xFF9575CD);
  }
}
