// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'dart:io';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';

// // class DiscoverScreen extends StatefulWidget {
// //   @override
// //   _DiscoverScreenState createState() => _DiscoverScreenState();
// // }

// // class _DiscoverScreenState extends State<DiscoverScreen> {
// //   TextEditingController searchController = TextEditingController();
// //   List<Map<String, String>> searchResults = [];
// //   File? _image;

// //   Future<void> _sendSearchQuery(String query) async {
// //     setState(() {
// //       searchResults.add({'sender': 'user', 'message': query});
// //     });

// //     final String apiUrl = "http://10.0.2.2:5000/ask";

// //     try {
// //       final response = await http.post(
// //         Uri.parse(apiUrl),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({"question": query}),
// //       );

// //       if (response.statusCode == 200) {
// //         final jsonResponse = jsonDecode(response.body);
// //         String botResponse = jsonResponse['response'];

// //         setState(() {
// //           searchResults.add({'sender': 'bot', 'message': botResponse});
// //         });
// //       } else {
// //         setState(() {
// //           searchResults.add({
// //             'sender': 'bot',
// //             'message': 'Error: Unable to fetch response from server.'
// //           });
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         searchResults.add({
// //           'sender': 'bot',
// //           'message': 'Error: Failed to connect to the server.'
// //         });
// //       });
// //     }
// //   }

// //   Future<void> _pickImage() async {
// //     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
// //     if (pickedFile != null) {
// //       setState(() {
// //         _image = File(pickedFile.path);
// //         searchResults.add({'sender': 'user', 'message': '[Image uploaded]'});
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Search'),
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: searchResults.length,
// //               itemBuilder: (context, index) {
// //                 final chat = searchResults[index];
// //                 bool isUser = chat['sender'] == 'user';
// //                 return Align(
// //                   alignment: isUser
// //                       ? Alignment.centerRight
// //                       : Alignment.centerLeft,
// //                   child: Container(
// //                     margin: EdgeInsets.symmetric(vertical: 5),
// //                     padding: EdgeInsets.all(10),
// //                     decoration: BoxDecoration(
// //                       color: isUser ? Colors.blue : Colors.grey[850],
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     child: chat['message'] == '[Image uploaded]' && _image != null
// //                         ? Image.file(_image!)
// //                         : Text(
// //                             chat['message']!,
// //                             style: TextStyle(color: Colors.white),
// //                           ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Row(
// //               children: [
// //                 IconButton(
// //                   icon: Icon(Icons.image, color: Colors.white),
// //                   onPressed: _pickImage,
// //                 ),
// //                 Expanded(
// //                   child: TextField(
// //                     controller: searchController,
// //                     decoration: InputDecoration(
// //                       filled: true,
// //                       fillColor: Colors.grey[850],
// //                       hintText: 'Search...',
// //                       hintStyle: TextStyle(color: Colors.white70),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(30),
// //                         borderSide: BorderSide.none,
// //                       ),
// //                     ),
// //                     style: TextStyle(color: Colors.white),
// //                   ),
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.search, color: Colors.white),
// //                   onPressed: () {
// //                     _sendSearchQuery(searchController.text);
// //                     searchController.clear();
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //       bottomNavigationBar: BottomNavigationBar(
// //         backgroundColor: Colors.black,
// //         selectedItemColor: Colors.blue,
// //         unselectedItemColor: Colors.white70,
// //         items: const <BottomNavigationBarItem>[
// //           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
// //           BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
// //           BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Library'),
// //         ],
// //         onTap: (index) {
// //           if (index == 0) {
// //             Navigator.pushReplacementNamed(context, '/home');
// //           } else if (index == 1) {
// //             // Already on Discover screen
// //           } else if (index == 2) {
// //             Navigator.pushReplacementNamed(context, '/library');
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class DiscoverScreen extends StatefulWidget {
//   final String? initialQuery;

//   DiscoverScreen({this.initialQuery});

//   @override
//   _DiscoverScreenState createState() => _DiscoverScreenState();
// }

// class _DiscoverScreenState extends State<DiscoverScreen> {
//   bool focusEnabled = false;
//   bool inChatMode = false;
//   List<Map<String, String>> chatMessages = [];
//   String sessionId = '';
//   TextEditingController searchController = TextEditingController();
//   List<Map<String, String>> searchResults = [];
//   File? _image;

//   @override
//   void initState() {
//     super.initState();
//     // If an initial query is provided, automatically trigger the search
//     if (widget.initialQuery != null) {
//       _sendSearchQuery(widget.initialQuery!);
//     }
//   }

//   Future<void> _sendSearchQuery(String query) async {
//     setState(() {
//       searchResults.add({'sender': 'user', 'message': query});
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
//           searchResults.add({'sender': 'bot', 'message': botResponse});
//         });
//       } else {
//         setState(() {
//           searchResults.add({
//             'sender': 'bot',
//             'message': 'Error: Unable to fetch response from server.'
//           });
//         });
//       }
//     } catch (e) {
//       setState(() {
//         searchResults.add({
//           'sender': 'bot',
//           'message': 'Error: Failed to connect to the server.'
//         });
//       });
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         searchResults.add({'sender': 'user', 'message': '[Image uploaded]'});
//       });
//     }
//   }

//   void _clearChat() {
//     setState(() {
//       chatMessages.clear();
//       inChatMode = false; // Return to initial state
//     });
//   }

//   void _startNewChatSession() {
//     setState(() {
//       chatMessages.clear();
//       sessionId = DateTime.now().millisecondsSinceEpoch.toString();
//       inChatMode = false; // Ensure starting in initial state
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Discover'),
//         actions: [
//           IconButton(icon: Icon(Icons.add), onPressed: _startNewChatSession),
//           IconButton(icon: Icon(Icons.clear), onPressed: _clearChat),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: searchResults.length,
//               itemBuilder: (context, index) {
//                 final chat = searchResults[index];
//                 bool isUser = chat['sender'] == 'user';
//                 return Align(
//                   alignment:
//                       isUser ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: EdgeInsets.symmetric(vertical: 5),
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isUser ? Colors.blue : Colors.grey[850],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child:
//                         chat['message'] == '[Image uploaded]' && _image != null
//                             ? Image.file(_image!)
//                             : Text(
//                                 chat['message']!,
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.image, color: Colors.white),
//                   onPressed: _pickImage,
//                 ),
//                 Expanded(
//                   child: TextField(
//                     controller: searchController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.grey[850],
//                       hintText: 'Search...',
//                       hintStyle: TextStyle(color: Colors.white70),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send, color: Colors.white),
//                   onPressed: () {
//                     _sendSearchQuery(searchController.text);
//                     searchController.clear();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
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
//             Navigator.pushReplacementNamed(context, '/home');
//           } else if (index == 1) {
//             // Already on Discover screen
//           } else if (index == 2) {
//             Navigator.pushReplacementNamed(context, '/library');
//           }
//         },
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class DiscoverScreen extends StatefulWidget {
//   final String? initialQuery;

//   DiscoverScreen({this.initialQuery});

//   @override
//   _DiscoverScreenState createState() => _DiscoverScreenState();
// }

// class _DiscoverScreenState extends State<DiscoverScreen> {
//   bool focusEnabled = false;
//   bool inChatMode = false;
//   List<Map<String, String>> chatMessages = [];
//   String sessionId = '';
//   TextEditingController searchController = TextEditingController();
//   List<Map<String, String>> searchResults = [];
//   File? _image;

//   @override
//   void initState() {
//     super.initState();
//     // If an initial query is provided, automatically trigger the search
//     if (widget.initialQuery != null) {
//       _sendSearchQuery(widget.initialQuery!);
//     }
//   }

//   Future<void> _sendSearchQuery(String query) async {
//     setState(() {
//       searchResults.add({'sender': 'user', 'message': query});
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
//           searchResults.add({'sender': 'bot', 'message': botResponse});
//         });
//       } else {
//         setState(() {
//           searchResults.add({
//             'sender': 'bot',
//             'message': 'Error: Unable to fetch response from server.'
//           });
//         });
//       }
//     } catch (e) {
//       setState(() {
//         searchResults.add({
//           'sender': 'bot',
//           'message': 'Error: Failed to connect to the server.'
//         });
//       });
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         searchResults.add({'sender': 'user', 'message': '[Image uploaded]'});
//       });
//     }
//   }

//   void _clearChat() {
//     setState(() {
//       searchResults.clear(); // Clear searchResults instead of chatMessages
//     });
//   }

//   void _startNewChatSession() {
//     setState(() {
//       searchResults.clear(); // Clear searchResults to start a new session
//       sessionId = DateTime.now().millisecondsSinceEpoch.toString();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Discover'),
//         actions: [
//           IconButton(icon: Icon(Icons.add), onPressed: _startNewChatSession),
//           IconButton(icon: Icon(Icons.clear), onPressed: _clearChat),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: searchResults.length,
//               itemBuilder: (context, index) {
//                 final chat = searchResults[index];
//                 bool isUser = chat['sender'] == 'user';
//                 return Align(
//                   alignment:
//                       isUser ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: EdgeInsets.symmetric(vertical: 5),
//                     padding: EdgeInsets.all(10),
//                     constraints: BoxConstraints(
//                       maxWidth: MediaQuery.of(context).size.width * 0.7,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isUser ? Colors.blue : Colors.grey[850],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child:
//                         chat['message'] == '[Image uploaded]' && _image != null
//                             ? ConstrainedBox(
//                                 constraints: BoxConstraints(
//                                   maxHeight: 200, // Limit the image height
//                                 ),
//                                 child: Image.file(
//                                   _image!,
//                                   fit: BoxFit.cover,
//                                 ),
//                               )
//                             : Text(
//                                 chat['message']!,
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.image, color: Colors.white),
//                   onPressed: _pickImage,
//                 ),
//                 Expanded(
//                   child: TextField(
//                     controller: searchController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.grey[850],
//                       hintText: 'Search...',
//                       hintStyle: TextStyle(color: Colors.white70),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send, color: Colors.white),
//                   onPressed: () {
//                     _sendSearchQuery(searchController.text);
//                     searchController.clear();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
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
//             Navigator.pushReplacementNamed(context, '/home');
//           } else if (index == 1) {
//             // Already on Discover screen
//           } else if (index == 2) {
//             Navigator.pushReplacementNamed(context, '/library');
//           }
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DiscoverScreen extends StatefulWidget {
  final String? initialQuery;

  DiscoverScreen({this.initialQuery});

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  bool inChatMode = false;
  List<Map<String, String>> searchResults = [];
  File? _image;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      _sendSearchQuery(widget.initialQuery!);
    }
  }

  Future<void> _sendSearchQuery(String query) async {
    setState(() {
      searchResults.add({'sender': 'user', 'message': query});
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
          searchResults.add({'sender': 'bot', 'message': botResponse});
        });
      } else {
        setState(() {
          searchResults.add({
            'sender': 'bot',
            'message': 'Error: Unable to fetch response from server.'
          });
        });
      }
    } catch (e) {
      setState(() {
        searchResults.add({
          'sender': 'bot',
          'message': 'Error: Failed to connect to the server.'
        });
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        searchResults.add({'sender': 'user', 'message': '[Image uploaded]'});
      });
    }
  }

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> chatStrings = searchResults.map((chat) => jsonEncode(chat)).toList();
    await prefs.setStringList('chatHistory', chatStrings);
  }

  void _startNewChatSession() {
    setState(() {
      searchResults.clear();
    });
    _saveChatHistory(); // Save history
  }

  void _clearChat() {
    setState(() {
      searchResults.clear();
    });
    _saveChatHistory(); // Save history
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: _startNewChatSession),
          IconButton(icon: Icon(Icons.clear), onPressed: _clearChat),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final chat = searchResults[index];
                bool isUser = chat['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[850],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: chat['message'] == '[Image uploaded]' && _image != null
                        ? Image.file(_image!)
                        : Text(
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
                IconButton(
                  icon: Icon(Icons.image, color: Colors.white),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[850],
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    _sendSearchQuery(TextEditingController().text);
                  },
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
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Library'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
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
