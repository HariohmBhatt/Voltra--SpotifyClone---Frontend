import 'package:client/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loading.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';

/// The SigninPage class extends ConsumerStatefulWidget and its state is managed by _SigninPageState.
class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  ConsumerState<SigninPage> createState() => _SigninPageState();
}

/// The `_SigninPageState` class in Dart represents the stateful widget for a sign-in page with form
/// validation and user authentication functionality.
class _SigninPageState extends ConsumerState<SigninPage> {
  /// The code snippet `final emailController = TextEditingController(); final passwordController =
  /// TextEditingController(); final formkey = GlobalKey<FormState>();` is initializing three variables:
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  /// The dispose function is used to clean up resources such as controllers and form state in a Flutter
  /// widget.
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
    formkey.currentState!.validate();
  }

 /// The function uses Riverpod for state management in a Flutter authentication view model, handling
 /// loading states and navigation based on the state changes.
 /// 
 /// Args:
 ///   context (BuildContext): The `context` parameter in Flutter represents the build context of the
 /// widget. It is a reference to the location of a widget within the widget tree. The context provides
 /// access to various properties and methods related to the widget, such as theme, localization, and
 /// navigation.
  @override
  Widget build(BuildContext context) {
    /// The code `final isLoading = ref.watch(authViewmodelProvider.select((val) => val?.isLoading ==
    /// true));` is using Riverpod's `watch` method to listen to changes in the state of the
    /// authentication view model provided by `authViewmodelProvider`.
    final isLoading = ref
        .watch(authViewmodelProvider.select((val) => val?.isLoading == true));
    /// This code snippet is using `ref.listen` to listen for changes in the state provided by
    /// `authViewmodelProvider`. When the state changes, the `next?.when()` method is used to handle
    /// different scenarios based on the state:
    ref.listen(authViewmodelProvider, (_, next) {
      next?.when(
          data: (data) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (_) => false,
            );
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {});
    });

    /// This code snippet is defining the UI layout for the sign-in page in a Flutter application.
    /// Here's a breakdown of what the `return Scaffold(...)` block is doing:
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sign In.',
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomField(
                          hinttext: 'Email',
                          controller: emailController,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomField(
                          hinttext: 'Password',
                          controller: passwordController,
                          makeObscureText: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AuthGradientButton(
                          label: 'Sign In',
                          onTap: () async {
                            if (formkey.currentState!.validate()) {
                              await ref
                                  .read(authViewmodelProvider.notifier)
                                  .loginUser(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please enter all the fields',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Don\'t have an account? ',
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: Pallete.gradient2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
