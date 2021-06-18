import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:provider/provider.dart';
import '../providers/imageurl.dart';

import './imagetotext.dart';

class ImageCapture extends StatefulWidget {
  final tutorialCall;

  ImageCapture(this.tutorialCall);

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  PickedFile? _imageFile;
  File? _storedImageFile;
  final ImagePicker _picker = ImagePicker();
  var _isLoading = false;
  String? word;
  String? judgingVariable;

  Future<void> captureImage() async {
    judgingVariable = null;
    _imageFile = await _picker.getImage(source: ImageSource.gallery);
    if (_imageFile == null) {
      return;
    }
    setState(() {
      _imageFile = PickedFile(_imageFile!.path);
      _storedImageFile = File(_imageFile!.path);
    });
  }

  void invokeApi(imageUrl) async {
    _isLoading = true;
    print('Hello');
    final result = await Provider.of<ImageUrl>(context, listen: false)
        .imageToText(imageUrl);
    print(result['Summary']);
    // setState(() {
    //   word = result['Summary'];
    // });
    // print(word);
    if (result['Summary'].compareTo(' Dog') == 0) {
      setState(() {
        judgingVariable = 'true';
      });
    } else {
      setState(() {
        judgingVariable = 'false';
      });
    }
    _isLoading = false;
  }

  void uploadImageButton() async {
    judgingVariable = null;
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
      widget.tutorialCall
          ? invokeApi(imageUrl)
          : Navigator.of(context)
              .pushNamed(ImageToText.routeName, arguments: imageUrl);
    } else {
      print('No Image Path Received');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                              child: Text('Upload Image'),
                            )
                          ],
                        )
                      : IconButton(
                          icon: Icon(Icons.image_outlined),
                          onPressed: captureImage,
                        ),
                ),
        ),
        widget.tutorialCall &&
                (judgingVariable == 'true' || judgingVariable == 'false')
            ? Container(
                child: Column(
                  children: [
                    Image.network(
                      judgingVariable == 'true'
                          ? 'https://png.pngtree.com/png-vector/20210212/ourmid/pngtree-green-correct-icon-png-image_2912233.jpg'
                          : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRD3dae81V0LeLMif297hj4tnpiOSC4S8zafQ&usqp=CAU',
                      fit: BoxFit.cover,
                    )
                  ],
                ),
              )
            : Container()
      ],
    );
  }
}
