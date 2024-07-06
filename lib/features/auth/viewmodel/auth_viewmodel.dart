import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/models/user_model.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';

/// The `AuthViewmodel` class in Dart is a Riverpod provider class that handles authentication logic
/// including user sign up, login, and data retrieval.
part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel {
  /// The lines `late AuthRemoteRepository _authRemoteRepository;`, `late AuthLocalRepository
  /// _authLocalRepository;`, and `late CurrentUserNotifier _currentUserNotifier;` are declaring three
  /// private instance variables in the `AuthViewmodel` class in Dart. The `late` keyword is used to
  /// indicate that these variables will be initialized at a later point before they are accessed.
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;
  /// The function initializes repositories and notifiers for user authentication in Dart.
  /// 
  /// Returns:
  ///   Null is being returned from the build method.
  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

 /// This function initializes shared preferences by first initializing the local authentication
 /// repository asynchronously.
  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => state = AsyncValue.data(
          r,
        ),
    };
    print(val);
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => state = _loginSuccess(r),
    };
    print(val);
  }

  AsyncValue<UserModel> _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();
    if (token != null) {
      final res = await _authRemoteRepository.getCurrentUserData(token);
      final val = switch (res) {
        Left(value: final l) => state = AsyncValue.error(
            l.message,
            StackTrace.current,
          ),
        Right(value: final r) => _getDataSuccess(r),
      };
      return val.value;
    }
    return null;
  }

  AsyncValue<UserModel> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
