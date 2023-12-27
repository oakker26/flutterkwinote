// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kwikwinotes/constant/routes.dart';
import 'package:kwikwinotes/enums/menu_actions.dart';
import 'dart:developer' as devtools show log;

import 'package:kwikwinotes/services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kwi Notes"),
        backgroundColor: Colors.red,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              devtools.log(value.toString());
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  // devtools.log(shouldLogout.toString());
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text("LogOut")),
              ];
            },
          )
        ],
      ),
      body: const Text("KwiKwi Hello"),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign Out"),
          content: const Text("are you sure to SignOut"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("NO")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Sure")),
          ],
        );
      }).then((value) => value ?? false);
}
