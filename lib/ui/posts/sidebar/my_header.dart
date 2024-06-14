import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget myHeaderDrawer(String message, String imageurl) {
  return Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/abcd.jpg'),
        fit: BoxFit.fitHeight,
      ),
    ),
    padding: const EdgeInsets.symmetric(vertical: 50),
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
                child: buildAvatar(imageurl),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),
        Text(message,
            style: const TextStyle(
              fontFamily: 'Open_Sans',
              fontSize: 18,
            )),

        const SizedBox(height: 20),

        /// -- BUTTON
        SizedBox(
          width: 170,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide.none,
                shape: const StadiumBorder()),
            child: const Text('Edit Profile',
                style: TextStyle(color: Colors.black)),
          ),
        ),
        const SizedBox(height: 0),
        const Divider(),

        /// -- MENU
      ],
    ),
  );
}

Widget buildAvatar(String imageurl) {
  if (imageurl != 'null') {
    // Show CircleAvatar with background image
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
