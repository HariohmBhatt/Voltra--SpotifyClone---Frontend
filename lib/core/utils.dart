import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/// The code snippet provides functions to convert RGB colors to hexadecimal format, convert hexadecimal
/// colors to Color objects, show a SnackBar in a Flutter app, and pick audio or image files using
/// FilePicker.
/// 
/// Args:
///   color (Color): The `color` parameter in the `rgbToHex` function represents an instance of the
/// `Color` class, which typically contains RGB values for a color.
/// 
/// Returns:
///   The code snippet provided contains functions for converting RGB color to hexadecimal, converting
/// hexadecimal color to RGB, showing a SnackBar in a Flutter app, and picking audio and image files
/// using FilePicker. The functions return the following:
String rgbToHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}


Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}

/// The function `showSnackBar` displays a SnackBar with the provided content in a Flutter app.
/// 
/// Args:
///   context (BuildContext): The `context` parameter in the `showSnackBar` function is typically the
/// `BuildContext` object that is needed to show the SnackBar within the current widget tree. It
/// provides information about the location of the widget within the widget tree.
///   content (String): The `content` parameter in the `showSnackBar` function is a string that
/// represents the message or content that will be displayed in the SnackBar widget when it is shown on
/// the screen. This message is typically a brief notification or feedback message for the user.
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

/// The function `pickAudio` uses the FilePicker plugin in Dart to allow the user to pick an audio file
/// and returns a File object representing the selected file.
/// 
/// Returns:
///   A Future<File?> is being returned.
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

/// The `pickImage` function uses the FilePicker plugin in Dart to allow the user to pick an image file
/// and returns a File object representing the selected image file, or null if no file was selected.
/// 
/// Returns:
///   The `pickImage` function returns a `Future<File?>`. Inside the function, it attempts to pick an
/// image file using the `FilePicker` plugin. If a file is successfully picked, it returns a `File`
/// object representing the selected image file. If no file is picked or an error occurs during the
/// process, it returns `null`.
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
