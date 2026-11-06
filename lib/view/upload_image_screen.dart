// dart:io gives us the File class (to work with the picked image file)
import 'dart:io';

import 'package:flutter/material.dart';

// http package: used to send the image to the server.
// "as http" means we write http.MultipartRequest, http.Response, etc.
import 'package:http/http.dart' as http;

// image_picker: opens the phone gallery so the user can choose a picture
import 'package:image_picker/image_picker.dart';

// modal_progress_hud_nsn: shows a loading spinner over the screen
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// A StatefulWidget is used because the screen changes
// (picked image, spinner on/off) while the app is running.
class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  // The picked image. It is null (empty) until the user picks one.
  File? image;

  // The object that opens the gallery
  final _picker = ImagePicker();

  // true = show the loading spinner, false = hide it
  bool showSpinner = false;

  // ---------------------------------------------------------------
  // STEP 1: Pick an image from the gallery
  // ---------------------------------------------------------------
  Future getImage() async {
    // Open the gallery. imageQuality: 80 makes the file smaller.
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    // pickedFile is null if the user closed the gallery without choosing
    if (pickedFile != null) {
      // setState tells Flutter to redraw the screen with the new image
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  // ---------------------------------------------------------------
  // STEP 2: Upload the picked image to the server
  // ---------------------------------------------------------------
  Future<void> uploadImage() async {
    // If no image is picked, show a message and stop.
    // This prevents the "Null check operator" crash.
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick an image first')),
      );
      return;
    }

    // Show the loading spinner
    setState(() {
      showSpinner = true;
    });

    // try/catch/finally: if something goes wrong (no internet etc.)
    // the app will not crash, and the spinner will always stop.
    try {
      // The server address that receives the image
      var uri = Uri.parse('https://api.escuelajs.co/api/v1/files/upload');

      // A multipart request is the normal way to send files to a server
      var request = http.MultipartRequest('POST', uri);

      // Add the image to the request.
      // 'file'  = the field name the server expects
      // fromPath = reads the file and sets the file name and
      //            content type (image/jpeg etc.) automatically
      request.files.add(
        await http.MultipartFile.fromPath('file', image!.path),
      );

      // Send the request to the server and wait for the reply
      var streamedResponse = await request.send();

      // Convert the reply into a normal Response so we can read its body
      var response = await http.Response.fromStream(streamedResponse);

      // Print the result in the console to see what the server said
      print('status: ${response.statusCode}');
      print('body: ${response.body}');

      // 200 = OK, 201 = Created. Both mean the upload worked.
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('image uploaded');

        // mounted = the screen is still open. Safe to show a message.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image uploaded successfully')),
          );
        }
      } else {
        // Any other number means the server refused or failed
        print('failed');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      // Runs when an error happens (for example no internet)
      print('error: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      // finally always runs, success or failure.
      // So the spinner never gets stuck on the screen.
      if (mounted) {
        setState(() {
          showSpinner = false;
        });
      }
    }
  }

  // ---------------------------------------------------------------
  // STEP 3: The screen layout
  // ---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // ModalProgressHUD shows the spinner on top of the screen
    // when showSpinner is true
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        // Top blue bar with the title
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Upload Image'),
        ),

        body: Column(
          // Put everything in the centre of the screen
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Tap here to pick an image
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: Container(
                // If no image is picked, show the text "Pick Image".
                // Otherwise show the picked image (100 x 100).
                child: image == null
                    ? const Center(child: Text('Pick Image'))
                    : Center(
                  child: Image.file(
                    File(image!.path).absolute,
                    height: 100,
                    width: 100,
                  ),
                ),
              ),
            ),

            // Empty space between the image and the Upload button
            const SizedBox(height: 150),

            // Tap here to upload the picked image
            GestureDetector(
              onTap: () {
                uploadImage();
              },
              child: Container(
                height: 50,
                width: 200,
                color: Colors.green,
                child: const Center(child: Text('Upload')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}