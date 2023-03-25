import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box('Habit_Database');

class HabitDatabase {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  void createDefaultData() {
    todaysHabitList = [
      ['Morning Routine', false],
      ['Read a Book', false],
    ];
    _myBox.put('START_DATE', todaysDateFormatted());
  }

  void loadData() {
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = _myBox.get('CURRENT_HABIT_LIST', defaultValue: []).cast();

      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    } else {
      todaysHabitList = _myBox.get(todaysDateFormatted(), defaultValue: []).cast();
    }
  }

  void updateDatabase() {
    _myBox.put(todaysDateFormatted(), todaysHabitList);

    _myBox.put('CURRENT_HABIT_LIST', todaysHabitList);

    calculateHabitPercentage();

    loadHeatMap();
  }

  void calculateHabitPercentage() {
    int countCompleted = 0;
    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] == true) {
        countCompleted++;
      }
    }
    String percent = todaysHabitList.isEmpty
        ? (countCompleted / todaysHabitList.length).toStringAsFixed(1)
        : '0.0';
//key: 'PERCENTAGE_SUMMARY_yyyymmdd'
    //value: string of 1dp number btw 0.0-1.0 inclusive
    _myBox.put('PERCENTAGE_SUMMARY_${todaysDateFormatted()}', percent);
  }

  void loadHeatMap() {
    final startDate = createDateTimeObject(_myBox.get('START_DATE'));

    //count the number of days to load
    final daysInBetween = DateTime.now().difference(startDate).inDays;

    heatMapDataSet = {};

    //go from start date to today and add each percentage to the dataset
    //'PERCENTAGE_SUMMARY_yyyymmdd' will be the key in the dataset
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd =
          convertDateTimeToString(startDate.add(Duration(days: i)));

      double strengthAsPercent =
            double.parse(_myBox.get('PERCENTAGE_SUMMARY_$yyyymmdd') ?? '0.0');


      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt()
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
