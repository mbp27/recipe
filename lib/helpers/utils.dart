import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Utils {
  /// Get the orientation of device with context
  static Orientation orientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  /// Downloading image from url and save it to temp directory
  static Future<File> downloadImage(String url) async {
    final temp = await getTemporaryDirectory();
    final filename = url.substring(url.lastIndexOf('/') + 1);
    final imageFile = File('${temp.path}/images/$filename');

    if (!(imageFile.existsSync())) {
      // Image doesn't exist in cache
      // Download the image and write to above file
      final response = await http.get(Uri.parse(url));
      // Creating file image
      await imageFile.create(recursive: true);
      // Write file from downloaded image
      await imageFile.writeAsBytes(response.bodyBytes);
    }
    return imageFile;
  }

  /// Save file with bodyBytes to temp directory
  static Future<File> saveFile(
      {required Uint8List bodyBytes, required String filenameWithExt}) async {
    final temp = await getTemporaryDirectory();
    final file = File('${temp.path}/downloads/$filenameWithExt');
    // Creating file image
    await file.create(recursive: true);
    // Write file from bodyBytes
    await file.writeAsBytes(bodyBytes);
    return file;
  }
}
