import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: Center( 
        child: Text(
          "Welcome to my love one's",
          style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold, 
          ),
        ),
      ),
    );
  }
}
