import 'package:flutter/material.dart';

class MaiChatScreen extends StatefulWidget {
  const MaiChatScreen({Key? key}) : super(key: key);

  @override
  State<MaiChatScreen> createState() => _MaiChatScreenState();
}

class _MaiChatScreenState extends State<MaiChatScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> sendMessage(String message) async {
    setState(() {
      _controller.text = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black54),
          onPressed: () {
            // TODO: Implement menu action
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black54),
            onPressed: () {
              // TODO: Implement profile action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Merhaba, Kripto Arayanı',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Buraya Mesajını Yaz',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Icon(Icons.email_outlined, color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
              onSubmitted: sendMessage,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSuggestionChip('Bitcoin', Colors.purple[50]!, Colors.black87),
                _buildSuggestionChip('Ethereum', Colors.deepPurpleAccent, Colors.white),
              ],
            ),
            const SizedBox(height: 15),
            _buildSuggestionChip(
              'Hangisi Şuan Yükselişte',
              Colors.black,
              Colors.white,
              isWide: true,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSuggestionChip('XRP', Colors.deepPurpleAccent, Colors.white),
                const SizedBox(width: 15),
                _buildSuggestionChip('Doge', Colors.grey.shade400, Colors.black87),
              ],
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: _buildSuggestionChip('Tut/Sat', Colors.purple[50]!, Colors.black87),
            ),
            const Spacer(),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Herhangi Birini Seçerek Bir sohbet başlatabilirsin',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SizedBox.shrink(),
            label: 'Sohbet Modu',
          ),
          BottomNavigationBarItem(
            icon: SizedBox.shrink(),
            label: 'Analiz Modu',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
        elevation: 5,
        onTap: (index) {
          // TODO: Implement navigation logic
        },
      ),
    );
  }

  Widget _buildSuggestionChip(String label, Color backgroundColor, Color textColor, {bool isWide = false}) {
    return ElevatedButton(
      onPressed: () {
        _controller.text = label;
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 30, vertical: 15),
        minimumSize: isWide ? const Size(double.infinity, 50) : null,
      ),
      child: Text(label),
    );
  }
}
