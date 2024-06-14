import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrivacyPolicyScreen extends StatelessWidget {
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
                'Privacy Policy',
                style: TextStyle(
                    letterSpacing: 1, fontFamily: 'Open_Sans', fontSize: 22),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 130),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Privacy Policy',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Open_Sans',
                        color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your privacy is important to us...',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '1. Information Collection',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Personal data are information about your personal or material circumstances, e.g. name, birth date, email address, telephone number. ASAF utilizes the personal data that you have made available as required for the creation, execution or termination of a contractual or similar obligation with you, specifically for authentication, registration and use of the ASAF Quiz App. For the use of personal data for other purposes (specifically marketing purposes), ASAF will always obtain your explicit consent before the collection of data.  ",
                  ),
                  SizedBox(height: 20),
                  Text(
                    '2. Device Features Authorization',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'The ASAF Quiz App solely accesses those services of your smartphone or tablet (device) that are required for using the ASAF Quiz App and necessary for the described purposes.\nBefore accessing the respective services the following access authorizations will be presented to you:\nAccess to file system of your device for changing your profile picture.  ',
                  ),
                  SizedBox(height: 20),
                  Text(
                    '3. Changing Your Personal Settings',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'At any time you can withdraw or re-grant the access authorizations that have been granted in your personal settings of your device (under “Privacy”). If you withdraw individual access authorizations of your ASAF Quiz App, this may lead to restricted function.',
                  ),
                  SizedBox(height: 20),
                  Text(
                    '4. Push Notifications',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'If you have agreed to receive push notifications, we will deliver push notifications with reminders or changes made in app to your device. You will see these push notifications on your lock screen as an active window while using your device and as a symbol on the app icon on your device.\n\nYou can stop receiving push notifications at any time by turning them off in the personal settings of your device.',
                  ),
                  SizedBox(height: 20),
                  Text(
                    '5. How Long Your Data is Stored Locally',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'The data saved locally on your device while using the ASAF Quiz App will only be saved until you delete it or remove the ASAF Quiz App from your device. If you decide to delete the ASAF Quiz App, we will ask you once again if you agree to permanently delete all data associated with the ASAF Quiz App.',
                  ),
                  // Add more sections and content as needed
                ],
              ),
            ),
          ),
        ));
  }
}
