import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({
    Key? key,
    required this.text,
    required this.isFromUser,
  }) : super(key: key);

  final String text;
  final bool isFromUser;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.isFromUser == true ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            decoration: BoxDecoration(
              color: widget.isFromUser == true ? Colors.white : Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(12),
            child: MarkdownBody(data: widget.text),
          ),
        ),
      ],
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _textFeildFocus = FocusNode();
  final ScrollController _scroll = ScrollController();
  bool? isLoading;
  bool _speechEnabled = false;
  String _lastWords = '';
  final SpeechToText _speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: 'AIzaSyC2o_WDKnc-7KIKJpVeZmyptL85XRO0H9o',
    );
    _chatSession = _model.startChat();
    _initSpeech();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textFeildFocus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize();
      setState(() {});
    } catch (e) {
      log('Error initializing speech recognition: $e');
    }
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      if (_lastWords != '') {
        _textEditingController.text = _lastWords;
      }
    });
  }

  void _toggleListening() {
    if (_speechToText.isNotListening) {
      _startListening();
    } else {
      _stopListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(300),
            ),
            color: Color(0xFF14151b),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/logo.png', // Path to your image
                      fit: BoxFit.cover, // Adjust as needed
                      height: 50,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Hello, ${widget.name}',
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 20,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 8, 9),
                  child: ListView.builder(
                    controller: _scroll,
                    itemCount: _chatSession.history.length,
                    itemBuilder: (context, index) {
                      final content = _chatSession.history.toList()[index];
                      final text = content.parts.whereType<TextPart>().map<String>((e) => e.text).join('');
                      bool isFromUser = content.role == 'user' ? true : false;
                      return MessageWidget(
                        text: text,
                        isFromUser: isFromUser,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        focusNode: _textFeildFocus,
                        controller: _textEditingController,
                        // onSubmitted: _sendChat,
                        style: const TextStyle(
                          color: Colors.white, // Color for the text input
                          fontFamily: 'Poppins',
                          fontSize: 15,
                        ),
                        decoration: textFieldDecoration(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _speechEnabled ? _toggleListening : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _speechToText.isListening ? Colors.grey.withOpacity(0.2) : const Color(0xFF14151b),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _speechToText.isListening ? Colors.grey.withOpacity(0.2) : const Color(0xFF14151b),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(
                            'assets/microphone.png', // Path to your image

                            fit: BoxFit.cover, // Adjust as needed
                            height: 30,
                          ),
                        ),
                      ),
                    ),
                    isLoading == true
                        ? const CircularProgressIndicator()
                        : GestureDetector(
                            onTap: () {
                              _sendChat(_textEditingController.text);
                            },
                            child: Image.asset(
                              'assets/send.png', // Path to your image

                              fit: BoxFit.cover, // Adjust as needed
                              height: 30,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _sendChat(String message) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await _chatSession.sendMessage(Content.text(message));
      final text = response.text;

      log('Received response: $text');

      if (text != null) {
        setState(() {
          _scrollDown();
          isLoading = false;
        });
      }
    } catch (e) {
      log('Error sending message: $e');
      setState(() {
        isLoading = false;
      });
    } finally {
      _textEditingController.clear();
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollDown() {
    _scroll.animateTo(
      _scroll.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.decelerate,
    );
  }

  InputDecoration textFieldDecoration(BuildContext context) {
    return const InputDecoration(
      contentPadding: EdgeInsets.all(15),
      hintText: 'Enter Message',
      hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Colors.white),
      filled: true,
      fillColor: Color(0xFF2c2b30),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        borderSide: BorderSide(
          color: Colors.white,
          width: 2.0,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        borderSide: BorderSide(
          color: Colors.white, // Border color when not focused
          width: 1.0, // Border width when not focused
        ),
      ),
      // Optionally customize the error border if you want to
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        borderSide: BorderSide(
          color: Colors.red, // Border color when there's an error
          width: 1.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        borderSide: BorderSide(
          color: Colors.red, // Border color when focused and there's an error
          width: 2.0,
        ),
      ),
    );
  }
}

// class StackCircleWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Positioned(
//           left: 50,
//           top: 40,
//           child: CircleContainer(size: 50.0),
//         ),
//         Positioned(
//           left: 5,
//           top: 70,
//           child: CircleContainer(size: 80.0),
//         ),
//         Positioned(
//           left: 50,
//           top: 60,
//           child: CircleContainer(size: 110.0),
//         ),
//         // Positioned(
//         //   left: 60,
//         //   top: 260,
//         //   child: CircleContainer(size: 140.0),
//         // ),
//         // Positioned(
//         //   left: 10,
//         //   top: 360,
//         //   child: CircleContainer(size: 170.0),
//         // ),
//         // Positioned(
//         //   left: 40,
//         //   top: 480,
//         //   child: CircleContainer(size: 200.0),
//         // ),
//       ],
//     );
//   }
// }

class CircleContainer extends StatelessWidget {
  final double size;

  const CircleContainer({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.3), // Change color as desired
      ),
      margin: const EdgeInsets.all(10.0), // Adjust spacing between circles
    );
  }
}
