import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  // Sample chat data
  final List<Map<String, String>> messages = [
    {"text": "Hi!", "sender": "receiver"},
    {"text": "Hello! How are you?", "sender": "sender"},
    {"text": "I'm good. Thanks for asking!", "sender": "receiver"},
    {"text": "That's great to hear!", "sender": "sender"},
    {"text": "What about you?", "sender": "receiver"},
    {"text": "I'm doing well too!", "sender": "sender"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Chat",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 47, 33, 243),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isSender = message["sender"] == "sender";

                return Align(
                  alignment:
                      isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: isSender
                          ? Color.fromARGB(255, 47, 33, 243)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12.0),
                        topRight: const Radius.circular(12.0),
                        bottomLeft: isSender
                            ? const Radius.circular(12.0)
                            : const Radius.circular(0),
                        bottomRight: isSender
                            ? const Radius.circular(0)
                            : const Radius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      message["text"]!,
                      style: TextStyle(
                        color: isSender ? Colors.white : Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: () {
              // Add your send message logic here
            },
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
            backgroundColor: Color.fromARGB(255, 47, 33, 243),
          )
        ],
      ),
    );
  }
}
