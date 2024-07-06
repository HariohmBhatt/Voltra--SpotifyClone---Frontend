import 'dart:convert';
import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/core/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// The above function defines a Riverpod provider for an AuthRemoteRepository instance.
/// 
/// Args:
///   ref (AuthRemoteRepositoryRef): The `ref` parameter in the code snippet is of type
/// `AuthRemoteRepositoryRef`. It is used to provide access to the dependencies needed to construct an
/// instance of `AuthRemoteRepository`. This is commonly used in Riverpod to access other providers or
/// dependencies within the same scope.
/// 
/// Returns:
///   An instance of the `AuthRemoteRepository` class is being returned.
part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

/// The `AuthRemoteRepository` class contains methods for user authentication operations like signup,
/// login, and fetching current user data from a remote server.
class AuthRemoteRepository {
 /// This Dart function sends a signup request to a server and returns either a UserModel or an
 /// AppFailure based on the response.
 /// 
 /// Args:
 ///   name (String): The `name` parameter in the `signup` function represents the name of the user who
 /// is signing up for an account. It is a required field and should be a string value containing the
 /// user's name.
 ///   email (String): The `email` parameter in the `signup` function is a required field that
 /// represents the email address of the user who is signing up for an account. This email address will
 /// be used as a unique identifier for the user's account and for communication purposes. It is
 /// essential for the user to provide a
 ///   password (String): The `password` parameter in the `signup` function represents the password that
 /// the user provides during the signup process. This password is typically used for authentication and
 /// security purposes to verify the identity of the user when they log in to their account. It is
 /// important to securely handle and store passwords to protect user
 /// 
 /// Returns:
 ///   The `signup` function returns a `Future` that resolves to an `Either` type. The `Either` type can
 /// contain either an `AppFailure` object in case of an error or a `UserModel` object if the signup is
 /// successful.
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.serverURL}auth/signup"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 201) {
        return Left(AppFailure(resBodyMap['detail'] ?? 'Unkown Error Occured'));
      }
      return Right(
        UserModel.fromMap(resBodyMap),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

 /// This Dart function performs a login request to a server and returns either a UserModel with a token
 /// or an AppFailure object based on the response.
 /// 
 /// Args:
 ///   email (String): The `email` parameter is a required `String` that represents the user's email
 /// address.
 ///   password (String): The `password` parameter in the `login` function is a required parameter of
 /// type `String`. It is used to store the user's password input for authentication during the login
 /// process.
 /// 
 /// Returns:
 ///   The `login` function returns a `Future` that resolves to an `Either` type. The `Either` type can
 /// contain either an `AppFailure` object (if an error occurs during the login process) or a
 /// `UserModel` object (if the login is successful).
  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.serverURL}auth/login"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(
            AppFailure(resBodyMap['detail'] ?? 'Unknown Error Occurred'));
      }
      final user = UserModel.fromMap(resBodyMap['user']);
      return Right(user.copyWith(token: resBodyMap['token']));
    } catch (e) {
      return Left(
        AppFailure(
          e.toString(),
        ),
      );
    }
  }

  /// This function retrieves the current user data from a server using a provided token and returns
  /// either the user model or an application failure.
  /// 
  /// Args:
  ///   token (String): The `token` parameter in the `getCurrentUserData` function is a string that
  /// represents the authentication token used to authenticate the user and retrieve their current user
  /// data from the server. This token is typically obtained during the user authentication process and
  /// is passed to the server to identify and authorize the user making the request
  /// 
  /// Returns:
  ///   The `getCurrentUserData` function returns a `Future` that resolves to an `Either` type. The
  /// `Either` type can contain either an `AppFailure` object (if there was an error during the API call
  /// or processing) or a `UserModel` object (if the API call was successful and the user data was
  /// retrieved).
  Future<Either<AppFailure, UserModel>> getCurrentUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstants.serverURL}auth/"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail'] ?? 'Unkown Error Occured'));
      }
      return Right(UserModel.fromMap(resBodyMap).copyWith(
        token: token,
      ));
    } catch (e) {
      return Left(
        AppFailure(
          e.toString(),
        ),
      );
    }
  }
}
