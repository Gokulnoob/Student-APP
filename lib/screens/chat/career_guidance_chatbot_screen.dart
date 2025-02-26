import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:student_event_management/widgets/chattheme.dart';
import 'package:student_event_management/widgets/typing_indicator.dart';

class CareerGuidanceChatbotScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  CareerGuidanceChatbotScreen({required this.userData});

  @override
  _CareerGuidanceChatbotScreenState createState() =>
      _CareerGuidanceChatbotScreenState();
}

class _CareerGuidanceChatbotScreenState
    extends State<CareerGuidanceChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final String _apiKey =
      'AIzaSyCK9IpKkC0KTGu4_tLP_149amU0UQT1ARY'; // Replace with actual API key
  bool _isTyping = false;
  bool _isPressed = false;

  final String initialInstructions = '''
  I am a AI-powered chatbot for career guidance. Here is the user profile data:
  Name: {name}
  Department: {dept}
  Skill: {skill}
  Interest: {interest}
  Bio: {bio}
  Based on this information, provide career guidance and suggest skills to learn for the future.
  ''';

  @override
  void initState() {
    super.initState();
    _sendMessage(initialInstructions.replaceAllMapped(
      RegExp(r'\{(\w+)\}'),
      (match) => widget.userData[match[1]] ?? '',
    ));
  }

  Future<void> _sendMessage(String message) async {
    setState(() {
      _messages.add({'sender': 'user', 'message': message});
      _isTyping = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey'), // Replace 'valid-model-name' with the actual model name
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'contents': [
            {
              'parts': [
                {'text': message}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final responseText =
            data['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          _messages.add({'sender': 'bot', 'message': responseText});
          _isTyping = false;
        });
      } else {
        setState(() {
          _messages.add({
            'sender': 'bot',
            'message': 'Error: ${response.statusCode} - ${response.body}'
          });
          _isTyping = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'sender': 'bot', 'message': 'Connection Error: $e'});
        _isTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Career Guidance Chatbot',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
      ),
      body: Container(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TypingIndicator(),
                    );
                  }
                  final message = _messages[index];
                  return Align(
                    alignment: message['sender'] == 'user'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: AnimatedSize(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Container(
                        decoration: BoxDecoration(
                          color: message['sender'] == 'user'
                              ? AppTheme.blue.withOpacity(0.1)
                              : AppTheme.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (message['sender'] == 'bot')
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: AppTheme.lottieIcon,
                              ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: message['sender'] == 'user'
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message['message']!,
                                    style:
                                        AppTheme.lightTheme.textTheme.bodyLarge,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    message['sender']!,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                    child: Container(
                      decoration: AppTheme.neumorphismDecoration,
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Ask about careers...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppTheme.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTapDown: (_) => setState(() => _isPressed = true),
                    onTapUp: (_) => setState(() => _isPressed = false),
                    onTapCancel: () => setState(() => _isPressed = false),
                    onTap: () {
                      final message = _controller.text;
                      if (message.isNotEmpty) {
                        _sendMessage(message);
                        _controller.clear();
                      }
                    },
                    child: AnimatedScale(
                      scale: _isPressed ? 0.9 : 1.0,
                      duration: Duration(milliseconds: 100),
                      child: Container(
                        decoration: AppTheme.neumorphismDecoration,
                        child: Icon(
                          Icons.send,
                          color: AppTheme.buttonColor,
                          size: 30,
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
