// ignore_for_file: non_constant_identifier_names

import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  @override
  SongModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

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

  void seek(double val) {
    audioPlayer!.seek(
      Duration(
          milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt()),
    );
  }
}
