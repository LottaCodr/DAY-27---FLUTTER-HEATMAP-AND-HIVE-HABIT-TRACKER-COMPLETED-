//return todays date formatted as yyyymmdd
String todaysDateFormatted(){
//today
var dateTimeObject = DateTime.now();

//year in format yyyy
  String year = dateTimeObject.year.toString();

  //month in format mm
  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  //day in the format dd
  String day = dateTimeObject.day.toString();
  if (day.length == 1){
    day = '0$day';
  }

  //final format
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}


//converts string yyyymmdd to DataTime object
DateTime createDateTimeObject(String yyyymmdd){

  int yyyy = int.parse(yyyymmdd.substring(0,4));
  int mm = int.parse(yyyymmdd.substring(4,6));
  int dd = int.parse(yyyymmdd.substring(6,8));

  DateTime dateTimeObject = DateTime(yyyy, mm, dd);
  return dateTimeObject;
}

//convert DateTime Object to String yyyymmdd
String convertDateTimeToString(DateTime dateTime) {
//for year format
  String year = dateTime.year.toString();

  //month in format mm
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
  String day = dateTime.day.toString();
  if(day.length ==1){
    day = '0$day';
  }

  String yyyymmdd = year + month + day;
  return yyyymmdd;
}