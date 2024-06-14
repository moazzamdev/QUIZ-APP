import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TermsOfUseScreen extends StatelessWidget {
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
                'Terms of Use',
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
                    'Thanks for Downloading Our App',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Open_Sans',
                        color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'By using our app, you agree to abide by these terms of use...',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '1. Acceptance of Terms',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'If you’re using the app outside of an area with Wi-Fi, you should remember that your terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app.',
                  ),
                  SizedBox(height: 20),
                  Text(
                    '2. User Conduct',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy, or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages, or make derivative versions. The app itself, and all the trade marks, copyright, database rights and other intellectual property rights related to it, still belong to ASAF.',
                  ),
                  SizedBox(height: 20),
                  Text(
                    '3. Data',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'ASAF stores and processes personal data that you have provided to us, in order to provide our service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that ASAF won’t work properly or at all.',
                  ),
                  SizedBox(height: 20),
                  Text(
                    '3. Functionalities',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'You should be aware that there are certain things that ASAF will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi, or provided by your mobile network provider, but ASAF cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left.',
                  ),
                  // Add more sections and content as needed
                ],
              ),
            ),
          ),
        ));
  }
}
