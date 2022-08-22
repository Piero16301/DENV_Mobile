import 'dart:io';

import 'package:denv_mobile/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class CreateCaseReport extends StatelessWidget {
  const CreateCaseReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear reporte de caso'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          PhotoDisplayAndSelect(size: size),
          const SizedBox(height: 20),
          InsertComment(size: size),
        ],
      ),
    );
  }
}

class InsertComment extends StatelessWidget {
  const InsertComment({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Comentario',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Escribe un comentario',
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoDisplayAndSelect extends StatefulWidget {
  const PhotoDisplayAndSelect({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<PhotoDisplayAndSelect> createState() => _PhotoDisplayAndSelectState();
}

class _PhotoDisplayAndSelectState extends State<PhotoDisplayAndSelect> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: widget.size.width - 100,
            height: (widget.size.width - 100) * 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 3,
                color: ThemeModeApp.isDarkMode ? Colors.white : Colors.black,
              ),
              color: ThemeModeApp.isDarkMode
                  ? const Color.fromARGB(255, 66, 66, 66)
                  : const Color.fromARGB(255, 185, 185, 185),
            ),
            child: image == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 75),
                    child: SvgPicture.asset(
                      'assets/app_icons/no-image.svg',
                      color:
                          ThemeModeApp.isDarkMode ? Colors.white : Colors.black,
                    ),
                  )
                : Image.file(
                    image!,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: widget.size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.camera,
                      );
                      if (pickedFile != null) {
                        setState(() {
                          image = File(pickedFile.path);
                        });
                      }
                    },
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        const Size.fromHeight(40),
                      ),
                    ),
                    child: const Text(
                      'Tomar foto',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        setState(() {
                          image = File(pickedFile.path);
                        });
                      }
                    },
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        const Size.fromHeight(40),
                      ),
                    ),
                    child: const Text(
                      'Seleccionar foto',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
