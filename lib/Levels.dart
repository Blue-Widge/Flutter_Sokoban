import 'dart:convert';
import 'package:flutter/services.dart';
import 'gameData.dart';
import 'BoxDb.dart';
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
                    (column) => chooseEntity(levelGrid, row, column)
            )
        );
        initialized = true;
      }
      else
      {
        resetLevel();
      }
    }
    catch(e, stackTrace)
    {
      print("Couldn't load level, try checking the json - ERROR : $e at Line - $stackTrace");
    }
  }

  void resetLevel()
  {
    if (!initialized)
      initializeGrid();
    else
    {
      for(int i = 0; i < height; ++i)
      {
        int length = blocsGrid[i].length;
        for(int j = 0; j < length; ++j)
          blocsGrid[i][j] = chooseEntity(levelGrid, i, j);
      }
    }
  }

  bool levelComplete()
  {
    for(int i = 0; i < height; ++i)
    {
      for(int j = 0; j < levelGrid[i].length; ++j)
      {
        if (levelGrid[i][j] == BlocType.OBJECTIVE && blocsGrid[i][j].bloc != BlocType.BOX)
        {
          return false;
        }
      }
    }
    return true;
  }

  Entity chooseEntity(List<String> levelGrid, row, column)
  {
    return
      (levelGrid[row][column] == BlocType.BOX) ?
      MovableEntity(row: row, column: column, bloc: BlocType.BOX, currentLevel: this) :
      (levelGrid[row][column] == BlocType.PLAYER) ?
      player = PlayerEntity(row: row, column: column, bloc: BlocType.PLAYER, currentLevel: this) :
      Entity(row: row,
          column: column,
          bloc: levelGrid[row][column],
          currentLevel: this,
          oversteppable: BlocType.OVERSTEPPABLE.contains(levelGrid[row][column])
      );
  }

  List<String> getBlocsAsStrings()
  {
    List<String> blocsAsStrings = List<String>.empty(growable: true);
    for(int i = 0; i < height; ++i)
      {
        int length = blocsGrid[i].length;
        String currentString = "";
        for(int j = 0; j < length; ++j)
          {
            currentString += blocsGrid[i][j].bloc;
          }
        blocsAsStrings.add(currentString);
      }
    return blocsAsStrings;
  }
}

class LevelManager
{
  List<Level>? _levels;
  int currentLevel = 0;
  int maxLevel = 0;

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

  //#TODO launch credits for finishing the game or smth
  get gameEnding => null;

  bool isLevelParsed() => _levels != null;
  int getNumberOfLevels() => _levels!.length;
  void setLevel(int levelNumber) => currentLevel = levelNumber;

  Future<void> _parseLevels(String levelsPath) async
  {
    final String response = await rootBundle.loadString(levelsPath);

    final data = await json.decode(response);

    _levels = List<Level>.from(data.map((level) =>
        Level(
            height: level['hauteur'],
            width: level['largeur'],
            levelGrid: List<String>.from(level['lignes'])
        )
    ));
    maxLevel = _levels!.length;
  }

  void chargeLevel(int levelNumber)
  {
    setLevel(levelNumber);

    if (!_levels![currentLevel].initialized)
    {
      _levels![currentLevel].initializeGrid();
    }
  }

  void _checkLevelState()
  {
    if (_levels![currentLevel].levelComplete())
    {
      // #TODO launch congrats for finishing the level
      currentLevel == maxLevel ? gameEnding : chargeLevel(currentLevel + 1);
    }
  }

  Level getCurrentLevel()
  {
    _checkLevelState();
    return _levels![currentLevel];
  }

  void resetLevels()
  {
    for(int i = 0; i <= maxLevel; ++i)
      _levels![i].resetLevel();
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
  static const String HOLE = '*';
  static final Set<String> OVERSTEPPABLE = {GROUND, OBJECTIVE};
}

class DirectionType
{
  static const int UP = 0;
  static const int RIGHT = 1;
  static const int DOWN = 2;
  static const int LEFT = 3;
  static int IDLE = 4;
}

class MovementsSaver
{
  late List<int> movements;

  MovementsSaver()
  {
    movements = List<int>.empty(growable: true);
  }

  get getLastReversedDirection => (movements.last + 2) % 4;

  void saveData(int currentLevelNum, int direction, levelGrid)
  {
    movements.add(direction);
    if(movements.length > 100)
      movements = movements.sublist(1, 101);
    String key = 'key_level_$currentLevelNum';
    boxDb.put(key, LevelsDb(currentLevel: currentLevelNum, currentLevelMoves: movements, levelGrid: levelGrid));
  }

  int undoLastMove()
  {
    if (movements.length == 0)
      return DirectionType.IDLE;
    int reversedLastMove = getLastReversedDirection;
    movements = movements.sublist(0, movements.length - 1);
    return reversedLastMove;
  }
}