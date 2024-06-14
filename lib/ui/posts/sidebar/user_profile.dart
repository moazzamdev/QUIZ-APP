import 'dart:io';
import 'package:asaf/ui/posts/home_screen.dart';
import 'package:asaf/ui/posts/sidebar/update_profile.dart';
import 'package:asaf/utils/utilities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

// ignore: must_be_immutable
class UserProfile extends StatefulWidget {
  String message;
  String gender;
  String imageurl;
  String phoneno;
  
  String dateOfBirth;
  String email;
  UserProfile(
      {super.key,
      required this.message,
      required this.gender,
      required this.dateOfBirth,
      required this.phoneno,
      required this.email,
      required this.imageurl,
      });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
  }

  String success = '';
  File? _image;
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void _showImagePreviewDialog(File imageFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image Preview'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(imageFile),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Center(
                        child: SpinKitChasingDots(
                          color: Colors.blue,
                          size: 50.0,
                        ),
                      );
                    },
                  );

// Create a delay of 2 seconds
                  Future.delayed(const Duration(seconds: 3), () {
                    // Dismiss the dialog after the delay
                    Navigator.pop(context);
                  });

                  _uploadImageAndSaveLink(imageFile);
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Show the image preview dialog
      _showImagePreviewDialog(_image!);
    } else {
      Utils().toastMessage('No image selected');
    }
  }

  Future<void> _uploadImageAndSaveLink(File imageFile) async {
    final user = _auth.currentUser;
    final userId = user?.uid;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: SpinKitChasingDots(
            color: Colors.blue,
            size: 50.0,
          ),
        );
      },
    );

    // Upload the image to Firestore Storage
    final storageRef =
        _storage.ref().child('images/$userId/${DateTime.now().toString()}');
    await storageRef.putFile(imageFile);

    // Get the download URL of the uploaded image
    final imageUrl = await storageRef.getDownloadURL();

    // Update the user's database entry with the image URL
    await _firestore.collection('users').doc(userId).update({
      'gprofileImageUrl': imageUrl,
    });

    Navigator.pop(context); // Close the spinner dialog

    _showSuccessDialog(context); // Show the success dialog
  }

  void _showSuccessDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.success,
      title: 'Profile Updated',
      desc: 'Your profile has been updated successfuly',
      btnOkOnPress: () {
        Navigator.pop(context); // Close the dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      },
    )..show();
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
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()),
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
                'Profile',
                style: TextStyle(
                    letterSpacing: 1, fontFamily: 'Open_Sans', fontSize: 22),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 130),
              child: Column(
                children: [
                  /// -- IMAGE
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: buildAvatar(
                            widget.imageurl,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            _pickAndUploadImage();
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.black,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(widget.message,
                      style: const TextStyle(
                          fontFamily: 'Open_Sans', fontSize: 20)),

                  const SizedBox(height: 20),

                  /// -- BUTTON
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    UpdateProfile(
                              initialMessage: widget.message,
                              initialGender: widget.gender,
                              initialPhoneno: widget.phoneno,
                              initialDateOfBirth: widget.dateOfBirth,
                              
                            ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var slideAnimation = Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves
                                      .easeOutCubic, // You can adjust the curve for desired easing
                                ),
                              );

                              return SlideTransition(
                                position: slideAnimation,
                                child: child,
                              );
                            },
                            transitionDuration: const Duration(
                                milliseconds:
                                    800), // Adjust the duration for a slower animation
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          side: BorderSide.none,
                          shape: const StadiumBorder()),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Personal Information',
                    style:
                        TextStyle(fontFamily: 'Open_Sans', color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Hero(
                    tag: 'nameHero',
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            color: Colors.grey,
                            width: 2), // Add the border properties
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.mail,
                        ),
                        title: Text(widget.email),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Hero(
                    tag: 'phoneHero',
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            color: Colors.grey,
                            width: 2), // Add the border properties
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.phone,
                        ),
                        title: Text(widget.phoneno),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Hero(
                    tag: 'genderHero',
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.grey, width: 2),
                      ),
                      child: ListTile(
                        leading: (widget.gender.trim().toLowerCase() ==
                                    'male' ||
                                widget.gender == 'Male')
                            ? const Icon(Icons.male)
                            : (widget.gender.trim().toLowerCase() == 'female' ||
                                    widget.gender == 'Female')
                                ? const Icon(Icons.female)
                                : (widget.gender == 'other')
                                    ? const Icon(Icons.transgender)
                                    : (widget.gender == 'Gender')
                                        ? const Icon(Icons.group)
                                        : null, // Set to null if none of the conditions are met
                        title: Text(widget.gender),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  Hero(
                    tag: 'dobHero',
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            color: Colors.grey,
                            width: 2), // Add the border properties
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.date_range,
                        ),
                        title: Text(widget.dateOfBirth),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

Widget buildAvatar(
  String imageurl,
) {
  if (imageurl != 'null') {
    return Image(
      image:
          CachedNetworkImageProvider(imageurl), // Replace with the correct URL
      fit: BoxFit.cover, // Adjust the fit mode as needed
    );
  } else {
    // Show CircleAvatar with icon
    return const Image(
      image: AssetImage('assets/usericon.jpg'), // Replace with the correct URL
      fit: BoxFit.cover, // Adjust the fit mode as needed
    );
  }
}
