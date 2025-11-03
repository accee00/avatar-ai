import 'dart:io';

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
