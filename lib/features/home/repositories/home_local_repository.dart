import 'package:client/features/home/model/song_model.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(HomeLocalRepositoryRef ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final Box = Hive.box();

  void uploadLocalSong(SongModel song) {
    Box.put(
      song.id,
      song.toJson(),
    );
  }

  List<SongModel> loadSongs() {
    List<SongModel> songs = [];
    for (final key in Box.keys) {
      songs.add(SongModel.fromJson(Box.get(key)));
    }
    return songs;
  }
}
