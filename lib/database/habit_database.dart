import 'package:flutter/cupertino.dart';
import 'package:habittute/models/app_settings.dart';
import 'package:habittute/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  /*

  S E T U P

  */

  // I N I T I A L I Z E - D A T A B A S E
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  // Save first date of app startup (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSetting = await isar.appSettings.where().findFirst();
    if (existingSetting == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Get first date of app startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /*

  C R U D X O P E R A T I O N S

  */

  // List of habits
  final List<Habit> currentHabits = [];

  // C R E A T E - add a new habit
  Future<void> addHabit(String habitname) async {
    // Create a new habit
    final newHabit = Habit()..name = habitname;

    // Save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // read from db
    readHabits();
  }

  // R E A D - read saved habit from db
  Future<void> readHabits() async {
    // Fetch all habits from db
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    // Give to current Habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // Update UI
    notifyListeners();
  }

  // U P D A T E - check habits on and off
  Future<void> updateHabitsCompletion(int id, bool isCompleted) async {
    // find a specific habit
    final habit = await isar.habits.get(id);

    // update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        // if habits completed -> add the current date to the completedDays list
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          // today
          final today = DateTime.now();

          //add the current date if it's not already in the list
          habit.completedDays.add(
            DateTime(
              today.year,
              today.month,
              today.day,
            ),
          );
        }

        // if NOT habits completed -> Remove the current date to the completedDays list
        else {
          //remove the current date if the habit is market as not completed
          habit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        // save the updated habits back to the database
        await isar.habits.put(habit);
      });
    }

    // re-read from db
    readHabits();
  }

  // U P D A T E - edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    // find a specific habits
    final habit = await isar.habits.get(id);

    // update habits name
    if (habit != null) {
      // update name
      await isar.writeTxn(() async {
        habit.name = newName;

        // Save updated habit back to db
        await isar.habits.put(habit);
      });
    }

    // re-read from db
    readHabits();
  }

  // D E L E T E - delete habit
  Future<void> deleteHabit(int id) async {
    // Perfome the delete
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    // re-read from db
    readHabits();
  }
}
