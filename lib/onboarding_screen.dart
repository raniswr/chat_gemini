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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF07a5fc),
        shape: const CircleBorder(),
        child: Image.asset(
          'assets/menu.png', // Path to your image
          fit: BoxFit.cover, // Adjust as needed
          height: 40,
        ),
      ),
      backgroundColor: const Color(0xFF14151b),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              'Welcome Back!',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 30),
            Image.asset(
              'assets/logo.png',
              fit: BoxFit.cover,
              height: 300,
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: const Center(
                    child: Text(
                      'What can I do for you?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: const Text(
                    textAlign: TextAlign.center,
                    'You can ask questions and receive articles using an artificial intelligence assistant',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  margin: const EdgeInsets.only(top: 10),
                  child: TextField(
                    autofocus: true,
                    controller: textName,
                    decoration: textFieldDecoration(context),
                    style: const TextStyle(
                      color: Colors.white, // Color for the text input
                      fontFamily: 'Poppins',
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
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
                    child: const Text('Start Chat', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration textFieldDecoration(BuildContext context) {
  return const InputDecoration(
    contentPadding: EdgeInsets.all(15),
    hintText: 'Input your name...',
    hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Colors.white),
    filled: true, // To apply the fillColor
    fillColor: Color(0xFF2c2b30), // Background color of the TextField

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
      borderSide: BorderSide(
        color: Colors.white, // Border color when focused
        width: 2.0, // Border width when focused
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
