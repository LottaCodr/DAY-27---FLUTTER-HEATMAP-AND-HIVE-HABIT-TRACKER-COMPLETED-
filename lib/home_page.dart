import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/my_fab.dart';
import 'package:habit_tracker/components/alert_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //bool isHabitCompleted = false;

  //data structure for today's list
  List todaysHabitList = [
    //[habitName, habitCompleted
    ['Morning Routine', false],
    ['Read A Book', false],
    ['30 days flutter', false],
  ];

  //when checkbox is tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      todaysHabitList[index][1] = value;
    });
  }

  final _newHabitNameController = TextEditingController();

  void createNewHabit() {
    //showing alert dialog for user to enter the new habit details
    showDialog(
        context: context,
        builder: (context) {
          return AlertBox(
            controller: _newHabitNameController,
            onSave: saveHabit,
            onCancel: cancelDialogBox,
            hintText: 'Enter a New Habit',
          );
        });
  }

  void saveHabit() {
    //add the new habit
    setState(() {
      todaysHabitList.add([_newHabitNameController.text, false]);
    });
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  void cancelDialogBox() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  void openHabitSettings(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertBox(
              controller: _newHabitNameController,
              onSave: () => saveExistingHabit(index),
              onCancel: cancelDialogBox,
            hintText: todaysHabitList[index][0],);
        });
  }

  //save existing habit with a new name
  void saveExistingHabit (int index) {
    setState(() {
      todaysHabitList[index][0] = _newHabitNameController.text;
    });
    Navigator.of(context).pop();
    _newHabitNameController.clear();
  }

  void deleteHabit(int index) {
setState(() {
  todaysHabitList.removeAt(index);
});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFAB(
        onPressed: createNewHabit,
      ),
      body: ListView.builder(
        itemCount: todaysHabitList.length,
        itemBuilder: (context, index) {
          return HabitTiles(
            habitName: todaysHabitList[index][0],
            habitCompleted: todaysHabitList[index][1],
            onChanged: (value) => checkBoxTapped(value, index),
            settingsTapped: (context) => openHabitSettings(index),
            deleteTapped: (BuildContext) => deleteHabit(index),
          );
        },
      ),
    );
  }
}
