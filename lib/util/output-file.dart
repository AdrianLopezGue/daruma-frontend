import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Output {
  static Output _instance;

  factory Output() {
    if (_instance == null) _instance = Output._internal();
    return _instance;
  }

  Output._internal();

  Future<void> writeString(String fileName, String text) async {   
    
    if (text == null || fileName == null) return;
    
    final directory = await getExternalStorageDirectory();
    final pathOfTheFileToWrite = directory.path + "/$fileName.csv";

    File file = File(pathOfTheFileToWrite);
    file.writeAsString(text);
  }
}