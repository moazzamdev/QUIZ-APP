import 'package:asaf/ui/posts/sidebar/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';

class SendNotification extends StatefulWidget {
  const SendNotification({super.key});

  @override
  State<SendNotification> createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  late TextEditingController _textTitle;
  late TextEditingController _textBody;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _textTitle = TextEditingController();
    _textBody = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(
          255, 105, 160, 205), // You can replace this with your desired color
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(150), // Adjust the radius as needed
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 105, 160, 205),
            elevation: 8,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(
                  context,
                );
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
              'Send Notifications',
              style: TextStyle(
                  letterSpacing: 1, fontFamily: 'Open_Sans', fontSize: 22),
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Material(
                              elevation: 8,
                              shadowColor: Colors.black87,
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                obscureText: false,
                                controller: _textTitle,
                                textAlignVertical: TextAlignVertical.bottom,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Title',
                                  prefixIcon: const Icon(Ionicons.text),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter title';
                                  }

                                  return null;
                                },
                              ),
                            ),

                            SizedBox(height: 20),
                            // Unique tag for the email field
                            Material(
                              elevation: 8,
                              shadowColor: Colors.black87,
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                obscureText: false,
                                controller: _textBody,
                                textAlignVertical: TextAlignVertical.bottom,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Body',
                                  prefixIcon: const Icon(Ionicons.body),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter body';
                                  }

                                  return null;
                                },
                              ),
                            ),

                            SizedBox(height: 20),
                            Center(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    pushNotificationsAllUsers(
                                      title: _textTitle.text,
                                      body: _textBody.text,
                                    );

                                    storeNotificationInFirestore(
                                        _textTitle.text, _textBody.text);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      elevation: 12,
                                      shadowColor: Colors.black87,
                                      side: BorderSide.none,
                                      shape: const StadiumBorder()),
                                  child: const Text(
                                    'Send',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> pushNotificationsAllUsers({
  required String title,
  required String body,
}) async {
  String dataNotifications = '{ '
      ' "to" : "/topics/quizNotification" , ' // Specify the topic to send notifications to all devices/users
      ' "notification" : {'
      ' "title":"$title" , '
      ' "body":"$body" '
      ' } '
      ' } ';

  var response = await http.post(
    Uri.parse(Constants.BASE_URL),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key= ${Constants.KEY_SERVER}',
    },
    body: dataNotifications,
  );
  print(response.body.toString());
  return true;
}

Future<void> storeNotificationInFirestore(String title, String body) async {
  final CollectionReference notifications =
      FirebaseFirestore.instance.collection('notifications');

  try {
    await notifications.add({
      'title': title,
      'body': body,
      'timestamp':
          FieldValue.serverTimestamp(), // To store the current timestamp
    });

    print('Notification stored in Firestore');
  } catch (e) {
    print('Error storing notification: $e');
  }
}
