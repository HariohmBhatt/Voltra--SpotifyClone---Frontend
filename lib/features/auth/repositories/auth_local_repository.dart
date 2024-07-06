import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The function `authLocalRepository` creates and returns an instance of `AuthLocalRepository` with
/// Riverpod configuration.
/// 
/// Args:
///   ref (AuthLocalRepositoryRef): The `ref` parameter in the `authLocalRepository` function is of type
/// `AuthLocalRepositoryRef`. It is used to access dependencies or providers within the Riverpod
/// framework.
/// 
/// Returns:
///   An instance of the `AuthLocalRepository` class is being returned.
part 'auth_local_repository.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(AuthLocalRepositoryRef ref) {
  return AuthLocalRepository();
}

/// The `AuthLocalRepository` class manages storing and retrieving an authentication token using
/// SharedPreferences in Dart.
class AuthLocalRepository {
  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void setToken(String? token) {
    if (token != null) {
      _sharedPreferences.setString('x-auth-token', token);
    }
  }

  String? getToken() {
    return _sharedPreferences.getString('x-auth-token');
  }
}
