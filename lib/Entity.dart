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

class MovableEntity extends Entity
{
  bool onObjective = false;

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

    bool gotOnObjective = false;
    if (direction == DirectionType.UP)
    {
      gotOnObjective = currentLevel.blocsGrid[posX][posY + 1].bloc == BlocType.OBJECTIVE;
      currentLevel.blocsGrid[posX][posY + 1] = this;
    }
    if (direction == DirectionType.RIGHT)
    {
      gotOnObjective = currentLevel.blocsGrid[posX + 1][posY].bloc == BlocType.OBJECTIVE;
      currentLevel.blocsGrid[posX + 1][posY] = this;
    }
    if (direction == DirectionType.DOWN)
    {
      gotOnObjective = currentLevel.blocsGrid[posX][posY - 1].bloc == BlocType.OBJECTIVE;
      currentLevel.blocsGrid[posX][posY - 1] = this;
    }
    if (direction == DirectionType.LEFT)
    {
      gotOnObjective = currentLevel.blocsGrid[posX - 1][posY].bloc == BlocType.OBJECTIVE;
      currentLevel.blocsGrid[posX - 1][posY] = this;
    }
    currentLevel.blocsGrid[posX][posY] = Entity(posX: posX, posY: posY, bloc: onObjective ? BlocType.OBJECTIVE : BlocType.GROUND, currentLevel: currentLevel);
    onObjective = gotOnObjective;
    return true;
  }
}

class PlayerEntity extends MovableEntity
{
  PlayerEntity({required super.posX, required super.posY, required super.bloc, required super.currentLevel});

}
