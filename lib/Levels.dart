import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/services.dart';

class Level
{
  int height;
  int width;
  List<String> levelGrid;
  late List<List<Entity>> blocsGrid;

  Level({required this.height, required this.width, required this.levelGrid})
  {
    _initializeGrid();
  }

  void _initializeGrid()
  {
    blocsGrid = List<List<Entity>>.generate(height,
            (row) => List<Entity>.generate(width,
                    (column) => (levelGrid[row][column] == BlocType.BOX || levelGrid[row][column] == BlocType.GROUND) ?
                        MovableEntity(posX: row, posY: column, bloc: levelGrid[row][column], currentLevel: this) :
                        Entity(posX : row, posY: column, bloc: levelGrid[row][column], currentLevel: this)
            )
    );
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
      });
    }
    catch(e)
    {
      throw Exception("Couldn't open $levelsPath check if the file exists or is in the pubspec.yaml");
    }
  }

  void setLevel(int levelNumber) => currentLevel = levelNumber - 1;

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
}

class Entity
{
  int posX;
  int posY;
  String bloc;
  Level currentLevel;

  Entity({required this.posX, required this.posY, required this.bloc, required this.currentLevel});

  bool moveable(int direction) => false;
}

class MovableEntity extends Entity
{
  MovableEntity({required super.posX, required super.posY, required super.bloc, required super.currentLevel});

  @override bool moveable(int direction)
  {
    var obstacle = BlocType.HOLE;

    if (direction == DirectionType.UP)
    {
      obstacle = currentLevel.levelGrid[posX][posY + 1];
      if (obstacle == BlocType.BOX)
        return currentLevel.blocsGrid[posX][posY + 1].moveable(direction);
    }
    if (direction == DirectionType.RIGHT)
    {
      obstacle = currentLevel.levelGrid[posX + 1][posY];
      if (obstacle == BlocType.BOX)
        return currentLevel.blocsGrid[posX + 1][posY].moveable(direction);
    }
    if (direction == DirectionType.DOWN)
    {
      obstacle = currentLevel.levelGrid[posX][posY - 1];
      if (obstacle == BlocType.BOX)
        return currentLevel.blocsGrid[posX][posY - 1].moveable(direction);
    }
    if (direction == DirectionType.LEFT)
    {
      obstacle = currentLevel.levelGrid[posX - 1][posY];
      if (obstacle == BlocType.BOX)
        return currentLevel.blocsGrid[posX - 1][posY].moveable(direction);
    }
    if ( obstacle == BlocType.WALL || obstacle == BlocType.HOLE)
      return false;

    return true;
  }

  void moveEntity(int direction)
  {
    if (!moveable(direction))
      return;

    if (direction == DirectionType.UP)
    {
      currentLevel.levelGrid[posX] = currentLevel.levelGrid[posX].replaceRange(posY + 1, posY + 1, bloc);
      currentLevel.levelGrid[posX] = currentLevel.levelGrid[posX].replaceRange(posY, posY, BlocType.GROUND);
    }
    if (direction == DirectionType.RIGHT)
    {
      currentLevel.levelGrid[posX + 1] = currentLevel.levelGrid[posX + 1].replaceRange(posY, posY, bloc);
      currentLevel.levelGrid[posX] = currentLevel.levelGrid[posX].replaceRange(posY, posY, BlocType.GROUND);
    }
    if (direction == DirectionType.DOWN)
    {
      currentLevel.levelGrid[posX] = currentLevel.levelGrid[posX].replaceRange(posY - 1, posY - 1, bloc);
      currentLevel.levelGrid[posX] = currentLevel.levelGrid[posX].replaceRange(posY, posY, BlocType.GROUND);
    }
    if (direction == DirectionType.LEFT)
    {
      currentLevel.levelGrid[posX - 1] = currentLevel.levelGrid[posX - 1].replaceRange(posY, posY, bloc);
      currentLevel.levelGrid[posX] = currentLevel.levelGrid[posX].replaceRange(posY, posY, BlocType.GROUND);
    }
  }
}

class BlocType
{
  static String EMPTY = ' ';
  static String GROUND = ' ';
  static String WALL = '#';
  static String BOX = '\$';
  static String HOLE = '.';
  static String OBJECTIVE = '@';
}

class DirectionType
{
  static int UP = 0;
  static int RIGHT = 1;
  static int DOWN = 2;
  static int LEFT = 3;
}