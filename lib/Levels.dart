import 'dart:convert';
import 'package:flutter/services.dart';

class Level
{
  late int height;
  late int width;
  late List<String> levelBlocs;

  Level({required this.height, required this.width, required this.levelBlocs});
}

class LevelManager
{
  late List<Level> _levels;
  int currLevel = 0;

  LevelManager({required String levelsPath})
  {
    try
    {
      _parseLevels(levelsPath).then((_)
      {
        print(_levels[2].levelBlocs);
        print("Successfully opened the json file");
      });
    }
    catch(e)
    {
      throw Exception("Couldn't open $levelsPath check if the file exists or is in the pubspec.yaml");
    }
  }

  Future<void> _parseLevels(String levelsPath) async
  {
    final String response = await rootBundle.loadString(levelsPath);

    final data = await json.decode(response);

    _levels = List<Level>.from(data.map((level) => Level(
      height:level['hauteur'],
      width:level['largeur'],
      levelBlocs: List<String>.from(level['lignes'])
    )));
  }
}