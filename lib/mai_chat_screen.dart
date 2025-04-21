import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



Future<void> sendMessage(String message) async {



  setState(() {
    _isLoading = true;
    _response = '';
  });

  // ❗ Android emulator için localhost => 10.0.2.2
  const apiUrl = 'http://10.0.2.2:5000/ask'; // Eğer fiziksel cihazdan bağlanıyorsan IP yazılır
  final headers = {
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    "message": message,
  });

  try {
    final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['response']; // Flask tarafı 'response' key'inde gönderiyor
      setState(() {
        _response = content;
      });
    } else {
      setState(() {
        _response = 'Error: ${response.statusCode}\n${response.body}';
      });
    }
  } catch (e) {
    setState(() {
      _response = 'Request failed: $e';
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}
