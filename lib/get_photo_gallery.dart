import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';


class GetPhotoByGallery extends StatefulWidget {
  GetPhotoByGallery({Key key}) : super(key: key);

  @override
  _GetPhotoByGalleryState createState() => _GetPhotoByGalleryState();
}

class _GetPhotoByGalleryState extends State<GetPhotoByGallery> {

  final picker = ImagePicker();
  String _qrcodeFile = '';
  String _data = '';
  File file;
  String name, detail, urlPicture;


  
  Widget cameraButton() {
    return IconButton(
      icon: Icon(
        Icons.add_a_photo,
        size: 36.0,
        color: Color.fromRGBO(255, 87, 34, 1),
      ),
      onPressed: () {
        chooseImage(ImageSource.camera);
      },
    );
  }

  Future<void> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.pickImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );

      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 36.0,
        color: Color.fromRGBO(255, 87, 34, 1),
      ),
      onPressed: () {
        chooseImage(ImageSource.gallery);
      },
    );
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        cameraButton(),
        galleryButton(),
      ],
    );
  }

  Widget showImage() {
    return Container(
      padding: EdgeInsets.all(20.0),
      // color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: file == null ? Image.asset('images/1559788943.png') : Image.file(file),
    );
  }

  Widget showContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          showImage(),
          showButton(),
          Text('Qr Code data: $_data\n'),
        ],
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
      body: showContent(),
    );
  
  }
}

