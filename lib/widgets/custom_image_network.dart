import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imagePath;
  const CustomNetworkImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imagePath,
      filterQuality: FilterQuality.medium,
      fit: BoxFit.cover,
      // height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width * 0.7,
      // errorBuilder: (context, object, stacktrace) {
      //   return Image.network(
      //     "https://www.russellheimlich.com/blog/wp-content/uploads/2007/11/404-no-file.png",
      //     filterQuality: FilterQuality.high,
      //     fit: BoxFit.cover,
      //     height: MediaQuery.of(context).size.height * 0.35,
      //     width: double.infinity,
      //   );
      // },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
            ),
          ),
        );
      },
    );
  }
}
