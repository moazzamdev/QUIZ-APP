import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package for formatting dates

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> notificationList = [];

  @override
  void initState() {
    super.initState();
    fetchNotificationsFromFirestore();
  }

  Future<void> fetchNotificationsFromFirestore() async {
    final CollectionReference notifications =
        FirebaseFirestore.instance.collection('notifications');

    try {
      final QuerySnapshot snapshot = await notifications.get();

      setState(() {
        notificationList.addAll(
            snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>));
      });

      print('Notifications fetched from Firestore');
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor:
          Color.fromARGB(255, 105, 160, 205), // Replace with desired color
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(150),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 105, 160, 205),
          elevation: 8,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.arrow_circle_left_rounded,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Notifications',
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Open_Sans',
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: notificationList.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey.shade400,
          thickness: 1,
          endIndent: 10,
          indent: 10,
        ),
        itemBuilder: (context, index) {
          final notificationData = notificationList[index];
          final title = notificationData['title'] ?? 'No Title';
          final body = notificationData['body'] ?? 'No Body';
          final timestamp =
              notificationData['timestamp']?.toDate() ?? DateTime.now();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListTile(
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    body,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, yyyy - hh:mm a').format(timestamp),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
