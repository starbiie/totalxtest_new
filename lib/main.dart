import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:totalx_test/Controller/providers/userProvider.dart';
import 'package:totalx_test/View/login.dart';
import 'package:totalx_test/firebase_options.dart';


Future<void> main()async {
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
    return MultiProvider(providers: [ChangeNotifierProvider(create: (context) => UserProvider(),)],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // fontFamily: GoogleFonts.abhayaLibre().fontFamily,
      
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),debugShowCheckedModeBanner: false,
        home: Auth1(),
      ),
    );
  }
}
