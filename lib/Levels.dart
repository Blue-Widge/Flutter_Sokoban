import 'dart:convert';
import 'package:flutter/services.dart';
import 'Entity.dart';

class Level
{
  int height;
  int width;
  List<String> levelGrid;
  bool initialized = false;
  late List<List<Entity>> blocsGrid;

  Level({required this.height, required this.width, required this.levelGrid}) {initializeGrid();}


  void TEMP_SHOWLEVEL()
  {
    for(int i = 0; i < height; ++i)
      print(levelGrid[i]);
  }

  void initializeGrid()
  {
    try
    {
      if (!initialized)
      {
        for(int i = 0; i < height; ++i)
        {
          bool inside = false;
          bool wallPrevious = false;
          for(int j = 0; j < levelGrid[i].length; ++j)
          {
            if (!(levelGrid[i][j] == BlocType.WALL))
            {
              inside = inside ^ wallPrevious;
              if (inside)
              {
                String char = levelGrid[i][j] == BlocType.EMPTY ? BlocType.GROUND : levelGrid[i][j];
                levelGrid[i] = levelGrid[i].substring(0, j) + char + levelGrid[i].substring(j + 1);
              }
            }
            wallPrevious = levelGrid[i][j] == BlocType.WALL;
          }
        }
      }

      blocsGrid = List<List<Entity>>.generate(height,
              (row) => List<Entity>.generate(levelGrid[row].length,
                  (column) => (levelGrid[row][column] == BlocType.BOX) ?
                    MovableEntity(posX: row, posY: column, bloc: BlocType.BOX, currentLevel: this) :
                    (levelGrid[row][column] == BlocType.SPAWNPOINT) ?
                      PlayerEntity(posX: row, posY: column, bloc: BlocType.SPAWNPOINT, currentLevel: this) :
                      Entity(posX : row, posY: column, bloc: levelGrid[row][column], currentLevel: this, oversteppable: (levelGrid[row][column] == BlocType.GROUND))
          )
      );
      initialized = true;
    }
    catch(e)
    {
      print("Couldn't load level, try checking the json - ERROR : $e");
    }
  }

  void resetLevel()
  {
    initializeGrid();
  }

}

class LevelManager
{
  late List<Level> _levels;
  int currentLevel = 0;

  LevelManager({required String levelsPath})
  {
    try
    {
      _parseLevels(levelsPath).then((_)
      {
        print("Successfully opened the json file");
        _levels[0].TEMP_SHOWLEVEL();
      });
    }
    catch(e)
    {
      throw Exception("Couldn't open $levelsPath check if the file exists or is in the pubspec.yaml");
    }
  }

  void setLevel(int levelNumber) => currentLevel = levelNumber;

  Future<void> _parseLevels(String levelsPath) async
  {
    final String response = await rootBundle.loadString(levelsPath);

    final data = await json.decode(response);

    _levels = List<Level>.from(data.map((level) => Level(
      height:level['hauteur'],
      width:level['largeur'],
      levelGrid: List<String>.from(level['lignes'])
    )));
  }

  void chargeLevel(int levelNumber)
  {
    setLevel(levelNumber);

    if (!_levels[currentLevel].initialized)
    {
        _levels[currentLevel].initializeGrid();
    }
  }
}

class BlocType
{
  static const String EMPTY = ' ';
  static const String GROUND = '_';
  static const String WALL = '#';
  static const String BOX = '\$';
  static const String OBJECTIVE = '.';
  static const String SPAWNPOINT = '@';
}

class DirectionType
{
  static const int UP = 0;
  static const int RIGHT = 1;
  static const int DOWN = 2;
  static const int LEFT = 3;
}