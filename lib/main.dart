import 'package:authentification/firebase_options.dart';
import 'package:authentification/pages/home_page.dart';
import 'package:authentification/pages/redirection_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData( 
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const RedirectionPage(),
    );
  }
}

