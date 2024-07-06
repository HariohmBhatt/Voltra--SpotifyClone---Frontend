import 'package:flutter/material.dart';

/// The `Loader` class is a stateless widget that displays a centered CircularProgressIndicator in a
/// Flutter application.
class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive(),);
  }
}