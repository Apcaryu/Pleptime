import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'colorTheme.dart';
import 'timeStorage.dart';

class MyStatPage extends StatefulWidget {
  const MyStatPage({super.key, title, required this.storage});

  final TimeStorage storage;

  @override
  State<MyStatPage> createState() => _MyStatPageState();
}

class _MyStatPageState extends State<MyStatPage> {

  dynamic _totalTime;
  dynamic _totalTimeRound;

  @override
  void initState() {
    widget.storage.readTotalFile().then((value) {
      setState(() {
        _totalTime = value;
        _totalTimeRound = _totalTime.round();
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text("Stats"),
      ),
      body: Center(
        child: Card(
          color: Colors.white10,
          child: SizedBox(
            width: double.infinity,
            height: 200,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(10)),
                Text("Temps de présence:", textScaleFactor: 1.5,),
                Padding(padding: EdgeInsets.all(20)),
                Text("$_totalTimeRound H",
                  textScaleFactor: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){},
                        child: Text("-"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrange),
                    ),
                    Padding(padding: EdgeInsets.all(30)),
                    ElevatedButton(onPressed: (){},
                        child: Text("+"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrange,
                        ),)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.white,
          currentIndex: 1,
          onTap: (value) {
            if (value == 0) {
              Navigator.pop(context);
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
          ],
        ),
      );
  }
}