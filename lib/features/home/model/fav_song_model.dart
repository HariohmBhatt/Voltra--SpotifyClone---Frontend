// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

// FavSongModel class represents a favorite song model with three properties: id, song_id, and user_id.
class FavSongModel {
  // The unique identifier of the favorite song.
  final String id;
  // The identifier of the song.
  final String song_id;
  // The identifier of the user who favorited the song.
  final String user_id;

  // Constructor to create a new instance of FavSongModel with the provided id, song_id, and user_id.
  FavSongModel({
    required this.id,
    required this.song_id,
    required this.user_id,
  });

  // Creates a copy of the current FavSongModel instance with the provided properties.
  // If a property is not provided, it will use the current instance's value.
  FavSongModel copyWith({
    String? id,
    String? song_id,
    String? user_id,
  }) {
    return FavSongModel(
      id: id ?? this.id,
      song_id: song_id ?? this.song_id,
      user_id: user_id ?? this.user_id,
    );
  }

  // Converts the FavSongModel instance to a Map<String, dynamic>.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_id': song_id,
      'user_id': user_id,
    };
  }

  // Creates a new instance of FavSongModel from a Map<String, dynamic>.
  factory FavSongModel.fromMap(Map<String, dynamic> map) {
    return FavSongModel(
      id: map['id'] as String,
      song_id: map['song_id'] as String,
      user_id: map['user_id'] as String,
    );
  }

  // Converts the FavSongModel instance to a JSON string.
  String toJson() => json.encode(toMap());

  // Creates a new instance of FavSongModel from a JSON string.
  factory FavSongModel.fromJson(String source) =>
      FavSongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // Returns a string representation of the FavSongModel instance.
  @override
  String toString() =>
      'FavSongModel(id: $id, song_id: $song_id, user_id: $user_id)';

  // Compares two FavSongModel instances for equality.
  @override
  bool operator ==(covariant FavSongModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.song_id == song_id &&
        other.user_id == user_id;
  }

  // Returns the hash code of the FavSongModel instance.
  @override
  int get hashCode => id.hashCode ^ song_id.hashCode ^ user_id.hashCode;
}
