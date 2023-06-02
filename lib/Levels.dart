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
  PlayerEntity? player;

  Level({required this.height, required this.width, required this.levelGrid}) {initializeGrid();}
  void checkInsideOrOutside()
  {
    for(int i = 0; i < height; ++i)
    {
      int lineLength = levelGrid[i].length;
      for (int j = 0; j < lineLength; ++j)
      {
        if (levelGrid[i][j] != BlocType.EMPTY)
          continue;
        bool foundWall = false;

        //check up
        for(int k = i; k >= 0; --k)
        {
          if (levelGrid[k].length > j && levelGrid[k][j] == BlocType.WALL)
          {
            foundWall = true;
            break;
          }
        }
        if (!foundWall)
          continue;
        foundWall = false;

        //check right
        for(int k = j; k < lineLength; ++k)
        {
          if (levelGrid[i][k] == BlocType.WALL)
          {
            foundWall = true;
            break;
          }
        }
        if (!foundWall)
          continue;
        foundWall = false;
        //check down
        for(int k = i; k < height; ++k)
        {
          if (levelGrid[k].length > j && levelGrid[k][j] == BlocType.WALL)
          {
            foundWall = true;
            break;
          }
        }
        if (!foundWall)
          continue;
        foundWall = false;
        //check left
        for(int k = j; k >= 0; --k)
        {
          if (levelGrid[i][k] == BlocType.WALL)
          {
            foundWall = true;
            break;
          }
        }
        if (!foundWall)
          continue;
        levelGrid[i] = levelGrid[i].replaceRange(j, j+1, BlocType.GROUND);
      }
    }
  }

  void initializeGrid()
  {
    try {
      if (!initialized)
        {
          checkInsideOrOutside();

          blocsGrid = List<List<Entity>>.generate(height,
                  (row) =>
              List<Entity>.generate(levelGrid[row].length,
                      (column) =>
                  (levelGrid[row][column] == BlocType.BOX) ?
                  MovableEntity(posX: row, posY: column, bloc: BlocType.BOX, currentLevel: this) :
                  (levelGrid[row][column] == BlocType.PLAYER) ?
                  PlayerEntity(posX: row, posY: column, bloc: BlocType.PLAYER, currentLevel: this) :
                  Entity(posX: row,
                      posY: column,
                      bloc: levelGrid[row][column],
                      currentLevel: this,
                      oversteppable: (levelGrid[row][column] == BlocType.GROUND))
              )
          );
          initialized = true;
        }
    }
    catch(e, stackTrace)
    {
      print("Couldn't load level, try checking the json - ERROR : $e at Line - $stackTrace");
    }
  }

  void resetLevel()
  {
    for(int i = 0; i < height; ++i)
      {
        for(int j = 0; j < blocsGrid[i].length; ++j)
          {
            blocsGrid[i][j].bloc = levelGrid[i][j];
          }
      }
  }

}

class LevelManager
{
  late List<Level>? _levels;
  int currentLevel = 1;

  LevelManager({required String levelsPath})
  {
    try
    {
      _parseLevels(levelsPath).then((_)
      {
        print("Successfully opened the json file");
      });
    }
    catch(e)
    {
      throw Exception("Couldn't open $levelsPath check if the file exists or is in the pubspec.yaml");
    }
  }

  void isLevelParsed() => _levels != null;

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

    if (!_levels![currentLevel].initialized)
    {
        _levels![currentLevel].initializeGrid();
    }
  }

  Level getLevel(int levelNumber)
  {
    return _levels![levelNumber];
  }
}

class BlocType
{
  static const String EMPTY = ' ';
  static const String GROUND = '_';
  static const String WALL = '#';
  static const String BOX = '\$';
  static const String OBJECTIVE = '.';
  static const String PLAYER = '@';
}

class DirectionType
{
  static const int UP = 0;
  static const int RIGHT = 1;
  static const int DOWN = 2;
  static const int LEFT = 3;
  static int IDLE = 4;
}