import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MaiChatScreen extends StatefulWidget {
  const MaiChatScreen({Key? key}) : super(key: key);

  @override
  State<MaiChatScreen> createState() => _MaiChatScreenState();
}

class _MaiChatScreenState extends State<MaiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = "";
  bool _isLoading = false;

  Future<void> sendMessage(String message) async {
    setState(() {
      _isLoading = true;
      _response = '';
    });

    const apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
    const apiKey = '<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>';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      "model": "microsoft/mai-ds-r1:free",
      "messages": [
        {"role": "user", "content": message}
      ],
    });

    try {
      final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MAI Chat (Crypto)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter your question about cryptocurrency',
              ),
              onSubmitted: sendMessage,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : () => sendMessage(_controller.text),
              child: const Text('Send'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _response,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
