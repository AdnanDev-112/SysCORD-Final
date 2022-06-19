import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sysbin/providers/userroleprov.dart';
import 'package:sysbin/screens/home_.dart';
import 'package:sysbin/screens/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Main());
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  late StreamSubscription<User?> user;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        // print(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserRoleProvider>(
          create: (context) => UserRoleProvider(),
        )
      ],
      child: MaterialApp(
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? 'LoginScreen'
            : 'HomeScreen',
        routes: {
          'HomeScreen': (context) => Home(),
          'LoginScreen': (context) => LoginScreen(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green),
        home: const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }
}
