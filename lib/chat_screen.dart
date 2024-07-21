import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key? key,
    required this.text,
    required this.isFromUser,
  }) : super(key: key);

  final String text;
  final bool isFromUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isFromUser == true ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: 520),
            decoration: BoxDecoration(
              color: isFromUser == true ? Colors.black.withOpacity(0.4) : Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: isFromUser == true
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
            ),
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: EdgeInsets.all(12),
            child: MarkdownBody(data: text),
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
  @override
  void initState() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: 'AIzaSyC2o_WDKnc-7KIKJpVeZmyptL85XRO0H9o',
    );
    _chatSession = _model.startChat();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textFeildFocus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(300),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(50, 20, 0, 0),
                child: Row(
                  children: [
                    SizedBox(height: 180, width: 180, child: StackCircleWidget()),
                    Text(
                      'Hello, ${widget.name}',
                      style: TextStyle(fontFamily: 'Sathoshi', fontSize: 40),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 8, 9),
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
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        focusNode: _textFeildFocus,
                        controller: _textEditingController,
                        // onSubmitted: _sendChat,
                        decoration: textFieldDecoration(context),
                      ),
                    ),
                    SizedBox(width: 10),
                    isLoading == true
                        ? CircularProgressIndicator()
                        : TextButton(
                            onPressed: () {
                              _sendChat(_textEditingController.text);
                            },
                            child: Text(
                              'Send',
                              style: TextStyle(
                                fontFamily: 'Sathoshi',
                              ),
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

      print('Received response: $text');

      if (text != null) {
        setState(() {
          _scrollDown();
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error sending message: $e');
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
      duration: Duration(milliseconds: 300),
      curve: Curves.decelerate,
    );
  }

  InputDecoration textFieldDecoration(BuildContext context) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(15),
      hintText: 'Enter Message',
      hintStyle: TextStyle(
        fontFamily: 'Sathoshi',
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor, // Change border color when focused
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        borderSide: BorderSide(
          color: Colors.black, // Default border color
        ),
      ),
    );
  }
}

class StackCircleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 50,
          top: 40,
          child: CircleContainer(size: 50.0),
        ),
        Positioned(
          left: 5,
          top: 70,
          child: CircleContainer(size: 80.0),
        ),
        Positioned(
          left: 50,
          top: 60,
          child: CircleContainer(size: 110.0),
        ),
        // Positioned(
        //   left: 60,
        //   top: 260,
        //   child: CircleContainer(size: 140.0),
        // ),
        // Positioned(
        //   left: 10,
        //   top: 360,
        //   child: CircleContainer(size: 170.0),
        // ),
        // Positioned(
        //   left: 40,
        //   top: 480,
        //   child: CircleContainer(size: 200.0),
        // ),
      ],
    );
  }
}

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
      margin: EdgeInsets.all(10.0), // Adjust spacing between circles
    );
  }
}
