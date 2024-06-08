import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers.dart';
import 'package:flutter_application_1/screens/add_reminder_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hatırlatıcı'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/god.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Consumer<ReminderProvider>(
            builder: (context, reminderProvider, child) {
              return ListView.builder(
                itemCount: reminderProvider.reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminderProvider.reminders[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          reminder.title,
                          style:  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          reminder.dateTime.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            reminderProvider.removeReminder(reminder);
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddReminderScreen(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
