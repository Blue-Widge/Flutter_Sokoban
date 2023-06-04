import 'package:hive/hive.dart';

part 'gameData.g.dart';

@HiveType(typeId: 1)
class LevelsDb
{
  LevelsDb({
    required this.currentLevel,
    required this.levelGrids
  });

  @HiveField(0)
  int currentLevel;

  @HiveField(1)
  List<List<String>> levelGrids;
}