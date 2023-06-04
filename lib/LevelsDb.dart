import 'package:hive/hive.dart';

part 'LevelsDb.g.dart';

@HiveType(typeId: 1)
class LevelsDb {
  LevelsDb({
    required this.currentLevel,
    required this.previousMovements
  });
  @HiveField(0)
  int currentLevel;

  @HiveField(1)
  List<int> previousMovements;
}