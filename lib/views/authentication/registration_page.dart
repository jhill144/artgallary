import 'package:artgallery/utilities/directoryrouter.dart';
import 'package:artgallery/utilities/firebase/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
  final _passwordFieldKey = GlobalKey<FormBuilderFieldState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() async {
    String emailAddress = _emailController.text;
    String passWord = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(emailAddress, passWord);

    if (user != null) {
      print("User was created");
      context.goNamed(DirectoryRouter.homepage);
    } else {
      print("User was not created");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Colors.blue, Colors.green],
            ),
          ),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.art_track,
                size: 50,
              ),
              const Text(
                'Art Gallery',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 10),
              FormBuilder(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          key: _emailFieldKey,
                          controller: _emailController,
                          name: 'emailField',
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email address.'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email(),
                          ]),
                        ),
                        const SizedBox(height: 10),
                        FormBuilderTextField(
                          key: _passwordFieldKey,
                          controller: _passwordController,
                          name: 'password',
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password.'),
                          obscureText: true,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.password(),
                          ]),
                        ),
                        const SizedBox(height: 10),
                        MaterialButton(
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: () {
                            // Validate and save the form values
                            _formKey.currentState?.saveAndValidate();
                            debugPrint(_formKey.currentState?.value.toString());

                            // On another side, can access all field values without saving form with instantValues
                            _formKey.currentState?.validate();
                            debugPrint(
                                _formKey.currentState?.instantValue.toString());
                            _register();
                          },
                          child: const Text('Register Account'),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                            onPressed: () {
                              context.goNamed(DirectoryRouter.loginpage);
                            },
                            child: const Text('Already Registered? Login')),
                      ],
                    ),
                  )),
            ],
          )),
        ),
      ),
    );
  }
}
