import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class GetImagePage extends StatefulWidget {
  const GetImagePage({Key? key}) : super(key: key);

  @override
  _GetImagePageState createState() => _GetImagePageState();
}

class _GetImagePageState extends State<GetImagePage> {
  late File image;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: _size.height,
        width: _size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0f2027),
              Color(0xff203a43),
              Color(0xff2c5364),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(0.0, 1.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildOptionButton(
                  _size,
                  'Seleccionar de galería',
                  true,
                ),

                buildOptionButton(
                  _size,
                  'Capturar foto',
                  false,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton buildOptionButton(Size _size, String text, bool option) {
    return ElevatedButton(
      child: Center(
        child: Text(
          text.toUpperCase(),
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17
          ),
        ),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevation: MaterialStateProperty.all<double>(3.0),
        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff2c5364)),
        maximumSize: MaterialStateProperty.all<Size>(Size(_size.width * 0.4, _size.height * 0.2)),
      ),
      onPressed: () {
        if (option) {
          // Seleccionar de galería
          _processImage(ImageSource.gallery);
        } else {
          // Abrir cámara
          _processImage(ImageSource.camera);
        }
      },
    );
  }

  void _processImage(ImageSource source) async {
    final _picker = ImagePicker();
    final _pickedFile = await _picker.pickImage(source: source);
    if (_pickedFile != null) {
      image = File(_pickedFile.path);
    }

    Navigator.pushNamed(context, 'upload_image', arguments: image);
  }
}

