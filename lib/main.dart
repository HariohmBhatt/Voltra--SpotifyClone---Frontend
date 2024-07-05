// ignore_for_file: unused_import

import 'package:client/features/home/view/pages/home_page.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/theme.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;
  final container = ProviderContainer();
  await container.read(authViewmodelProvider.notifier).initSharedPreferences();
  await container.read(authViewmodelProvider.notifier).getData();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      theme: AppTheme.darkThemeMode,
      home: currentUser == null ? const SignupPage() : const HomePage(),
    );
  }
}
