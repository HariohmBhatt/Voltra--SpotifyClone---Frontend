// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required String hexcode,
    required String token,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        '${ServerConstants.serverURL}song/upload',
      ),
    );
    try {
      request
        ..files.addAll(
          [
            await http.MultipartFile.fromPath(
              'song',
              selectedAudio.path,
            ),
            await http.MultipartFile.fromPath(
              'thumbnail',
              selectedThumbnail.path,
            ),
          ],
        )
        ..fields.addAll(
          {
            'artist': artist,
            'songname': songName,
            'hex_code': hexcode,
          },
        )
        ..headers.addAll(
          {
            'x-auth-token': token,
          },
        );
      final res = await request.send();
      if (res.statusCode != 201) {
        return left(AppFailure(await res.stream.bytesToString()));
      }
      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
          Uri.parse(
            '${ServerConstants.serverURL}song/list',
          ),
          headers: {
            'Content-type': 'application/json',
            'x-auth-token': token,
          });
      var resBodyMap = jsonDecode(res.body);
      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(
          AppFailure(
            resBodyMap['detail'],
          ),
        );
      }
      resBodyMap = resBodyMap as List;

      List<SongModel> songs = [];

      for (final map in resBodyMap) {
        // print(map);
        songs.add(SongModel.fromMap(map));
      }
      // print(' First API Response:  ${songs}');
      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favSong({
    required String token,
    required String songId,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(
          '${ServerConstants.serverURL}song/favourite',
        ),
        headers: {
          'Content-type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(
          {"song_id": songId},
        ),
      );
      var resBodyMap = jsonDecode(res.body);
      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(
          AppFailure(
            resBodyMap['detail'],
          ),
        );
      }
      return Right(resBodyMap['message']);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getFavSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
          Uri.parse(
            '${ServerConstants.serverURL}song/list/favourites',
          ),
          headers: {
            'Content-type': 'application/json',
            'x-auth-token': token,
          });
      var resBodyMap = jsonDecode(res.body);
      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(
          AppFailure(
            resBodyMap['detail'],
          ),
        );
      }
      resBodyMap = resBodyMap as List;

      List<SongModel> songs = [];

      for (final map in resBodyMap) {
        // print(map);
        songs.add(SongModel.fromMap(map['song']));
      }
      // print(' First API Response:  ${songs}');
      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
