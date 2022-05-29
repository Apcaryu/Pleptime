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

  Future<File> get _currentMonthFile async {
    final path = await _localPath;
    return File('$path/currentMonth.txt');
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

  Future<int> readMonthFile() async {
    try {
      final monthFile = await _currentMonthFile;

      final contents = await monthFile.readAsString();

      return int.parse(contents);
    } catch (e) {
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

  Future<File> writeCurrentMonth(int month) async {
    final file = await _currentMonthFile;

    return file.writeAsString('$month');
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
  String _buttonText = 'IN PLACE';
  String _startTimeText = '--:--';
  dynamic _iconButton = Icons.login;
  dynamic _startTime = 0;
  dynamic _endTime = 0;
  dynamic _totalTime = 0.0;
  dynamic _totalTimeRound = 0.0;
  dynamic _currentMonth = 0;

  @override
  void initState() {
    super.initState();
    widget.storage.readStartFile().then((value) {
      setState(() {
        _startTime = value;
        if (value != 0) {
          _inThePlace = true;
          _iconButton = Icons.logout;
          _startTimeText = setStartTimeString(_startTime);
        }
      });
    });
    widget.storage.readTotalFile().then((value) {
      setState(() {
        _totalTime = value;
        _totalTimeRound = _totalTime.round();
      });
    });
  widget.storage.readMonthFile().then((value) {
    setState(() {
      if (value < 1 && 12 < value) {
        _currentMonth = getTime(1);
        _setCurrentMonth();
      } else {
        _currentMonth = getTime(1);
        if (value != _currentMonth && (1 <= value && value <= 12)) {
          _totalTime = 0;
          _totalTimeRound = _totalTime.round;
          _totalTimeSum();
        }
        _setCurrentMonth();
      }
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

  Future<File> _setCurrentMonth() {
    // Write the variable as a string to the file.
    return widget.storage.writeCurrentMonth(_currentMonth);
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: ColorTheme()._secondaryColorDark,
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Heure d'arrivée:", textScaleFactor: 1.5,),
                      const Padding(padding: EdgeInsets.all(20)),
                      Text(_startTimeText,
                        textScaleFactor: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Padding(padding: EdgeInsets.all(20)),
                    ],
                  ),
                ),
              ),
              // Card for totalTime
              Card(
                color: ColorTheme()._secondaryColorDark,
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Column(
                    children: [
                      const Padding(padding: EdgeInsets.all(10)),
                      const Text("Temps de présence:", textScaleFactor: 1.5,),
                      const Padding(padding: EdgeInsets.all(20)),
                      Text("$_totalTimeRound H",
                        textScaleFactor: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      ElevatedButton.icon(
                        onPressed: () {
                            setState(() {
                              if (_inThePlace) {
                                _buttonText = 'IN PLACE';
                                _iconButton = Icons.login;
                                _inThePlace = false;
                                _endTime = getTime(0);
                                _totalTime += (_endTime - _startTime) / 60;
                                _totalTimeRound = _totalTime.round();
                                _startTime = 0;
                                _startTimeText = setStartTimeString(_startTime);
                                _endTime = 0;
                                _totalTimeSum();
                                _setStartTime(true);
                              }
                              else {
                                _buttonText = 'OUT PLACE';
                                _iconButton = Icons.logout;
                                _inThePlace = true;
                                _startTime = getTime(0);
                                _setStartTime(false);
                                _startTimeText = setStartTimeString(_startTime);
                              }
                            });
                        },
                        icon: Icon(_iconButton),
                        label: Text(_buttonText),
                        style: ElevatedButton.styleFrom(
                          primary: ColorTheme()._feedbackColor,
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}

dynamic getTime(int mod) {
  final minutes = DateTime.now().minute;
  final hour = DateTime.now().hour;
  final total = (hour * 60) + minutes;
  final currentMonth = DateTime.now().month;

  if (mod == 0) {
    return total;
  } else {
    return currentMonth;
  }
}

String setStartTimeString(int startTime) {
  final minutes = DateTime.now().minute;
  final hour = DateTime.now().hour;
  if (startTime != 0) {
    return "$hour:$minutes";
  } else {
    return "--:--";
  }
}

class ColorTheme {
  final _mainColor = Colors.black;
  final _secondaryColor = Colors.white;
  final _secondaryColorDark = Colors.white10;
  final _feedbackColor = Colors.deepOrange;
}