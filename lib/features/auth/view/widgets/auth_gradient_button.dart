import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

/// The `AuthGradientButton` class is a Flutter widget that displays a button with a gradient background
/// and a specified label, triggering a callback function when tapped.
class AuthGradientButton extends StatelessWidget {
  const AuthGradientButton(
      {super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Pallete.gradient1, Pallete.gradient2],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(7)),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(395, 55),
            backgroundColor: Pallete.transparentColor,
            shadowColor: Pallete.transparentColor),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
