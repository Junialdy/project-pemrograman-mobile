import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habittute/components/my_drawer.dart';
import 'package:habittute/components/my_habit_tile.dart';
import 'package:habittute/components/my_heat_map.dart';
import 'package:habittute/database/habit_database.dart';
import 'package:habittute/models/habit.dart';
import 'package:habittute/util/habit_util.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

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

  void showAnimatedDialog(BuildContext context, Widget dialogContent) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: dialogContent,
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: child,
          ),
        );
      },
    );
  }

  // create new habit
  void createNewHabit() {
    showAnimatedDialog(
      context,
      AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Create a new habit"),
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () {
              //get the new habit name
              String newHabitName = textController.text;

              // save to db
              context.read<HabitDatabase>().addHabit(newHabitName);

              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },
            child: const Text('Save'),
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
        ],
      ),
    );
  }

  // check habit on & off
  void checkHabitOnOff(bool? value, Habit habit) {
    // update habit completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitsCompletion(habit.id, value);
    }
  }

  // edit habit
  void editHabitBox(Habit habit) {
    // set the controller's text to the habit's current name
    textController.text = habit.name;

    showAnimatedDialog(
      context,
      AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () {
              //get the new habit name
              String newHabitName = textController.text;

              // save to db
              context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, newHabitName);

              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },
            child: const Text('Save'),
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
        ],
      ),
    );
  }

  // delete habit
  void deleteHabitBox(Habit habit) {
    showAnimatedDialog(
      context,
      AlertDialog(
        title: const Text("Are you sure you want to delete?"),
        actions: [
          // delete button
          MaterialButton(
            onPressed: () {
              // save to db
              context.read<HabitDatabase>().deleteHabit(habit.id);

              // pop box
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(
          Icons.add,
          color: Colors.black87,
        ),
      ),
      body: ListView(
        children: [
          //HEATMAP
          _buildHeatMap(),

          //HABIT LIST
          _buildHabitList(),
        ],
      ),
    );
  }

  //build heatmap
  Widget _buildHeatMap() {
    //habit database
    final habitDatabase = context.watch<HabitDatabase>();

    //current habbits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    //return heatmap ui
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        //once data is available, build heatmap
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepareHeatMapDataset(currentHabits),
          );
        }
        //handle case when no data is return
        else {
          return Container();
        }
      },
    );
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();

    List<Habit> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // get each individual habit
        final habit = currentHabits[index];

        // check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        // return habit tile UI
        return MyHabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
