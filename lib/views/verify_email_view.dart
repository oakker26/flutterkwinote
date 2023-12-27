// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kwikwinotes/constant/routes.dart';
import 'package:kwikwinotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Column(
        children: [
          const Text('Please check Your Email'),
          const Text('if you have not receive email press again button!!!!'),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
              // final user = FirebaseAuth.instance.currentUser;
              // await user?.sendEmailVerification();
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                if (context.mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                }
              },
              child: const Text("restart"))
        ],
      ),
    );
  }
}
