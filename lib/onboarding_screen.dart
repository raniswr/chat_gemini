import 'package:chat_gemini/chat_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<OnboardingScreen> {
  TextEditingController textName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(50, 100, 50, 100),
          height: 300,
          width: 500,
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(30),
                topEnd: Radius.circular(30),
                bottomEnd: Radius.circular(30),
                bottomStart: Radius.circular(30),
              ),
              color: Colors.white),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Text(
                    ' Input your name',
                    style: TextStyle(fontFamily: 'Sathoshi', fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  margin: EdgeInsets.only(top: 10),
                  child: TextField(
                    autofocus: true,
                    controller: textName,
                    decoration: textFieldDecoration(context),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            name: textName.text,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      // primary: Colors.blue, // Background color
                      // onPrimary: Colors.white, // Text color
                      backgroundColor: Colors.black,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0), // Rounded corners
                      ),
                    ),
                    child: Text('Start Here', style: TextStyle(color: Colors.white, fontFamily: 'Sathoshi', fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration textFieldDecoration(BuildContext context) {
  return InputDecoration(
    contentPadding: EdgeInsets.all(15),
    hintText: 'Input your name...',
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
