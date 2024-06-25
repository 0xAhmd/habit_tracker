import 'package:flutter/material.dart';
import 'package:habits/components/my_drawer.dart';
import 'package:habits/db/habit_database.dart';
import 'package:habits/models/habit.dart';
import 'package:habits/utilities/habit_utilit.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HabitDataBase>(context, listen: false).readHabit();
    });
  }

  void createNewHabit(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: "Insert a New Habit",
            ),
          ),
          actions: [
            // add button
            MaterialButton(
              onPressed: () {
                String newHabit = textController.text;
                Provider.of<HabitDataBase>(context, listen: false)
                    .addHabit(newHabit);
                Navigator.pop(context);
                textController.clear();
              },
              child: const Text("Save"),
            ),

            // cancel button
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                textController.clear();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewHabit(context),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: _buildHabitList(),
    );
  }

  Widget _buildHabitList() {
    // habit db
    final habitDataBase = context.watch<HabitDataBase>();
    // current habit
    List<Habit> currentHabits = habitDataBase.currentHabits;
    // return list
    return ListView.builder(
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        // get each habit

        final habit = currentHabits[index];
        //check if completed today

        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
        return ListTile(
          title: Text(habit.name),
        );
        //return title
      },
    );
  }
}
