import 'dart:developer';
import 'dart:io';

import 'dart:typed_data';

import 'package:dio/dio.dart';

class FetchFiles {
  Dio dio;

  FetchFiles({required this.dio});
  //method to fetch image from firebase
  Future<Uint8List?> fetchFile(String downloadUrl) async {
    try {
      log("fetch file image file from server...(^_^)");
      final response = await dio.get(downloadUrl,
          options: Options(responseType: ResponseType.bytes));
      return response.data;
    } on Exception catch (ex) {
      log("Error ${ex.toString()}");
      return null;
    }
  }
}
