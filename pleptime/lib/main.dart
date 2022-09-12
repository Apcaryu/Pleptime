import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'statePage.dart';
import 'timeStorage.dart';
import 'global.dart' as global;

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
    Navigator.push(context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) {
          return MyStatPage(title: 'Stat', storage: TimeStorage(),);
        }));
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
  dynamic _iconButton = Icons.play_arrow;
  dynamic _startTime = 0;
  dynamic _endTime = 0;
  dynamic _totalTime = 0.0;
  dynamic _totalTimeRound = 0.0;
  dynamic _currentMonth = 0;
  dynamic _actualTotalTime = 0.0;

  @override
  void initState() {
    super.initState();
    widget.storage.readStartFile().then((value) {
      setState(() {
        _startTime = value;
        if (value != 0) {
          _inThePlace = true;
          _iconButton = Icons.stop;
          _startTimeText = setStartTimeString(_startTime);
          _buttonText = 'OUT PLACE';
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
      _currentMonth = getTime(1);
      if (value != _currentMonth && (1 <= value && value <= 12)) {
        if (_inThePlace) {
          _startTime = 1;
        } else {
          _startTime = 0;
        }
        _totalTime = 0.0;
        _totalTimeRound = 0;
        _totalTimeSum();
      }
      _setCurrentMonth();
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
                    ],
                  ),
                ),
              ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorTheme()._feedbackColor,
        onPressed: () {
          widget.storage.readTotalFile().then((value) {
            setState((){
              _actualTotalTime = value;
            });
          });
          setState(() {
            if (_inThePlace) {
              _buttonText = 'IN PLACE';
              _iconButton = Icons.play_arrow;
              _inThePlace = false;
              _endTime = getTime(0);
              _totalTime = setTotalTime(_totalTime, _startTime, _endTime, _actualTotalTime);
              _totalTimeRound = _totalTime.round();
              _startTime = 0;
              _startTimeText = setStartTimeString(_startTime);
              _endTime = 0;
              _totalTimeSum();
              _setStartTime(true);
            }
            else {
              _buttonText = 'OUT PLACE';
              _iconButton = Icons.stop;
              _inThePlace = true;
              _startTime = getTime(0);
              _setStartTime(false);
              _startTimeText = setStartTimeString(_startTime);
            }
          });
        },
        child: Icon(_iconButton),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: ColorTheme()._mainColor,
        selectedItemColor: ColorTheme()._feedbackColor,
        unselectedItemColor: ColorTheme()._secondaryColor,
        onTap: (value) {
          if (value == 1) {
            Navigator.push(context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return MyStatPage(title: 'Stat', storage: TimeStorage(),);
                    }));
          }
        },
        items: [
        BottomNavigationBarItem(
        label: 'Timer',
        icon: Icon(Icons.access_time),
      ),
        BottomNavigationBarItem(
          label: 'List',
          icon: Icon(Icons.list),
        ),
      ]
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
  if (startTime != 0) {
    final minutes = startTime % 60;
    final hour = ((startTime - minutes) / 60).floor();
    dynamic txtMinutes = "";
    dynamic txtHour = "";
    if (minutes < 10) {
      txtMinutes = "0$minutes";
    } else {
      txtMinutes = "$minutes";
    }
    if (hour < 10) {
      txtHour = "0$hour";
    } else {
      txtHour = "$hour";
    }
    return "$txtHour:$txtMinutes";
  } else {
    return "--:--";
  }
}

double setTotalTime(double _totalTime, int _startTime, int _endTime, double _actualTotalTime) {
  print("$_totalTime | $_actualTotalTime");
  if (_totalTime != _actualTotalTime) {
    _totalTime = _actualTotalTime;
  }
  print("$_totalTime | $_actualTotalTime");
  if (_endTime < _startTime) {
    _totalTime += (1440 - _startTime) / 60; // 1440 minutes = 24 hour
    _totalTime += _endTime / 60;
    return _totalTime;
  } else {
    _totalTime += (_endTime - _startTime) / 60;
    return _totalTime;
  }
}

class ColorTheme {
  final _mainColor = Colors.black;
  final _secondaryColor = Colors.white;
  final _secondaryColorDark = Colors.white10;
  final _feedbackColor = Colors.deepOrange;
}