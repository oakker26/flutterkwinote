import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import "dart:developer" as devtools show log;

import 'package:kwikwinotes/constant/routes.dart';
import 'package:kwikwinotes/services/auth/auth_exception.dart';
import 'package:kwikwinotes/services/auth/auth_service.dart';
import 'package:kwikwinotes/utils/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text("Kwi Login"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
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
                  await AuthService.firebase().logIn(
                    email: email,
                    password: password,
                  );
                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          notesRoute, (route) => false);
                    }
                  } else {
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          verifyEmailRoute, (route) => false);
                    }
                  }
                } on InvalidCredentialAuthException {
                  if (context.mounted) {
                    await showErrorDialog(context,
                        "your email or password something wrong!!! \n check your email or password ...");
                  }
                } on GenericAuthException {
                  if (context.mounted) {
                    await showErrorDialog(context, 'Authentication error');
                  }
                }
              },
              child: const Text("Kwi Login")),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Not registered yet? Register here!'))
        ],
      ),
    );
  }
}
