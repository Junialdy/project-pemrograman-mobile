import 'package:isar/isar.dart';

//run cmd to generate file: dart run bulid_runner build
part 'habit.g.dart';

@Collection()
class Habit {
  //habit id
  Id id = Isar.autoIncrement;

  //habit name
  late String name;

  //completed days
  List<DateTime> completedDays = [
    //DateTime(year, month, year),
    //DateTime(2024, 11, 6),
    //DateTime(2024, 11, 7),
  ];
}
