import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import './imagetotext.dart';

class ImageCapture extends StatefulWidget {
  const ImageCapture({Key? key}) : super(key: key);

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  PickedFile? _imageFile;
  File? _storedImageFile;
  final ImagePicker _picker = ImagePicker();
  var _isLoading = false;

  Future<void> captureImage() async {
    _imageFile = await _picker.getImage(source: ImageSource.gallery);
    if (_imageFile == null) {
      return;
    }
    setState(() {
      _imageFile = PickedFile(_imageFile!.path);
      _storedImageFile = File(_imageFile!.path);
    });
  }

  void uploadImageButton() async {
    String fileName = p.basename(_imageFile!.path);
    var file = File(_imageFile!.path);
    var imageUrl;
    final _firebaseStorage = FirebaseStorage.instance;
    if (_imageFile != null) {
      //Upload to Firebase
      setState(() {
        _isLoading = true;
      });
      var snapshot = await _firebaseStorage
          .ref()
          .child('images/$fileName')
          .putFile(file)
          .whenComplete(() => null);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        _imageFile = null;
        _isLoading = false;
      });
      Navigator.of(context)
          .pushNamed(ImageToText.routeName, arguments: imageUrl);
    } else {
      print('No Image Path Received');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: _imageFile != null
                  ? Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 300,
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Image.file(
                            _storedImageFile!,
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: uploadImageButton,
                          child: Text('Upload To Firebase'),
                        )
                      ],
                    )
                  : IconButton(
                      icon: Icon(Icons.image_outlined),
                      onPressed: captureImage,
                    ),
            ),
    );
  }
}
