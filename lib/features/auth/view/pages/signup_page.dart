import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loading.dart';
import 'package:client/features/auth/view/pages/signin_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The `SignupPage` class extends `ConsumerStatefulWidget` and defines a stateful widget for a signup
/// page.
class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

/// The `_SignupPageState` class in Dart represents the stateful widget for a sign-up page with form
/// validation and user authentication functionality.
class _SignupPageState extends ConsumerState<SignupPage> {
  /// The code snippet you provided is initializing four variables:
  /// 1. `nameController`: This is an instance of `TextEditingController` class, which is typically used
  /// to control the text being entered into a text field. In this case, it is likely used to control
  /// the text input for the user's name during the signup process.
  ///    
  /// 2. `emailController`: Similar to `nameController`, this variable is also an instance of
  /// `TextEditingController` and is used to control the text input for the user's email address during
  /// signup.
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  /// The `dispose` function is used to release resources such as controllers in Dart.
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// The function builds a widget that listens to changes in the authentication view model, showing a
  /// snackbar message when an account is successfully created and navigating to the sign-in page.
  /// 
  /// Args:
  ///   context (BuildContext): The `context` parameter in Flutter represents the build context of the
  /// widget. It is a reference to the location of a widget within the widget tree. The context provides
  /// access to various properties and methods related to the widget, such as accessing theme data,
  /// navigating to other screens, showing dialogs, and more
  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(authViewmodelProvider.select((val) => val?.isLoading == true));
    ref.listen(authViewmodelProvider, (_, next) {
      next?.when(
          data: (data) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text(
                    'Account created succesfully!, please Sign In',
                  ),
                ),
              );
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SigninPage(),
                ));
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {});
    });

    /// The `Scaffold` widget in the provided code snippet is defining the structure of the
    /// signup page UI. 
    return
    Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? Loader()
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sign Up.',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        CustomField(
                          hinttext: 'Name',
                          controller: nameController,
                        ),
                        const SizedBox(height: 15),
                        CustomField(
                          hinttext: 'Email',
                          controller: emailController,
                        ),
                        const SizedBox(height: 15),
                        CustomField(
                          hinttext: 'Password',
                          controller: passwordController,
                          makeObscureText: true,
                        ),
                        const SizedBox(height: 20),
                        AuthGradientButton(
                          label: 'Sign Up',
                          onTap: () async {
                            if (formkey.currentState!.validate()) {
                              await ref
                                  .read(authViewmodelProvider.notifier)
                                  .signUpUser(
                                    name: nameController.text,
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
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SigninPage(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                  text: 'Sign In',
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
