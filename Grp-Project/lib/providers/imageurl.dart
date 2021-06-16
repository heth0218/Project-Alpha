import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// class ImageUrlItem {
//   final String? url;

//   ImageUrlItem({
//     @required this.url,
//   });
// }

class ImageUrl with ChangeNotifier {
  List<String> _items = [];

  List<String> get items {
    return [..._items];
  }

  Future<Map<String, dynamic>> imageToText(String imageUrl) async {
    var url = 'https://ocr-entity-recognition.herokuapp.com/extract_data';
    try {
      // print(imageUrl);
      final response = await http.post(
        Uri.parse(url),
        body: {
          'url': imageUrl,
        },
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      return extractedData;
    } catch (error) {
      throw (error);
    }
  }

  Future<Map<String, dynamic>> voiceToText(String words) async {
    var url = 'https://ocr-entity-recognition.herokuapp.com/process_text';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'text': words,
        },
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      return extractedData;
    } catch (error) {
      throw (error);
    }
  }
}
