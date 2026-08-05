import 'package:hive_flutter/hive_flutter.dart';

abstract class TutorialLocalDataSource {
  Future<bool> isTutorialCompleted(String tutorialId);
  Future<void> markTutorialCompleted(String tutorialId);
  Future<void> resetAllTutorials();
}

class TutorialLocalDataSourceImpl implements TutorialLocalDataSource {
  static const String boxName = 'tutorials_box';

  Future<Box<bool>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<bool>(boxName);
    }
    return await Hive.openBox<bool>(boxName);
  }

  @override
  Future<bool> isTutorialCompleted(String tutorialId) async {
    final box = await _openBox();
    return box.get(tutorialId, defaultValue: false) ?? false;
  }

  @override
  Future<void> markTutorialCompleted(String tutorialId) async {
    final box = await _openBox();
    await box.put(tutorialId, true);
  }

  @override
  Future<void> resetAllTutorials() async {
    final box = await _openBox();
    await box.clear();
  }
}
