import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Pleptime'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _inThePlace = false;
  dynamic _iconButton = Icons.login;
  dynamic _startTime = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme()._mainColor,
        foregroundColor: ColorTheme()._secondaryColor,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
            children: [
              Text(_startTime.toString()),
              IconButton(onPressed: () {
                setState(() {
                  if (_inThePlace) {
                    _iconButton = Icons.logout;
                    _inThePlace = false;
                  }
                  else {
                    _iconButton = Icons.login;
                    _inThePlace = true;
                  }
                  //_iconButton = Icons.logout;
                  _startTime = getTime();
                });
              },
                  icon: Icon(_iconButton)
              ),
            ],
          ),
      ),
    );
  }
}

dynamic getTime() {
  final minutes = DateTime.now().minute;
  final hour = DateTime.now().hour;
  final total = (hour * 60) + minutes;

  return total;
}

class ColorTheme {
  final _mainColor = Colors.black;
  final _secondaryColor = Colors.white;
  final _feedbackColor = Colors.deepOrange;
}