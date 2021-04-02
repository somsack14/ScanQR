import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';

class GenerateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<GenerateScreen> {
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();
  String _dataString = "Hello from this QR";
  String _inputErrorText;
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _captureAndSharePng,
          )
        ],
      ),
      body: _contentWidget(),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      final file = await new File('$tempPath/image.jpg').create();
      await file.writeAsBytes(pngBytes);
      await Share.file(
          'esys image', 'esys.jpg', pngBytes.buffer.asUint8List(), 'image/jgp',
          text: 'My optional text');

      // final channel = const MethodChannel('channel:me.alfian.share/share');
      // channel.invokeMethod('shareFile', 'image.png');

      setState(() {
        print(pngBytes);
        print("bytes");
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: _topSectionTopPadding,
              left: 20.0,
              right: 10.0,
              bottom: _topSectionBottomPadding,
            ),
            child: Container(
              height: _topSectionHeight,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: "Enter a custom message",
                        errorText: _inputErrorText,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: FlatButton(
                      child: Text("SUBMIT"),
                      onPressed: () {
                        setState(() {
                          _dataString = _textController.text;
                          _inputErrorText = null;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: RepaintBoundary(
                  key: globalKey,
                  child: QrImage(
                    backgroundColor: Colors.white,
                    version: QrVersions.auto,
                    data: _dataString,
                    size: 0.5 * bodyHeight,
                    embeddedImage: NetworkImage(
                      "https://lh3.googleusercontent.com/proxy/1HAHLIWClu3SD9R60refhDA8TIBsUz-3buu3OJfz7N6-dh2PyJ7KUPm_YlAcPo8swiJ1CfiKNJks7h6uF1_gpdhVXL3fPmkslnDBexjV1yqZ",
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
