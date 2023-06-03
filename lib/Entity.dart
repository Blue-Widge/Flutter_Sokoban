import 'Levels.dart';

class Entity
{
  int row;
  int column;
  String bloc;
  Level currentLevel;
  bool oversteppable;

  Entity({required this.row, required this.column, required this.bloc, required this.currentLevel, this.oversteppable = false});

  bool moveable(int direction) => false;

  bool moveEntity(int direction) => false;
}

class MovableEntity extends Entity
{
  bool onObjective = false;

  MovableEntity({required super.row, required super.column, required super.bloc, required super.currentLevel, super.oversteppable});

  @override bool moveable(int direction)
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
    return obstacle.oversteppable || obstacle.moveEntity(direction);
  }

  void printGriDoversteppable()
  {
    for(int i = 0; i < currentLevel.height; ++i)
      {
        for(int j = 0; j < currentLevel.blocsGrid[i].length; ++j)
          {
            print(oversteppable.toString());
          }
      }
  }

  @override bool moveEntity(int direction)
  {
    printGriDoversteppable();
    if (!moveable(direction))
      return false;

    late bool gotOnObjective;
    if (direction == DirectionType.RIGHT)
    {
      gotOnObjective = currentLevel.blocsGrid[row][column + 1].bloc == BlocType.OBJECTIVE;
      this.column += 1;
      currentLevel.blocsGrid[row][column] = this;
      currentLevel.blocsGrid[row][column - 1] = Entity(row: row, column: column - 1, bloc: gotOnObjective ? BlocType.OBJECTIVE : BlocType.GROUND, currentLevel: currentLevel, oversteppable: true);
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
    return true;
  }
}

class PlayerEntity extends MovableEntity
{
  PlayerEntity({required super.row, required super.column, required super.bloc, required super.currentLevel});
}
