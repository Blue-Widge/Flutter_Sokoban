import 'package:hive/hive.dart';

part 'LevelsDb.g.dart';

@HiveType(typeId: 1)
class LevelsDb {
  LevelsDb({
    required this.currentLevel,
    required this.previousBlocsGrids
  });
  @HiveField(0)
  int currentLevel;

  @HiveField(1)
  List<List<String>> previousBlocsGrids;
}