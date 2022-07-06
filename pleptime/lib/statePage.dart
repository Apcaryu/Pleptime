import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'colorTheme.dart';
import 'timeStorage.dart';

class MyStatPage extends StatefulWidget {
  const MyStatPage({super.key, title});

  @override
  State<MyStatPage> createState() => _MyStatPageState();
}

class _MyStatPageState extends State<MyStatPage> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text("Stats"),
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