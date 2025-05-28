import 'package:isis3510_team32_flutter/models/data_structures/lru_cache.dart';

class CalendarRepository {
  CalendarRepository._internal();

  static final CalendarRepository _instance = CalendarRepository._internal();

  final LRUCache<String, DateTime> _calendarCache = LRUCache(maxSize: 20);

  factory CalendarRepository() {
    return _instance;
  }

  DateTime getLastDate(){
    if(!_calendarCache.containsKey('lastDate')){
      _calendarCache.put('lastDate', DateTime.now());
    }
    return _calendarCache.get('lastDate')!;
  }

  void setLastDate(DateTime date){
    _calendarCache.put('lastDate', date);
  }



}