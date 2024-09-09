// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ChatbotUI extends StatefulWidget {
//   @override
//   _ChatbotUIState createState() => _ChatbotUIState();
// }

// class _ChatbotUIState extends State<ChatbotUI> {
//   bool focusEnabled = false;
//   String selectedFile = '';
//   List<Map<String, String>> chatMessages = [];
//   String sessionId = '';
//   TextEditingController searchController = TextEditingController();
//   User? currentUser;

//   @override
//   void initState() {
//     super.initState();
//     _startNewChatSession();
//     currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       Navigator.of(context).pushReplacementNamed('/auth');
//     }
//   }

//   Future<void> _sendChatQuery(String query) async {
//     setState(() {
//       chatMessages.add({'sender': 'user', 'message': query});
//     });

//     final String apiUrl = "http://10.0.2.2:5000/ask";

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"question": query}),
//       );

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         String botResponse = jsonResponse['response'];

//         setState(() {
//           chatMessages.add({'sender': 'bot', 'message': botResponse});
//         });
//       } else {
//         setState(() {
//           chatMessages.add({
//             'sender': 'bot',
//             'message': 'Error: Unable to fetch response from server.'
//           });
//         });
//       }
//     } catch (e) {
//       setState(() {
//         chatMessages.add({
//           'sender': 'bot',
//           'message': 'Error: Failed to connect to the server.'
//         });
//       });
//     }
//   }

//   Future<void> _pickFile() async {
//     // Same as your existing _pickFile method
//   }

//   Future<void> _uploadFile(File file) async {
//     // Same as your existing _uploadFile method
//   }

//   void _clearChat() {
//     setState(() {
//       chatMessages.clear();
//     });
//   }

//   void _startNewChatSession() {
//     setState(() {
//       chatMessages.clear();
//       sessionId = DateTime.now().millisecondsSinceEpoch.toString();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.black,
//         title: Text('Mokshayani', style: TextStyle(color: Colors.white)),
//         actions: [
//           IconButton(icon: Icon(Icons.add), onPressed: _startNewChatSession),
//           IconButton(icon: Icon(Icons.clear), onPressed: _clearChat),
//           IconButton(icon: Icon(Icons.person), onPressed: () {}),
//         ],
//       ),
//       drawer: Drawer(
//           // Drawer menu items
//           ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             Center(
//               child: TextField(
//                 controller: searchController,
//                 onSubmitted: _sendChatQuery,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.grey[850],
//                   hintText: 'Ask anything...',
//                   hintStyle: TextStyle(color: Colors.white70),
//                   prefixIcon: Icon(Icons.search, color: Colors.white),
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.send, color: Colors.white),
//                     onPressed: () => _sendChatQuery(searchController.text),
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Focus', style: TextStyle(color: Colors.white)),
//                 Switch(
//                   value: focusEnabled,
//                   onChanged: (bool value) {
//                     setState(() {
//                       focusEnabled = value;
//                     });
//                   },
//                   activeColor: Colors.blue,
//                 ),
//                 IconButton(
//                     icon: Icon(Icons.attach_file, color: Colors.white),
//                     onPressed: _pickFile),
//                 Icon(Icons.lock, color: Colors.white),
//               ],
//             ),
            // SizedBox(height: 20),
            // Expanded(
            //   child: ListView(
            //     children: [
            //       QueryCard('When will the next iPhone be released?',
            //           Icons.phone_android),
            //       QueryCard('Penalty for late tax filing', Icons.error_outline),
            //       QueryCard(
            //           'Summarize the research on brain breaks', Icons.grain),
            //       QueryCard('Will US interest rates go down this year?',
            //           Icons.trending_down),
            //     ],
            //   ),
            // ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: chatMessages.length,
//                 itemBuilder: (context, index) {
//                   final chat = chatMessages[index];
//                   bool isUser = chat['sender'] == 'user';
//                   return Align(
//                     alignment:
//                         isUser ? Alignment.centerRight : Alignment.centerLeft,
//                     child: Container(
//                       margin: EdgeInsets.symmetric(vertical: 5),
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: isUser ? Colors.blue : Colors.grey[850],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Text(
//                         chat['message']!,
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.black,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.white70,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.library_books), label: 'Library'),
//         ],
//         onTap: (index) {
//           if (index == 0) {
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text('Home clicked')));
//           } else if (index == 1) {
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text('Discover clicked')));
//           } else if (index == 2) {
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text('Library clicked')));
//           }
//         },
//       ),
//     );
//   }
// }

// class QueryCard extends StatelessWidget {
//   final String queryText;
//   final IconData icon;

//   QueryCard(this.queryText, this.icon);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.grey[850],
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: ListTile(
//         leading: Icon(icon, color: Colors.white),
//         title: Text(queryText, style: TextStyle(color: Colors.white)),
//         onTap: () {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Tapped: $queryText')),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotUI extends StatefulWidget {
  @override
  _ChatbotUIState createState() => _ChatbotUIState();
}

class _ChatbotUIState extends State<ChatbotUI> {
  bool focusEnabled = false;
  String selectedFile = '';
  List<Map<String, String>> chatMessages = [];
  String sessionId = '';
  TextEditingController searchController = TextEditingController();
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _startNewChatSession();
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      Navigator.of(context).pushReplacementNamed('/auth');
    }
  }

  Future<void> _sendChatQuery(String query) async {
    setState(() {
      chatMessages.add({'sender': 'user', 'message': query});
    });

    final String apiUrl = "http://10.0.2.2:5000/ask";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"question": query}),
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

  void _clearChat() {
    setState(() {
      chatMessages.clear();
    });
  }

  void _startNewChatSession() {
    setState(() {
      chatMessages.clear();
      sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    });
  }
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectedFile = result.files.single.name;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File selected: ${result.files.single.name}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text('Mokshayani', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: _startNewChatSession),
          IconButton(icon: Icon(Icons.clear), onPressed: _clearChat),
          IconButton(icon: Icon(Icons.person), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[850],
                      hintText: 'Ask anything...',
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
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
              child: ListView(
                children: [
                  QueryCard('When will the next iPhone be released?',
                      Icons.phone_android),
                  QueryCard('Penalty for late tax filing', Icons.error_outline),
                  QueryCard(
                      'Summarize the research on brain breaks', Icons.grain),
                  QueryCard('Will US interest rates go down this year?',
                      Icons.trending_down),
                ],
              ),
            ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () => _sendChatQuery(searchController.text),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white70,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books), label: 'Library'),
        ],
        onTap: (index) {
          if (index == 0) {
            // You are already on the home screen (ChatbotUI), no need to navigate
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/discover');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/library');
          }
        },
      ),
    );
  }
}
class QueryCard extends StatelessWidget {
  final String queryText;
  final IconData icon;

  QueryCard(this.queryText, this.icon);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(queryText, style: TextStyle(color: Colors.white)),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped: $queryText')),
          );
        },
      ),
    );
  }
}