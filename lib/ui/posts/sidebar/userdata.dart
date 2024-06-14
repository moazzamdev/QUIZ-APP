import 'package:asaf/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  List<UserInfo> userInfos = [];
  Map<String, bool> copyStatus = {}; // To keep track of copied items

  @override
  void initState() {
    super.initState();
    fetchAllUserData();
  }

  Future<void> fetchAllUserData() async {
    try {
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      List<UserInfo> usersData = userSnapshot.docs.map((doc) {
        String email = doc.get('bemail') ?? 'Email';
        String userName = doc.get('aname') ?? 'Username';
        String phoneNumber = doc.get('cphoneno') ?? 'Phone Number';
        String userId = doc.id;
        String dob = doc.get('fdateofbirth') ?? 'Date of Birth';
        String gender = doc.get('dgender') ?? 'Gender';
        DateTime signUpDate = doc.get('signupdate')?.toDate();
        String date = signUpDate != null
            ? signUpDate
                .toString() // This will give you a string representation of the DateTime
            : 'Signup Date';

        return UserInfo(
            userId, email, userName, phoneNumber, dob, gender, date);
      }).toList();

      setState(() {
        userInfos = usersData;
        // Initialize copyStatus for each user as false initially
        copyStatus = Map.fromIterable(userInfos,
            key: (e) => e.userId, value: (_) => false);
      });
    } catch (e) {
      print("Error fetching user data: $e");
      // Handle the error here, such as displaying an error message to the user.
    }
  }

  // Function to copy text to clipboard
  void copyToClipboard(String email, String userName, String userId,
      String phoneNumber, String gender, String date) {
    Clipboard.setData(ClipboardData(
        text: '$email\n$userName\n$userId\n$phoneNumber\n$gender\n$date'));
    setState(() {
      copyStatus[userId] = true; // Update the copy status to true
    });
  }

  @override
  Widget build(BuildContext context) {
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
              'Settings',
              style: TextStyle(
                  letterSpacing: 1, fontFamily: 'Open_Sans', fontSize: 22),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 120),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (var userInfo in userInfos)
                  Card(
                    elevation: 2,
                    child: ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${userInfo.email}'),
                          IconButton(
                            icon: Icon(
                              (copyStatus[userInfo.userId] ?? false)
                                  ? Icons.done
                                  : Icons.content_copy,
                              color: (copyStatus[userInfo.userId] ?? false)
                                  ? Colors.green
                                  : Colors.blue,
                            ),
                            onPressed: () {
                              copyToClipboard(
                                  userInfo.email,
                                  userInfo.userName,
                                  userInfo.userId,
                                  userInfo.phoneNumber,
                                  userInfo.gender,
                                  userInfo.date);
                              Utils().toastMessage('Copied to Clipboard');
                            },
                          ),
                        ],
                      ),
                      subtitle: Text('${userInfo.userName}'),
                      children: [
                        Text('${userInfo.phoneNumber}'),
                        Text('${userInfo.date}'),
                        Text('${userInfo.gender}'),
                        Text('${userInfo.userId}'),
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

class UserInfo {
  final String userId;
  final String email;
  final String userName;
  final String phoneNumber;
  final String dob;
  final String gender;
  final String date;

  UserInfo(this.userId, this.email, this.userName, this.phoneNumber, this.dob,
      this.gender, this.date);
}
