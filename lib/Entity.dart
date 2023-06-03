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
  String onBloc = BlocType.GROUND;

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

  @override bool moveEntity(int direction)
  {
    if (!moveable(direction))
      return false;

    late String gotOnBloc;
    if (direction == DirectionType.RIGHT)
    {
      gotOnBloc = currentLevel.blocsGrid[row][column + 1].bloc;
      this.column += 1;
      currentLevel.blocsGrid[row][column] = this;
      currentLevel.blocsGrid[row][column - 1] = Entity(row: row, column: column - 1, bloc: onBloc, currentLevel: currentLevel, oversteppable: true);
    }
    else if (direction == DirectionType.DOWN)
    {
      gotOnBloc = currentLevel.blocsGrid[row + 1][column].bloc;
      this.row += 1;
      currentLevel.blocsGrid[row][column] = this;
      currentLevel.blocsGrid[row - 1][column] = Entity(row: row - 1, column: column, bloc: onBloc, currentLevel: currentLevel, oversteppable: true);
    }
    else if (direction == DirectionType.LEFT)
    {
      gotOnBloc = currentLevel.blocsGrid[row][column - 1].bloc;
      this.column -= 1;
      currentLevel.blocsGrid[row][column] = this;
      currentLevel.blocsGrid[row][column + 1] = Entity(row: row, column: column + 1, bloc: onBloc, currentLevel: currentLevel, oversteppable: true);
    }
    else if (direction == DirectionType.UP)
    {
      gotOnBloc = currentLevel.blocsGrid[row - 1][column].bloc;
      this.row -= 1;
      currentLevel.blocsGrid[row][column] = this;
      currentLevel.blocsGrid[row + 1][column] = Entity(row: row + 1, column: column, bloc: onBloc, currentLevel: currentLevel, oversteppable: true);
    }
    onBloc = gotOnBloc;
    return true;
  }
}

class PlayerEntity extends MovableEntity
{
  PlayerEntity({required super.row, required super.column, required super.bloc, required super.currentLevel});
}
