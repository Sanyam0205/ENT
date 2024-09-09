// // // import 'package:flutter/material.dart';
// // // import 'dart:convert';
// // // import 'package:http/http.dart' as http;
// // // import 'dart:io'; // Add this import statement
// // // import 'package:image_picker/image_picker.dart'; // Import for ImagePicker
// // // import 'package:file_picker/file_picker.dart'; // Import for FilePicker

// // // void main() {
// // //   runApp(MyApp());
// // // }

// // // class MyApp extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       title: 'Chatbot UI',
// // //       theme: ThemeData(
// // //         brightness: Brightness.dark,
// // //         primarySwatch: Colors.blue,
// // //         scaffoldBackgroundColor: Colors.black,
// // //       ),
// // //       home: ChatbotUI(),
// // //     );
// // //   }
// // // }

// // // class ChatbotUI extends StatefulWidget {
// // //   @override
// // //   _ChatbotUIState createState() => _ChatbotUIState();
// // // }

// // // class _ChatbotUIState extends State<ChatbotUI> {
// // //   bool focusEnabled = false;
// // //   String selectedFile = '';
// // //   List<Map<String, String>> chatMessages = []; // Chat messages
// // //   String sessionId = ''; // Add sessionId for handling chat sessions

// // //   TextEditingController searchController = TextEditingController();

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _startNewChatSession(); // Initialize with a new chat session
// // //   }

// // //   // This method sends the query to the Python backend and fetches the response
// // //   Future<void> _sendChatQuery(String query) async {
// // //     setState(() {
// // //       chatMessages.add({'sender': 'user', 'message': query});
// // //     });

// // //     final String apiUrl = "http://10.0.2.2:5000/ask";

// // //     try {
// // //       final response = await http.post(
// // //         Uri.parse(apiUrl),
// // //         headers: {
// // //           "Content-Type": "application/json",
// // //         },
// // //         body: jsonEncode({"question": query}),
// // //       );

// // //       if (response.statusCode == 200) {
// // //         final jsonResponse = jsonDecode(response.body);
// // //         String botResponse = jsonResponse['response'];

// // //         setState(() {
// // //           chatMessages.add({'sender': 'bot', 'message': botResponse});
// // //         });
// // //       } else {
// // //         setState(() {
// // //           chatMessages.add({
// // //             'sender': 'bot',
// // //             'message': 'Error: Unable to fetch response from server.'
// // //           });
// // //         });
// // //       }
// // //     } catch (e) {
// // //       setState(() {
// // //         chatMessages.add({
// // //           'sender': 'bot',
// // //           'message': 'Error: Failed to connect to the server.'
// // //         });
// // //       });
// // //     }
// // //   }

// // //   Future<void> _pickFile() async {
// // //     try {
// // //       // Show a bottom sheet with options
// // //       final option = await showModalBottomSheet<String>(
// // //         context: context,
// // //         builder: (BuildContext context) {
// // //           return Column(
// // //             mainAxisSize: MainAxisSize.min,
// // //             children: [
// // //               ListTile(
// // //                 leading: Icon(Icons.camera_alt),
// // //                 title: Text('Take a photo'),
// // //                 onTap: () => Navigator.pop(context, 'camera'),
// // //               ),
// // //               ListTile(
// // //                 leading: Icon(Icons.photo_library),
// // //                 title: Text('Choose from gallery'),
// // //                 onTap: () => Navigator.pop(context, 'gallery'),
// // //               ),
// // //               ListTile(
// // //                 leading: Icon(Icons.file_copy),
// // //                 title: Text('Choose a file'),
// // //                 onTap: () => Navigator.pop(context, 'file'),
// // //               ),
// // //             ],
// // //           );
// // //         },
// // //       );

// // //       if (option == null) return;

// // //       File? file;
// // //       final picker = ImagePicker();

// // //       switch (option) {
// // //         case 'camera':
// // //           final pickedFile = await picker.pickImage(source: ImageSource.camera);
// // //           if (pickedFile != null) file = File(pickedFile.path);
// // //           break;
// // //         case 'gallery':
// // //           final pickedFile =
// // //               await picker.pickImage(source: ImageSource.gallery);
// // //           if (pickedFile != null) file = File(pickedFile.path);
// // //           break;
// // //         case 'file':
// // //           final pickedFile =
// // //               await FilePicker.platform.pickFiles(type: FileType.image);
// // //           if (pickedFile != null) file = File(pickedFile.files.single.path!);
// // //           break;
// // //       }

// // //       if (file != null) {
// // //         // Send the file to the Flask API
// // //         await _uploadFile(file);
// // //       }
// // //     } catch (e) {
// // //       print('Error picking file: $e');
// // //     }
// // //   }

// // //   Future<void> _uploadFile(File file) async {
// // //     final String apiUrl =
// // //         "http://10.0.2.2:5000/ocr"; // Update to your API endpoint

// // //     try {
// // //       final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
// // //         ..files.add(await http.MultipartFile.fromPath('file', file.path));

// // //       final response = await request.send();

// // //       if (response.statusCode == 200) {
// // //         final responseBody = await response.stream.bytesToString();
// // //         final jsonResponse = jsonDecode(responseBody);
// // //         String ocrText = jsonResponse['text'];

// // //         setState(() {
// // //           chatMessages.add({'sender': 'bot', 'message': ocrText});
// // //         });
// // //       } else {
// // //         setState(() {
// // //           chatMessages.add({
// // //             'sender': 'bot',
// // //             'message': 'Error: Unable to fetch response from server.'
// // //           });
// // //         });
// // //       }
// // //     } catch (e) {
// // //       setState(() {
// // //         chatMessages.add({
// // //           'sender': 'bot',
// // //           'message': 'Error: Failed to connect to the server.'
// // //         });
// // //       });
// // //     }
// // //   }

// // //   // Method to clear the chat
// // //   void _clearChat() {
// // //     setState(() {
// // //       chatMessages.clear(); // Clear all chat messages
// // //     });
// // //   }

// // //   // Method to start a new chat session
// // //   void _startNewChatSession() {
// // //     setState(() {
// // //       chatMessages.clear(); // Clear chat messages
// // //       sessionId = DateTime.now()
// // //           .millisecondsSinceEpoch
// // //           .toString(); // Create a new session ID
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         elevation: 0,
// // //         backgroundColor: Colors.black,
// // //         title: Text(
// // //           'Mokshayani',
// // //           style: TextStyle(color: Colors.white),
// // //         ),
// // //         actions: [
// // //           IconButton(
// // //             icon: Icon(Icons.add), // New Chat button (+)
// // //             onPressed: _startNewChatSession, // Starts a new chat session
// // //           ),
// // //           IconButton(
// // //             icon: Icon(Icons.clear), // Clear Chat button
// // //             onPressed: _clearChat, // Clears the chat
// // //           ),
// // //           IconButton(
// // //             icon: Icon(Icons.person),
// // //             onPressed: () {},
// // //           ),
// // //         ],
// // //       ),
// // //       drawer: Drawer(
// // //         child: ListView(
// // //           padding: EdgeInsets.zero,
// // //           children: [
// // //             DrawerHeader(
// // //               decoration: BoxDecoration(color: Colors.blue),
// // //               child: Text(
// // //                 'Menu',
// // //                 style: TextStyle(color: Colors.white, fontSize: 24),
// // //               ),
// // //             ),
// // //             ListTile(
// // //               leading: Icon(Icons.home),
// // //               title: Text('Home'),
// // //               onTap: () {
// // //                 Navigator.pop(context); // Close the drawer
// // //               },
// // //             ),
// // //             ListTile(
// // //               leading: Icon(Icons.settings),
// // //               title: Text('Settings'),
// // //               onTap: () {
// // //                 Navigator.pop(context); // Close the drawer
// // //               },
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.center,
// // //           children: [
// // //             SizedBox(height: 20),
// // //             Center(
// // //               child: TextField(
// // //                 controller: searchController,
// // //                 onSubmitted:
// // //                     _sendChatQuery, // Sends the query when pressed "Enter"
// // //                 decoration: InputDecoration(
// // //                   filled: true,
// // //                   fillColor: Colors.grey[850],
// // //                   hintText: 'Ask anything...',
// // //                   hintStyle: TextStyle(color: Colors.white70),
// // //                   prefixIcon: Icon(Icons.search, color: Colors.white),
// // //                   suffixIcon: IconButton(
// // //                     icon: Icon(Icons.send, color: Colors.white),
// // //                     onPressed: () => _sendChatQuery(
// // //                         searchController.text), // Sends query when clicked
// // //                   ),
// // //                   border: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(30),
// // //                     borderSide: BorderSide.none,
// // //                   ),
// // //                 ),
// // //                 style: TextStyle(color: Colors.white),
// // //               ),
// // //             ),
// // //             SizedBox(height: 20),
// // //             Row(
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               children: [
// // //                 Text('Focus', style: TextStyle(color: Colors.white)),
// // //                 Switch(
// // //                   value: focusEnabled,
// // //                   onChanged: (bool value) {
// // //                     setState(() {
// // //                       focusEnabled = value;
// // //                     });
// // //                   },
// // //                   activeColor: Colors.blue,
// // //                 ),
// // //                 IconButton(
// // //                   icon: Icon(Icons.attach_file, color: Colors.white),
// // //                   onPressed: _pickFile,
// // //                 ),
// // //                 Icon(Icons.lock, color: Colors.white),
// // //               ],
// // //             ),
// // //             SizedBox(height: 20),
// // //             Expanded(
// // //               child: ListView.builder(
// // //                 itemCount: chatMessages.length,
// // //                 itemBuilder: (context, index) {
// // //                   final chat = chatMessages[index];
// // //                   bool isUser = chat['sender'] == 'user';
// // //                   return Align(
// // //                     alignment:
// // //                         isUser ? Alignment.centerRight : Alignment.centerLeft,
// // //                     child: Container(
// // //                       margin: EdgeInsets.symmetric(vertical: 5),
// // //                       padding: EdgeInsets.all(10),
// // //                       decoration: BoxDecoration(
// // //                         color: isUser ? Colors.blue : Colors.grey[850],
// // //                         borderRadius: BorderRadius.circular(10),
// // //                       ),
// // //                       child: Text(
// // //                         chat['message']!,
// // //                         style: TextStyle(color: Colors.white),
// // //                       ),
// // //                     ),
// // //                   );
// // //                 },
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //       bottomNavigationBar: BottomNavigationBar(
// // //         backgroundColor: Colors.black,
// // //         selectedItemColor: Colors.blue,
// // //         unselectedItemColor: Colors.white70,
// // //         items: const <BottomNavigationBarItem>[
// // //           BottomNavigationBarItem(
// // //             icon: Icon(Icons.home),
// // //             label: 'Home',
// // //           ),
// // //           BottomNavigationBarItem(
// // //             icon: Icon(Icons.search),
// // //             label: 'Discover',
// // //           ),
// // //           BottomNavigationBarItem(
// // //             icon: Icon(Icons.library_books),
// // //             label: 'Library',
// // //           ),
// // //         ],
// // //         onTap: (index) {
// // //           if (index == 0) {
// // //             ScaffoldMessenger.of(context).showSnackBar(
// // //               SnackBar(content: Text('Home clicked')),
// // //             );
// // //           } else if (index == 1) {
// // //             ScaffoldMessenger.of(context).showSnackBar(
// // //               SnackBar(content: Text('Discover clicked')),
// // //             );
// // //           } else if (index == 2) {
// // //             ScaffoldMessenger.of(context).showSnackBar(
// // //               SnackBar(content: Text('Library clicked')),
// // //             );
// // //           }
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'dart:io';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:file_picker/file_picker.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp(); // Initialize Firebase
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Chatbot UI',
// //       theme: ThemeData(
// //         brightness: Brightness.dark,
// //         primarySwatch: Colors.blue,
// //         scaffoldBackgroundColor: Colors.black,
// //       ),
// //       home: AuthenticationWrapper(), // Handle authentication
// //     );
// //   }
// // }

// // // Check if the user is signed in
// // class AuthenticationWrapper extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return StreamBuilder<User?>(
// //       stream: FirebaseAuth.instance.authStateChanges(),
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.active) {
// //           User? user = snapshot.data;
// //           if (user == null) {
// //             return SignInPage(); // User not signed in
// //           } else {
// //             return ChatbotUI(); // User signed in
// //           }
// //         } else {
// //           return Scaffold(
// //             body: Center(child: CircularProgressIndicator()),
// //           );
// //         }
// //       },
// //     );
// //   }
// // }

// // class SignInPage extends StatefulWidget {
// //   @override
// //   _SignInPageState createState() => _SignInPageState();
// // }

// // class _SignInPageState extends State<SignInPage> {
// //   TextEditingController emailController = TextEditingController();
// //   TextEditingController passwordController = TextEditingController();
// //   String errorMessage = '';

// //   Future<void> signInWithEmailPassword() async {
// //     try {
// //       await FirebaseAuth.instance.signInWithEmailAndPassword(
// //         email: emailController.text.trim(),
// //         password: passwordController.text.trim(),
// //       );
// //     } on FirebaseAuthException catch (e) {
// //       setState(() {
// //         errorMessage = e.message ?? 'An unknown error occurred';
// //       });
// //     }
// //   }

// //   Future<void> signUpWithEmailPassword() async {
// //     try {
// //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
// //         email: emailController.text.trim(),
// //         password: passwordController.text.trim(),
// //       );
// //     } on FirebaseAuthException catch (e) {
// //       setState(() {
// //         errorMessage = e.message ?? 'An unknown error occurred';
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Sign In")),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             TextField(
// //               controller: emailController,
// //               decoration: InputDecoration(labelText: 'Email'),
// //             ),
// //             TextField(
// //               controller: passwordController,
// //               decoration: InputDecoration(labelText: 'Password'),
// //               obscureText: true,
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: signInWithEmailPassword,
// //               child: Text('Sign In'),
// //             ),
// //             ElevatedButton(
// //               onPressed: signUpWithEmailPassword,
// //               child: Text('Sign Up'),
// //             ),
// //             if (errorMessage.isNotEmpty)
// //               Text(errorMessage, style: TextStyle(color: Colors.red)),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class ChatbotUI extends StatefulWidget {
// //   @override
// //   _ChatbotUIState createState() => _ChatbotUIState();
// // }

// // class _ChatbotUIState extends State<ChatbotUI> {
// //   bool focusEnabled = false;
// //   String selectedFile = '';
// //   List<Map<String, String>> chatMessages = [];
// //   String sessionId = '';

// //   TextEditingController searchController = TextEditingController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _startNewChatSession();
// //   }

// //   Future<void> _sendChatQuery(String query) async {
// //     setState(() {
// //       chatMessages.add({'sender': 'user', 'message': query});
// //     });

// //     final String apiUrl = "http://10.0.2.2:5000/ask";

// //     try {
// //       final response = await http.post(
// //         Uri.parse(apiUrl),
// //         headers: {
// //           "Content-Type": "application/json",
// //         },
// //         body: jsonEncode({"question": query}),
// //       );

// //       if (response.statusCode == 200) {
// //         final jsonResponse = jsonDecode(response.body);
// //         String botResponse = jsonResponse['response'];

// //         setState(() {
// //           chatMessages.add({'sender': 'bot', 'message': botResponse});
// //         });
// //       } else {
// //         setState(() {
// //           chatMessages.add({
// //             'sender': 'bot',
// //             'message': 'Error: Unable to fetch response from server.'
// //           });
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         chatMessages.add({
// //           'sender': 'bot',
// //           'message': 'Error: Failed to connect to the server.'
// //         });
// //       });
// //     }
// //   }

// //   Future<void> _pickFile() async {
// //     try {
// //       final option = await showModalBottomSheet<String>(
// //         context: context,
// //         builder: (BuildContext context) {
// //           return Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               ListTile(
// //                 leading: Icon(Icons.camera_alt),
// //                 title: Text('Take a photo'),
// //                 onTap: () => Navigator.pop(context, 'camera'),
// //               ),
// //               ListTile(
// //                 leading: Icon(Icons.photo_library),
// //                 title: Text('Choose from gallery'),
// //                 onTap: () => Navigator.pop(context, 'gallery'),
// //               ),
// //               ListTile(
// //                 leading: Icon(Icons.file_copy),
// //                 title: Text('Choose a file'),
// //                 onTap: () => Navigator.pop(context, 'file'),
// //               ),
// //             ],
// //           );
// //         },
// //       );

// //       if (option == null) return;

// //       File? file;
// //       final picker = ImagePicker();

// //       switch (option) {
// //         case 'camera':
// //           final pickedFile = await picker.pickImage(source: ImageSource.camera);
// //           if (pickedFile != null) file = File(pickedFile.path);
// //           break;
// //         case 'gallery':
// //           final pickedFile =
// //               await picker.pickImage(source: ImageSource.gallery);
// //           if (pickedFile != null) file = File(pickedFile.path);
// //           break;
// //         case 'file':
// //           final pickedFile =
// //               await FilePicker.platform.pickFiles(type: FileType.image);
// //           if (pickedFile != null) file = File(pickedFile.files.single.path!);
// //           break;
// //       }

// //       if (file != null) {
// //         await _uploadFile(file);
// //       }
// //     } catch (e) {
// //       print('Error picking file: $e');
// //     }
// //   }

// //   Future<void> _uploadFile(File file) async {
// //     final String apiUrl = "http://10.0.2.2:5000/ocr";

// //     try {
// //       final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
// //         ..files.add(await http.MultipartFile.fromPath('file', file.path));

// //       final response = await request.send();

// //       if (response.statusCode == 200) {
// //         final responseBody = await response.stream.bytesToString();
// //         final jsonResponse = jsonDecode(responseBody);
// //         String ocrText = jsonResponse['text'];

// //         setState(() {
// //           chatMessages.add({'sender': 'bot', 'message': ocrText});
// //         });
// //       } else {
// //         setState(() {
// //           chatMessages.add({
// //             'sender': 'bot',
// //             'message': 'Error: Unable to fetch response from server.'
// //           });
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         chatMessages.add({
// //           'sender': 'bot',
// //           'message': 'Error: Failed to connect to the server.'
// //         });
// //       });
// //     }
// //   }

// //   void _clearChat() {
// //     setState(() {
// //       chatMessages.clear();
// //     });
// //   }

// //   void _startNewChatSession() {
// //     setState(() {
// //       chatMessages.clear();
// //       sessionId = DateTime.now().millisecondsSinceEpoch.toString();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         elevation: 0,
// //         backgroundColor: Colors.black,
// //         title: Text('Mokshayani', style: TextStyle(color: Colors.white)),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.add),
// //             onPressed: _startNewChatSession,
// //           ),
// //           IconButton(
// //             icon: Icon(Icons.clear),
// //             onPressed: _clearChat,
// //           ),
// //           IconButton(
// //             icon: Icon(Icons.logout),
// //             onPressed: () async {
// //               await FirebaseAuth.instance.signOut();
// //             },
// //           ),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: ListView.builder(
// //               reverse: true,
// //               itemCount: chatMessages.length,
// //               itemBuilder: (context, index) {
// //                 final message = chatMessages[index];
// //                 final isUser = message['sender'] == 'user';
// //                 return Align(
// //                   alignment:
// //                       isUser ? Alignment.centerRight : Alignment.centerLeft,
// //                   child: Container(
// //                     margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// //                     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
// //                     decoration: BoxDecoration(
// //                       color: isUser ? Colors.blue : Colors.grey[800],
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     child: Text(message['message']!,
// //                         style: TextStyle(color: Colors.white)),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: TextField(
// //                     controller: searchController,
// //                     decoration: InputDecoration(
// //                       filled: true,
// //                       fillColor: Colors.white,
// //                       hintText: "Type a message...",
// //                       contentPadding: EdgeInsets.symmetric(horizontal: 16),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(24),
// //                         borderSide: BorderSide.none,
// //                       ),
// //                     ),
// //                     onChanged: (value) {
// //                       setState(() {
// //                         focusEnabled = value.isNotEmpty;
// //                       });
// //                     },
// //                   ),
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.send),
// //                   onPressed: focusEnabled
// //                       ? () => _sendChatQuery(searchController.text.trim())
// //                       : null,
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.attach_file),
// //                   onPressed: _pickFile,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mokshayani/screen/chat_screen.dart';
// import 'package:mokshayani/screen/login_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Chat App',
//       theme: ThemeData.dark(),
//       home: AuthenticationWrapper(),
//     );
//   }
// }

// class AuthenticationWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else if (snapshot.hasData) {
//           return ChatScreen();
//         } else {
//           return LoginScreen();
//         }
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mokshayani/screen/auth_service.dart';
import 'package:mokshayani/screen/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Chat',
      theme: ThemeData.dark(),
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => AuthScreen(),
        '/chat': (context) => ChatbotUI(),
      },
    );
  }
}
