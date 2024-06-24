import 'package:flutter/material.dart';
import 'package:habits/models/habit.dart';
import 'package:habits/models/settings.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDataBase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppsettingsSchema],
      directory: dir.path,
    );
  }

  static Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appsettings.where().findFirst();

    if (existingSettings == null) {
      final settings = Appsettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appsettings.put(settings));
    }

    /*

1 setup 
2 init 
3startuo
4get

CRUD
  */
  }

  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appsettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  final List<Habit> currentHabits = [];

  Future<void> addHabit(String habitName) async {
    final newHabit = Habit()..name = habitName;
    await isar.writeTxn(() => isar.habits.put(newHabit));
    readHabit();
  }

  Future<void> readHabit() async {
    List<Habit> fetchedHabits = await isar.habits.where().findAll();
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);
    notifyListeners();
  }

  Future<void> updatedHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(() async {
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now();
          habit.completedDays.add(
            DateTime(today.year, today.month, today.day),
          );
        } else {
          habit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        await isar.habits
            .put(habit); // Ensure the habit is updated in the database
      });
    }

    readHabit();
  }

  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
      readHabit();
    }
  }

  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async { 
      await isar.habits.delete(id);
    });

    readHabit();
  }
}
