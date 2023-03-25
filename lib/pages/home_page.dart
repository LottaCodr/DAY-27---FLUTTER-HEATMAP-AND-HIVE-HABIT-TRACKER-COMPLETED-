import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/month_summary.dart';
import 'package:habit_tracker/components/my_fab.dart';
import 'package:habit_tracker/components/alert_box.dart';
import 'package:habit_tracker/data/habit_database.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box('Habit_Database');

  @override
  void initState() {
    //create a default data after checking if
    // its the first time ever to open the app
    if (_myBox.get('CURRENT_HABIT_LIST') == null) {
      db.createDefaultData();
    }

    //if data already exists,then
    else {
      db.loadData();
    }

    db.updateDatabase() ;
    super.initState();
  }

  //when checkbox is tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();
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
            hintText: 'Enter a New Habit...',
          );
        });
    // db.updateDatabase();

  }

  void saveHabit() {
    //add the new habit
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });
    _newHabitNameController.clear();
    Navigator.of(context).pop();
    db.updateDatabase();
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
            hintText: db.todaysHabitList[index][0],
          );
        });
  }

  //save existing habit with a new name
  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    Navigator.of(context).pop();
    _newHabitNameController.clear();
    db.updateDatabase();

  }

  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFAB(
        onPressed: createNewHabit,
      ),
      body: ListView(
        children: [

          //monthly summary heatmap
          MonthlySummary(
              datasets: db.heatMapDataSet,
              startDate: _myBox.get('START_DATE')) ,

          //list of habits
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.todaysHabitList.length,
            itemBuilder: (context, index) {
              return HabitTiles(
                habitName: db.todaysHabitList[index][0],
                habitCompleted: db.todaysHabitList[index][1],
                onChanged: (value) => checkBoxTapped(value, index),
                settingsTapped: (context) => openHabitSettings(index),
                deleteTapped: (context) => deleteHabit(index),
              );
            },
          ),
        ],
      )
    );
  }
}
