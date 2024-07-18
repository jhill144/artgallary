import 'package:artgallery/utilities/directoryrouter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
  final _passwordFieldKey = GlobalKey<FormBuilderFieldState>();

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
                child: Column(
                  children: [
                    FormBuilderTextField(
                      key: _emailFieldKey,
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
                      name: 'password',
                      decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password.'),
                      obscureText: true,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
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
                      },
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                        onPressed: () {
                          context.goNamed(DirectoryRouter.registrationpage);
                        },
                        child: const Text('Not Yet Registrered?')),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
