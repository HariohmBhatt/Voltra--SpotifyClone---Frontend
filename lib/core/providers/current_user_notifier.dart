import 'package:client/core/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_notifier.g.dart';

/// The `CurrentUserNotifier` class is a Riverpod provider that keeps the current user information and
/// allows adding a new user.
@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  UserModel? build() {
    return null;
  }

  void addUser(UserModel user) {
    state = user;
  }
}
