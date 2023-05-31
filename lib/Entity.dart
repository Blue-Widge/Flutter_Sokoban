import 'Levels.dart';

class Entity
{
  int posX;
  int posY;
  String bloc;
  Level currentLevel;
  bool oversteppable;

  Entity({required this.posX, required this.posY, required this.bloc, required this.currentLevel, this.oversteppable = false});

  bool moveEntity(int direction) => false;
}

class PlayerEntity extends Entity
{
  PlayerEntity({required super.posX, required super.posY, required super.bloc, required super.currentLevel});

}

class MovableEntity extends Entity
{
  MovableEntity({required super.posX, required super.posY, required super.bloc, required super.currentLevel, super.oversteppable});

  bool moveable(int direction)
  {
    late Entity obstacle;

    if (direction == DirectionType.UP)
    {
      obstacle = currentLevel.blocsGrid[posX][posY + 1];
    }
    if (direction == DirectionType.RIGHT)
    {
      obstacle = currentLevel.blocsGrid[posX + 1][posY];
    }
    if (direction == DirectionType.DOWN)
    {
      obstacle = currentLevel.blocsGrid[posX][posY - 1];
    }
    if (direction == DirectionType.LEFT)
    {
      obstacle = currentLevel.blocsGrid[posX - 1][posY];
    }
    return obstacle.moveEntity(direction) || obstacle.oversteppable;
  }

  @override bool moveEntity(int direction)
  {
    if (!moveable(direction))
      return false;

    Entity temp;

    if (direction == DirectionType.UP)
    {
      temp = currentLevel.blocsGrid[posX][posY + 1];
      currentLevel.blocsGrid[posX][posY + 1] = currentLevel.blocsGrid[posX][posY];
      currentLevel.blocsGrid[posX][posY] = temp;
    }
    if (direction == DirectionType.RIGHT)
    {
      temp = currentLevel.blocsGrid[posX + 1][posY];
      currentLevel.blocsGrid[posX + 1][posY] = currentLevel.blocsGrid[posX][posY];
      currentLevel.blocsGrid[posX][posY] = temp;
    }
    if (direction == DirectionType.DOWN)
    {
      temp = currentLevel.blocsGrid[posX][posY - 1];
      currentLevel.blocsGrid[posX][posY - 1] = currentLevel.blocsGrid[posX][posY];
      currentLevel.blocsGrid[posX][posY] = temp;
    }
    if (direction == DirectionType.LEFT)
    {
      temp = currentLevel.blocsGrid[posX - 1][posY];
      currentLevel.blocsGrid[posX - 1][posY] = currentLevel.blocsGrid[posX][posY];
      currentLevel.blocsGrid[posX][posY] = temp;
    }
    return true;
  }
}
