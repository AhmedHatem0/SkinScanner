import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test2/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: const _MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SecondScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        child: FlutterLogo(
            size: MediaQuery.of(context).size.height)); //logo splash screen
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Skin Scanner", style: TextStyle(
          fontFamily: 'Montserrat', // Specify the font family
          fontSize: 30,
        ),)),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome To Skin Scanner.",style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.headline4,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),),
                SizedBox(height: 16),
                ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const homepage()));
                },
                child: const Text(
                  'start',
                  style: TextStyle(
                    fontSize: 36.0, // Set the font size
                    fontWeight: FontWeight.normal, // Set the font weight
                    color: Colors.white, // Set the text color
                    fontStyle: FontStyle.normal,
                  ),
                ),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(Size(200.0, 50.0)),
                ),
              )],
            )));
  }
}
