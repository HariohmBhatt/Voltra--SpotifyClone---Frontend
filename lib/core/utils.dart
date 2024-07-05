import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

String rgbToHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}

// Provide a default color in case of invalid input
//   Color hexToColor(String hexString) {
//   final buffer = StringBuffer();
//   if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
//   buffer.write(hexString.replaceFirst('#', ''));
//   return Color(int.parse(buffer.toString(), radix: 16));
// }

Color hexToColor(String hex) {
  // // Provide a default color in case of invalid input
  // if (hexString.isEmpty) {
  //   return Colors.black; // or any other default color
  // }

  // final buffer = StringBuffer();
  // if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  // buffer.write(hexString.replaceFirst('#', ''));

  // try {
  //   return Color(int.parse(buffer.toString(), radix: 16));
  // } catch (e) {
  //   print('Invalid hex code: $hexString');
  //   return Colors.black; // or any other default color
  // }
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          content,
        ),
      ),
    );
}

Future<File?> pickAudio() async {
  try {
    final filePickerrRes = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (filePickerrRes != null) {
      return File(filePickerrRes.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final filePickerrRes = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (filePickerrRes != null) {
      return File(filePickerrRes.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}
