import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  String name;

  ContactScreen({super.key, required this.name});
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  void handleSubmit() {
    String name = nameController.text.trim();
    String subject = subjectController.text.trim();
    String message = messageController.text.trim();

    // Print or send to backend
    print("Name: $name");
    print("Subject: $subject");
    print("Message: $message");

    // You can add further logic like API call here

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Message Submitted")));

    // Clear fields
    nameController.clear();
    subjectController.clear();
    messageController.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.name;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Contact Us"), backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Name Field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Subject Field
            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Message Field (Multiline)
            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Your Message',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: handleSubmit,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
