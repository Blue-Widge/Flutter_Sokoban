import 'dart:developer';

import 'package:flutter/cupertino.dart';

import 'Levels.dart';
import 'BoxDb.dart';
import 'LevelsDb.dart';

class Entity
{
  int row;
  int column;
  String bloc;
  Level currentLevel;
  bool oversteppable;

  Entity({required this.row, required this.column, required this.bloc, required this.currentLevel, this.oversteppable = false});


  bool moveable(int direction, int currentLevelNum) => false;

  bool moveEntity(int direction, int curentLevelNum) => false;
}

class MovableEntity extends Entity
{
  bool onObjective = false;

  MovableEntity({required super.row, required super.column, required super.bloc, required super.currentLevel, super.oversteppable});

  @override bool moveable(int direction, int currentLevelNum)
  {
    Entity? obstacle;

    if (direction == DirectionType.RIGHT)
    {
      obstacle = currentLevel.blocsGrid[row][column + 1];
    }
    else if (direction == DirectionType.DOWN)
    {
      obstacle = currentLevel.blocsGrid[row + 1][column];
    }
    else if (direction == DirectionType.LEFT)
    {
      obstacle = currentLevel.blocsGrid[row][column - 1];
    }
    else if (direction == DirectionType.UP)
    {
      obstacle = currentLevel.blocsGrid[row - 1][column];
    }
    else
      return false;
    return obstacle.oversteppable || obstacle.moveEntity(direction, currentLevelNum);
  }

  @override bool moveEntity(int direction, int curentLevelNum)
  {
    if (!moveable(direction, curentLevelNum))
      return false;

    late bool gotOnObjective;
    if (direction == DirectionType.RIGHT)
    {
      gotOnObjective = currentLevel.blocsGrid[row][column + 1].bloc == BlocType.OBJECTIVE;
      this.column += 1;
      currentLevel.blocsGrid[row][column] = this;
      currentLevel.blocsGrid[row][column - 1] = Entity(row: row, column: column - 1, bloc: onObjective ? BlocType.OBJECTIVE : BlocType.GROUND, currentLevel: currentLevel, oversteppable: true);
    }
    else if (direction == DirectionType.DOWN)
    {
      gotOnObjective = currentLevel.blocsGrid[row + 1][column].bloc == BlocType.OBJECTIVE;
      this.row += 1;
      currentLevel.blocsGrid[row][column] = this;
      currentLevel.blocsGrid[row - 1][column] = Entity(row: row - 1, column: column, bloc: onObjective ? BlocType.OBJECTIVE : BlocType.GROUND, currentLevel: currentLevel, oversteppable: true);
    }
    else if (direction == DirectionType.LEFT)
    {
      gotOnObjective = currentLevel.blocsGrid[row][column - 1].bloc == BlocType.OBJECTIVE;
      this.column -= 1;
      currentLevel.blocsGrid[row][column] = this;
      currentLevel.blocsGrid[row][column + 1] = Entity(row: row, column: column + 1, bloc: onObjective ? BlocType.OBJECTIVE : BlocType.GROUND, currentLevel: currentLevel, oversteppable: true);
    }
    else if (direction == DirectionType.UP)
    {
      gotOnObjective = currentLevel.blocsGrid[row - 1][column].bloc == BlocType.OBJECTIVE;
      this.row -= 1;
      currentLevel.blocsGrid[row][column] = this;
      currentLevel.blocsGrid[row + 1][column] = Entity(row: row + 1, column: column, bloc: onObjective ? BlocType.OBJECTIVE : BlocType.GROUND, currentLevel: currentLevel, oversteppable: true);
    }
    onObjective = gotOnObjective;
    String nbInDb = boxDb.length.toString();
    if(boxDb.length > 100)
      boxDb.delete('key_level_$curentLevelNum+_0');
    String key = 'key_level_$curentLevelNum+_$nbInDb';
    List<List<String>> blocGridStr = List<List<String>>.generate(currentLevel.blocsGrid.length, (i) => List<String>.generate(currentLevel.blocsGrid[i].length, (j) => currentLevel.blocsGrid[i][j].bloc));
    boxDb.put(key, LevelsDb(currentLevel: curentLevelNum, previousBlocsGrids: blocGridStr));

    return true;
  }
}

class PlayerEntity extends MovableEntity
{
  PlayerEntity({required super.row, required super.column, required super.bloc, required super.currentLevel});
}
