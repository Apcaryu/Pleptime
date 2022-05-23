import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Pleptime', storage: TimeStorage(),),
    );
  }
}

class TimeStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // get file location
  Future<File> get _startTimeFile async {
    final path = await _localPath;
    return File('$path/startTime.txt');
  }

  Future<File> get _totalTimeFile async {
    final path = await _localPath;
    return File('$path/totalTime.txt');
  }

  // read files
  Future<int> readStartFile() async {
    try {
      final startFile = await _startTimeFile;

      // Read the file
      final contents = await startFile.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<double> readTotalFile() async {
    try {
      final totalFile = await _totalTimeFile;

      // Read the file
      final contents = await totalFile.readAsString();

      return double.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  // write files
  Future<File> writeStartTime(int time) async {
    final file = await _startTimeFile;

    // Write the file
    return file.writeAsString('$time');
  }

  Future<File> writeTotalTime(double time) async {
    final file = await _totalTimeFile;

    // Write the file
    return file.writeAsString('$time');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.storage});

  final String title;
  final TimeStorage storage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _inThePlace = false;
  dynamic _iconButton = Icons.login;
  dynamic _startTime = 0;
  dynamic _endTime = 0;
  dynamic _totalTime = 0.0;

  @override
  void initState() {
    super.initState();
    widget.storage.readStartFile().then((value) {
      setState(() {
        _startTime = value;
        if (value != 0) {
          _inThePlace = true;
          _iconButton = Icons.logout;
        }
      });
    });
    widget.storage.readTotalFile().then((value) {
      setState(() {
        _totalTime = value;
      });
    });
  }

  Future<File> _setStartTime(bool startToZeroMod) {
    if (startToZeroMod) {
      return widget.storage.writeStartTime(0);
    } else {
      return widget.storage.writeStartTime(_startTime);
    }
  }

  Future<File> _totalTimeSum() {
    // Write the variable as a string to the file.
    return widget.storage.writeTotalTime(_totalTime);
  }

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
              Text("$_startTime + $_endTime = $_totalTime H"),
              IconButton(onPressed: () {
                setState(() {
                  if (_inThePlace) {
                    _iconButton = Icons.login;
                    _inThePlace = false;
                    _endTime = getTime();
                    _totalTime += (_endTime - _startTime) / 60;
                    _startTime = 0;
                    _endTime = 0;
                    _totalTimeSum();
                    _setStartTime(true);
                  }
                  else {
                    _iconButton = Icons.logout;
                    _inThePlace = true;
                    _startTime = getTime();
                    _setStartTime(false);
                  }
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