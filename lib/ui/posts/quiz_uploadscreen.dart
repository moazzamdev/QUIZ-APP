import 'package:asaf/ui/posts/home_screen.dart';
import 'package:asaf/utils/utilities.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UploadCsvScreen(),
    );
  }
}

class UploadCsvScreen extends StatefulWidget {
  @override
  _UploadCsvScreenState createState() => _UploadCsvScreenState();
}

class _UploadCsvScreenState extends State<UploadCsvScreen> {
  final TextEditingController collectionNameController =
      TextEditingController();
  bool isUploading = false; // Track whether the uploading process is ongoing
  bool uploadSuccess = false; // Track whether the upload was successful
  List<File> selectedCsvFiles = [];
  double uploadProgress = 0.0; // Track upload progress
  int currentFileIndex = 0;

  void uploadQuestionsFromCsv(String collectionName, File csvFile) async {
    setState(() {
      isUploading = true;
      uploadSuccess = false;
      uploadProgress = 0.0; // Initialize progress to 0
    });

    if (csvFile != null) {
      try {
        // Read the CSV file using the 'dart:io' File API
        List<List<dynamic>> csvData = CsvToListConverter().convert(
          await csvFile.readAsString(encoding: latin1), // Use latin1 encoding
        );

        int totalRows = csvData.length - 1; // Total rows excluding header

        for (var i = 1; i < csvData.length; i++) {
          var row = csvData[i];
          dynamic questionText = row[0];
          dynamic optionsString = row[1];
          List<dynamic> options = optionsString.split(',');
          dynamic correctOption = row[2];

          // Upload question to Firestore
          await FirebaseFirestore.instance.collection(collectionName).add({
            'questionText': questionText,
            'options': options,
            'correctOption': correctOption,
          });

          // Calculate and update upload progress
          double progress = (i / totalRows);
          setState(() {
            uploadProgress = progress;
          });
        }

        setState(() {
          isUploading = false;
          uploadSuccess = true;
          uploadProgress = 1.0; // Set progress to 100% after upload is complete
        });
      } catch (e) {
        print('Error uploading CSV file: $e');
        setState(() {
          isUploading = false;
          uploadSuccess = false;
        });
      }
    }
  }

  Future<void> uploadSelectedFiles() async {
    if (selectedCsvFiles.isNotEmpty) {
      for (var file in selectedCsvFiles) {
        String collectionName = file.path.split('/').last.split('.').first;
        collectionNameController.text = collectionName;

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

        await Future.delayed(const Duration(seconds: 3), () {
          // Dismiss the dialog after the delay
          Navigator.pop(context);
        });

        // Upload questions for the current file
        uploadQuestionsFromCsv(collectionName, file);

        // Move to the next file
        setState(() {
          currentFileIndex++;
        });
      }

      // Reset current file index for future use
      setState(() {
        currentFileIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(
          255, 105, 160, 205), // You can replace this with your desired color
    ));
    return MaterialApp(
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
              'Upload Quiz',
              style: TextStyle(
                  letterSpacing: 1, fontFamily: 'Open_Sans', fontSize: 22),
            ),
          ),
        ),
        body: Center(
          child: Container(
            alignment: Alignment.center, // Set desired alignment
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'CSV Upload ', // Your desired page heading
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Open_Sans',
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 60),
                Material(
                  elevation: 8,
                  shadowColor: Colors.black87,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  child: TextFormField(
                    obscureText: false,
                    controller: collectionNameController,
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Collection Name',
                      prefixIcon: const Icon(Icons.collections),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Collection Name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Show the file picker icon as a button
                Center(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowMultiple: true, // Allow multiple file selection
                          allowedExtensions: ['csv'],
                        );

                        if (result != null && result.files.isNotEmpty) {
                          setState(() {
                            selectedCsvFiles = result.files
                                .map((file) => File(file.path!))
                                .toList();
                            // Set the collection name based on the first file name without extension
                            collectionNameController.text = selectedCsvFiles
                                .first.path
                                .split('/')
                                .last
                                .split('.')
                                .first;
                          });
                          Utils().toastMessage('Files Selected');
                        } else {
                          Utils().toastMessage('No files selected');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          elevation: 12,
                          shadowColor: Colors.black87,
                          side: BorderSide.none,
                          shape: const StadiumBorder()),
                      child: const Text(
                        'Select Files',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Show the upload button
                Center(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        await uploadSelectedFiles();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          elevation: 12,
                          shadowColor: Colors.black87,
                          side: BorderSide.none,
                          shape: const StadiumBorder()),
                      child: const Text(
                        'Upload',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Show upload status message
                if (isUploading)
                  Text(
                    'Uploading... ${(uploadProgress * 100).toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                if (uploadSuccess)
                  Text(
                    'Upload successful!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
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
