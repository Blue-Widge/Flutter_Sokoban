import 'package:hive/hive.dart';

part 'gameData.g.dart';

@HiveType(typeId: 1)
class LevelsDb
{
  LevelsDb({
    required this.currentLevel,
    required this.currentLevelMoves,
    required this.levelGrid
  });

  @HiveField(0)
  int currentLevel;

  @HiveField(1)
  List<String> levelGrid;

  @HiveField(2)
  List<int> currentLevelMoves;
}