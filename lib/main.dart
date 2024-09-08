

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot UI',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: ChatbotUI(),
    );
  }
}

class ChatbotUI extends StatefulWidget {
  @override
  _ChatbotUIState createState() => _ChatbotUIState();
}

class _ChatbotUIState extends State<ChatbotUI> {
  bool focusEnabled = false;
  String selectedFile = '';
  List<Map<String, String>> chatMessages = []; // Chat messages

  TextEditingController searchController = TextEditingController();

  // This method sends the query to the Python backend and fetches the response
  Future<void> _sendChatQuery(String query) async {
    setState(() {
      chatMessages.add({'sender': 'user', 'message': query});
    });

    // Replace with your Python backend URL
    final String apiUrl = "http://127.0.0.1:5000/chatbot";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"query": query}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String botResponse = jsonResponse['response'];

        setState(() {
          chatMessages.add({'sender': 'bot', 'message': botResponse});
        });
      } else {
        setState(() {
          chatMessages.add({
            'sender': 'bot',
            'message': 'Error: Unable to fetch response from server.'
          });
        });
      }
    } catch (e) {
      setState(() {
        chatMessages.add({
          'sender': 'bot',
          'message': 'Error: Failed to connect to the server.'
        });
      });
    }
  }

  // This method handles file attachment
  Future<void> _pickFile() async {
    // File picking logic here
    // Example: Using file_picker package to choose a file
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(
          'Mokshayani',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: TextField(
                controller: searchController,
                onSubmitted:
                    _sendChatQuery, // Sends the query when pressed "Enter"
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[850],
                  hintText: 'Ask anything...',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () => _sendChatQuery(
                        searchController.text), // Sends query when clicked
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Focus', style: TextStyle(color: Colors.white)),
                Switch(
                  value: focusEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      focusEnabled = value;
                    });
                  },
                  activeColor: Colors.blue,
                ),
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.white),
                  onPressed: _pickFile,
                ),
                Icon(Icons.lock, color: Colors.white),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  final chat = chatMessages[index];
                  bool isUser = chat['sender'] == 'user';
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue : Colors.grey[850],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        chat['message']!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white70,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Home clicked')),
            );
          } else if (index == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Discover clicked')),
            );
          } else if (index == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Library clicked')),
            );
          }
        },
      ),
    );
  }
}
