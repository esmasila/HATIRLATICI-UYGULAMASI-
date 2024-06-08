import 'package:flutter/material.dart';
import 'package:flutter_application_1/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ReminderProvider with ChangeNotifier {
  List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  ReminderProvider() {
    loadReminders();
  }

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    saveReminders();
    notifyListeners();
  }

  void removeReminder(Reminder reminder) {
    _reminders.remove(reminder);
    saveReminders();
    notifyListeners();
  }

  void saveReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonReminders = _reminders.map((reminder) => json.encode(reminder.toJson())).toList();
    prefs.setStringList('reminders', jsonReminders);
  }

  void loadReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonReminders = prefs.getStringList('reminders');
    if (jsonReminders != null) {
      _reminders = jsonReminders.map((jsonReminder) => Reminder.fromJson(json.decode(jsonReminder))).toList();
      notifyListeners();
    }
  }
}


