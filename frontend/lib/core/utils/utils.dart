import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum SnackBarType { success, failure, info }

void showSnackBar({
  required String message,
  required BuildContext context,
  SnackBarType type = SnackBarType.info,
}) {
  final config = _getSnackBarConfig(type);

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(config.icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: config.backgroundColor,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
}

_SnackBarConfig _getSnackBarConfig(SnackBarType type) {
  switch (type) {
    case SnackBarType.success:
      return _SnackBarConfig(
        backgroundColor: const Color(0xFF4CAF50),
        icon: Icons.check_circle_outline,
      );
    case SnackBarType.failure:
      return _SnackBarConfig(
        backgroundColor: const Color(0xFFF44336),
        icon: Icons.error_outline,
      );
    case SnackBarType.info:
      return _SnackBarConfig(
        backgroundColor: const Color(0xFF2196F3),
        icon: Icons.info_outline,
      );
  }
}

class _SnackBarConfig {
  final Color backgroundColor;
  final IconData icon;

  _SnackBarConfig({required this.backgroundColor, required this.icon});
}

class AppImagePicker {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (pickedFile == null) return null;

      return File(pickedFile.path);
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }
}

class ColorGenerator {
  static final Random _random = Random();

  static Color generateRandomColor() {
    final colorOptions = [
      const Color(0xFF6C63FF), // Purple
      const Color(0xFFFF6B9D), // Pink
      const Color(0xFF4ECDC4), // Teal
      const Color(0xFFF4A261), // Orange
      const Color(0xFFE76F51), // Red-Orange
      const Color(0xFF2A9D8F), // Sea Green
      const Color(0xFFE63946), // Red
      const Color(0xFF06FFA5), // Mint
      const Color(0xFFFFBE0B), // Yellow
      const Color(0xFFFB5607), // Bright Orange
      const Color(0xFF8338EC), // Violet
      const Color(0xFF3A86FF), // Blue
      const Color(0xFFFF006E), // Hot Pink
      const Color(0xFF00F5FF), // Cyan
      const Color(0xFFD62828), // Dark Red
      const Color(0xFFF77F00), // Dark Orange
      const Color(0xFFD2691E), // Chocolate
      const Color(0xFF8B4513), // Saddle Brown
      const Color(0xFF20B2AA), // Light Sea Green
      const Color(0xFF9B59B6), // Amethyst
    ];

    return colorOptions[_random.nextInt(colorOptions.length)];
  }
}
