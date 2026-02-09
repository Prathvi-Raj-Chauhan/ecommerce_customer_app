import 'package:ecommerce_customer/MODELS/notification.dart';
import 'package:ecommerce_customer/PROVIDER/NotificationProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotificationHistory extends StatefulWidget {
  const NotificationHistory({super.key});

  @override
  State<NotificationHistory> createState() => _NotificationHistoryState();
}

class _NotificationHistoryState extends State<NotificationHistory> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  Widget notificationList() {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, _) {

        var notificationCount = notificationProvider.logs.length;
        if (notificationProvider.logs.isEmpty) {
          return const Center(
            child: Text(
              "No Notifications yet !",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return Expanded(
        
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(12),
            itemCount: notificationProvider.logs.length,
            itemBuilder: (context, index) {
              final item = notificationProvider.logs[index];
              return notificationTile(item);
            },
          ),
        );
      },
    );
  }

  Widget notificationTile(MyNotification notification) {
    return ListTile(
      
      leading: Icon(Icons.notifications_active_outlined, color: Colors.grey,),
      title: Text(
        notification.title,
        style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        notification.body,
        style: GoogleFonts.nunito(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
      isThreeLine: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Center(
              child: Text(
                'Notifications',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            notificationList()
          ],
        ),
      ),
    );
  }

}
