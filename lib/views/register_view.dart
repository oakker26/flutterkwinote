// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:kwikwinotes/constant/routes.dart';
import 'package:kwikwinotes/services/auth/auth_exception.dart';
import 'package:kwikwinotes/services/auth/auth_service.dart';
import 'package:kwikwinotes/utils/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register View",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter Email"),
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: "Enter Password"),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on WeekPasswordAuthException {
                  await showErrorDialog(context, 'Weak Password');
                } on EmailAlreadyUseAuthException {
                  await showErrorDialog(context, 'Email is already use');
                } on InvalidEmailAuthException {
                  await showErrorDialog(context, 'this email is invalid');
                } on GenericAuthException {
                  await showErrorDialog(context, 'Failed Register');
                }
              },
              child: const Text("Register")),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Already Register ? Login here!"))
        ],
      ),
    );
  }
}
