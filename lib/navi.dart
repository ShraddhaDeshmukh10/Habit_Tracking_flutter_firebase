import 'package:flutter/material.dart';

class Navigation0002 extends StatefulWidget {
  const Navigation0002({super.key});

  @override
  State<Navigation0002> createState() => _Navigation0002State();
}

class _Navigation0002State extends State<Navigation0002> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("This is navigation")),
        body: Container(
          width: 100,
          height: 100,
          child: Text("This only for navigation"),
        ));
  }
}
