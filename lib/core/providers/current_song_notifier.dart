// ignore_for_file: non_constant_identifier_names

import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';

/// The `CurrentSongNotifier` class in Dart manages the current song playback, including updating the
/// song, toggling play/pause, and seeking to a specific position in the audio player.
part 'current_song_notifier.g.dart';

/// The `@riverpod` annotation in the Dart code snippet is used to mark the `CurrentSongNotifier` class
/// as a provider for Riverpod, a state management library for Flutter. By annotating the class with
/// `@riverpod`, it indicates that instances of this class can be provided and accessed using Riverpod's
/// dependency injection system. This allows for easier management of state and dependencies within the
/// Flutter application.
@riverpod
/// The `CurrentSongNotifier` class in Dart is used to manage the current song being played, utilizing
/// an `AudioPlayer` and a `HomeLocalRepository`.
/// The `CurrentSongNotifier` class in Dart manages the current song playback, including updating the
/// song, toggling play/pause, and seeking to a specific position in the audio player.
class CurrentSongNotifier extends _$CurrentSongNotifier {
  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  @override
  SongModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  /// The function `updateSong` in Dart stops the current song, sets a new audio source, plays the new
  /// song, and handles any errors that may occur.
  /// 
  /// Args:
  ///   song (SongModel): The `updateSong` function takes a `SongModel` object as a parameter. This
  /// `SongModel` object contains information about a song such as its URL, name, artist, and thumbnail
  /// URL. The function uses this information to update the currently playing song in the audio player.
  void updateSong(SongModel song) async {
    try {
      await audioPlayer?.stop(); //stop the current song
      audioPlayer = AudioPlayer();
      final audioSource = AudioSource.uri(
        Uri.parse(song.song_url),
        tag: MediaItem(
          id: song.id,
          title: song.song_name,
          artist: song.artist,
          artUri: Uri.parse(song.thumbnail_url),
        ),
      );
      await audioPlayer!.setAudioSource(audioSource);

      audioPlayer!.playerStateStream.listen(
        (state) {
          if (state.processingState == ProcessingState.completed) {
            audioPlayer!.seek(Duration.zero);
            audioPlayer!.pause();
            isPlaying = false;
          }
          this.state = this.state?.copyWith();
        },
      );
      _homeLocalRepository.uploadLocalSong(song);
      audioPlayer!.play();
      isPlaying = true;
      state = song;
    } catch (e) {
      print('Error playing song: $e');
      // Handle the error appropriately, maybe update state to reflect the error
    }
  }

  /// The function `playPause` toggles the playing state of an audio player and triggers a rebuild of
  /// the state.
  void playPause() {
    print('isPlaying ${isPlaying}');
    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
    isPlaying = !isPlaying;
    state = state
        ?.copyWith(); // This ensures the state is updated to trigger a rebuild
  }

  /// The `seek` function in Dart seeks to a specific position in an audio player based on a given
  /// value.
  /// 
  /// Args:
  ///   val (double): The `val` parameter in the `seek` function represents the position in the audio
  /// track where you want to seek to. It is a double value that ranges from 0.0 (start of the track) to
  /// 1.0 (end of the track).
  void seek(double val) {
    audioPlayer!.seek(
      Duration(
          milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt()),
    );
  }
}
