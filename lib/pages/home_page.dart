import 'package:flutter/material.dart';
import 'package:habits/components/my_drawer.dart';
import 'package:habits/components/my_habit_tile.dart';
import 'package:habits/components/my_heatmap.dart';
import 'package:habits/db/habit_database.dart';
import 'package:habits/models/habit.dart';
import 'package:habits/utilities/habit_utilit.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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

  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      Provider.of<HabitDataBase>(context, listen: false)
          .updatedHabitCompletion(habit.id, value);
    }
  }

  void editHabitBox(Habit habit) {
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String newHabit = textController.text;
              Provider.of<HabitDataBase>(context, listen: false)
                  .updateHabitName(habit.id, newHabit);
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Save"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("you sure you want to Delete this Habit?"),
        actions: [
          MaterialButton(
            onPressed: () {
              Provider.of<HabitDataBase>(context, listen: false).deleteHabit(
                habit.id,
              );
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewHabit(context),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Consumer<HabitDataBase>(
        builder: (context, habitDataBase, child) {
          List<Habit> currentHabits = habitDataBase.currentHabits;
          return currentHabits.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: 100,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'No Habits here, Please Add some Habits',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  children: [
                    _buildHeatMap(),
                    _buildHabitList(),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildHeatMap() {
    final habitDataBase = context.watch<HabitDataBase>();
    List<Habit> currentHabits = habitDataBase.currentHabits;

    return FutureBuilder<DateTime?>(
        future: habitDataBase.getFirstLaunchDate(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyHeatmap(
              startDate: snapshot.data!,
              datasets: prepareHabitMapDataset(currentHabits),
            );
          } else {
            return Container();
          }
        });
  }

  Widget _buildHabitList() {
    final habitDataBase = Provider.of<HabitDataBase>(context);
    List<Habit> currentHabits = habitDataBase.currentHabits;

    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
        return MyHabitTile(
          isCompleted: isCompletedToday,
          text: habit.name,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
