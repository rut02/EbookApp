import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Base64ImageConverter extends StatelessWidget {
  final String base64Image;

  Base64ImageConverter({required this.base64Image});

  @override
  Widget build(BuildContext context) {
    try {
      // Decode base64 string to Uint8List
      Uint8List bytes = base64Decode(base64Image);

      // Create an Image widget from Uint8List
      Image image = Image.memory(
        bytes,
        fit: BoxFit.cover,
      );

      return image;
    } catch (e) {
      print('Error decoding base64 image: $e');
      return Container(); // หรือ Widget ที่คุณต้องการแสดงเมื่อเกิดข้อผิดพลาด
    }
  }
}