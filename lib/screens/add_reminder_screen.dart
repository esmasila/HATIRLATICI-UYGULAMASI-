import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models.dart';
import '../providers.dart';
import '../main.dart'; 

class AddReminderScreen extends StatefulWidget {
  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _titleController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hatırlatıcı Ekle'),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),  
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Başlık'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Zaman: ${_selectedDateTime.toString()}'),
                Spacer(),
                ElevatedButton(
                  onPressed: _pickDateTime,
                  child: Text('Tarih Seç'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0), backgroundColor: const Color.fromARGB(255, 255, 255, 255), 
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addReminder,
              child: Text('Hatırlatıcı Ekle'),
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 0, 0, 0), backgroundColor: const Color.fromARGB(255, 255, 255, 255), 
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  void _addReminder() {
    if (_titleController.text.isEmpty) {
      return;
    }

    final reminder = Reminder(
      title: _titleController.text,
      dateTime: _selectedDateTime,
    );

    Provider.of<ReminderProvider>(context, listen: false).addReminder(reminder);
    _scheduleNotification(reminder);
    Navigator.of(context).pop();
  }

  void _scheduleNotification(Reminder reminder) async {
    var scheduledNotificationDateTime = reminder.dateTime;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'reminder_channel', 
      'Reminder Notifications',
      channelDescription: 'Channel for Reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Hatırlatıcı: ${reminder.title}',
      'Hatırlatıcı zamanı geldi.',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );
  }
}
