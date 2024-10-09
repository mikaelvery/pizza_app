import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:pizzaapp/pages/connexion/homepage.dart';
import 'package:provider/provider.dart';
import 'package:pizzaapp/auth/authprovider.dart';
import 'package:pizzaapp/auth/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(
            create: (context) => UserProvider(context.read<AuthProvider>())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Ciao Ciao',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
