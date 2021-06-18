import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import './screens/homepage.dart';
import './screens/imagetotext.dart';
import './screens/voicetotext.dart';
import './providers/imageurl.dart';
import './screens/tutorials-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ImageUrl(),
        )
      ],
      child: MaterialApp(
        title: 'Group Project',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.amber,
          fontFamily: 'Helvetica',
        ),
        home: HomePage(),
        routes: {
          ImageToText.routeName: (ctx) => ImageToText(),
          VoiceToText.routeName: (ctx) => VoiceToText(),
          TutorialsScreen.routeName: (ctx) => TutorialsScreen(),
        },
      ),
    );
  }
}
