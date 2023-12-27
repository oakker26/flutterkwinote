// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kwikwinotes/constant/routes.dart';
// import 'package:kwikwinotes/firebase_options.dart';
import 'package:kwikwinotes/services/auth/auth_service.dart';
// import 'package:kwikwinotes/services/auth/firebase_auth_provider.dart';
import 'package:kwikwinotes/views/login_view.dart';
import 'package:kwikwinotes/views/notes_view.dart';
import 'package:kwikwinotes/views/register_view.dart';
import 'package:kwikwinotes/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomeScreen(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
    // initialRoute: "/login/",
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
