import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

showImagePicker(BuildContext context, Function(ImageSource) callback) {
  double height = MediaQuery.of(context).size.height;
  showModalBottomSheet(
    context: context,
    builder: (builder) {
      return Card(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: height / 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    callback(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      SizedBox(height: height / 24),
                      const Icon(Icons.image),
                      const SizedBox(height: 12),
                      const Text(
                        "Gallery",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    callback(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      SizedBox(height: height / 24),
                      const Icon(Icons.camera),
                      const SizedBox(height: 12),
                      const Text(
                        "Camera",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
