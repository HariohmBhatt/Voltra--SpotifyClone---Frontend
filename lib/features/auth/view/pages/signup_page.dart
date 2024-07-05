import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loading.dart';
import 'package:client/features/auth/view/pages/signin_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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

    return Scaffold(
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
