import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habittute/components/my_drawer.dart';
import 'package:habittute/components/my_habit_tile.dart';
import 'package:habittute/database/habit_database.dart';
import 'package:habittute/models/habit.dart';
import 'package:habittute/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    super.initState();
  }

  final TextEditingController textController = TextEditingController();

  // create new habit
  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                content: TextField(
                  controller: textController,
                  decoration:
                      const InputDecoration(hintText: "Create a new habit"),
                ),
                actions: [
                  // save button
                  MaterialButton(
                    onPressed: () {
                      //get the new habit name
                      String newHabitName = textController.text;

                      // save to db
                      // context.read<HabitDatabase>().toString(newHabitName);

                      // pop box
                      Navigator.pop(context);

                      // clear controller
                      textController.clear();
                    },
                    child: const Text('save'),
                  ),

                  // cancel button
                  MaterialButton(
                    onPressed: () {
                      // pop box
                      Navigator.pop(context);

                      // clear controller
                      textController.clear();
                    },
                    child: const Text('Cancel'),
                  )
                ]));
  }

  // check habit on & off
  void checkHabitOnOff(bool? value) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();

    List<Habit> currentHabits = habitDatabase.currentHabit;

    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // get each individual habit
        final habit = currentHabits[index];

        // check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.complatedDays);

        // return habit tile UI
        return MyHabitTile(
            text: habit.name,
            isCompleted: isCompletedToday,
            onChanged: (value) => checkHabitOnOff(value));
      },
    );
  }
}
