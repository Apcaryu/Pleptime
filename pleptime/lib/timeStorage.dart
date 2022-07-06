import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'statePage.dart';

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
