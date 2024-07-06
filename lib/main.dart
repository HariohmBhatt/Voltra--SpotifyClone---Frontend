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

/// The main function initializes audio playback settings, sets up Hive database directory, initializes
/// shared preferences, fetches data, and runs the Flutter application.
/// The main function initializes audio playback settings, sets up Hive database directory, initializes
/// shared preferences, fetches data, and runs the Flutter application.
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
  /// The `runApp` function in Flutter is used to start the application with the given widget as the
  /// root of the widget tree. In this case, `UncontrolledProviderScope` is a widget provided by the
  /// Riverpod package that allows you to create a scope for providers without controlling its
  /// lifecycle.
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

/// The `MyApp` class in Dart is a Flutter widget that uses Riverpod for state management to display
/// either a SignupPage or HomePage based on the current user's status.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  /// The above function builds a widget in Dart that watches for changes in the current user using a
  /// provider.
  /// 
  /// Args:
  ///   context (BuildContext): The `BuildContext` parameter in the `build` method represents the
  /// location of the widget in the widget tree. It provides access to various properties and methods
  /// related to the current build context, such as theme, media queries, and localization. It is
  /// commonly used to retrieve information or services from higher up in
  ///   ref (WidgetRef): The `ref` parameter in the `build` method is a `WidgetRef` object, which is
  /// used to interact with providers and read/watch their values within the context of a widget. It
  /// allows you to access and interact with the state management system, such as reading the current
  /// state of a provider
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// `final currentUser = ref.watch(currentUserNotifierProvider);` is using the `watch` method
    /// provided by Riverpod to subscribe to changes in the `currentUserNotifierProvider` provider. This
    /// means that whenever the value of `currentUserNotifierProvider` changes, the `currentUser`
    /// variable will be updated with the new value. This allows the widget to react to changes in the
    /// state managed by the `currentUserNotifierProvider` and rebuild itself when necessary to reflect
    /// those changes.
    final currentUser = ref.watch(currentUserNotifierProvider);

    /// The `return MaterialApp(...)` code snippet is defining the root widget of the Flutter
    /// application. Here's what each parameter is doing:
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      theme: AppTheme.darkThemeMode,
      home:
      /// The line `currentUser == null ? const SignupPage() : const HomePage()` in the `build`
      /// method of the `MyApp` widget is a conditional statement that determines which page to
      /// display based on the value of the `currentUser` variable.
      currentUser == null ? const SignupPage() : const HomePage(),
    );
  }
}
