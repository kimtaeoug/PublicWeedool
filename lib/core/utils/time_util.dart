import 'package:intl/intl.dart';

class TimeUtil{

  static String convertDayOfWeekKorean(DateTime input){
    switch(DateFormat('EEEE').format(input)){
      case 'Monday':
        return '월';
      case 'Tuesday':
        return '화';
      case 'Wednesday':
        return '수';
      case 'Thursday':
        return '목';
      case 'Friday':
        return '금';
      case 'Saturday':
        return '토';
      case 'Sunday':
        return '일';
      default:
        return '';
    }
  }
  static String convertEnglishToKorean(String input){
    switch(input){
      case 'Monday':
        return '월';
      case 'Tuesday':
        return '화';
      case 'Wednesday':
        return '수';
      case 'Thursday':
        return '목';
      case 'Friday':
        return '금';
      case 'Saturday':
        return '토';
      case 'Sunday':
        return '일';
      default:
        return '';
    }
  }

  static String convertDayOfWeek(String day){
    if(day.startsWith('Mo')){
      return '월';
    }else if(day.startsWith('Tu')){
      return '화';
    }else if(day.startsWith('We')){
      return '수';
    }else if(day.startsWith('Th')){
      return '목';
    }else if(day.startsWith('Fri')){
      return '금';
    }else if(day.startsWith('Sa')){
      return '토';
    }else{
      return '일';
    }
  }


  static String convertDateToTime(String? input){
    if(input != null){
      return DateFormat('HH:mm').format(DateTime.parse(input));
    }else{
      return '';
    }
  }

  static String convertDateToDetailKorean(DateTime input){
    int month = input.month;
    int day = input.day;
    return '$month월$day일 ${convertDayOfWeekKorean(input)}요일 기록';
  }
}