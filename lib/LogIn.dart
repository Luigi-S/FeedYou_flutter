import 'package:feed_you_flutter/NewsList.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';

class LogIn extends StatefulWidget {

  @override
  _LogInState createState() => _LogInState();

}

class _LogInState extends State<LogIn> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
      
      body: SafeArea(
        child: Center(
          child: Column(children: [
            Image.asset(
                'images/logo.png',
                width: 120,
                height: 120,

            ),

            const Text(
              "Feed You",
              style: TextStyle(
                fontFamily: 'RockSalt',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF248b9c)
              ),
            ),

            const SizedBox(height: 30),

            const SizedBox(
              width: 290,
              child: Text(
              "Sign In",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Color(0xFF313131)
              ),
            ),
          ),

            const SizedBox(height: 20),

            const SizedBox(
              width: 290,
              child: Text(
                  "Hi there! Nice to see you again!",
                  style: TextStyle(
                  fontFamily: 'Asap',
                  fontSize: 16,
                  color: Color(0xFF232323)
              ),
            ),
          ),

            const SizedBox(height: 40),

             Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: TextField (
                    controller: _emailController,
                    decoration: const InputDecoration(
                      prefixIcon:  Icon(
                        Icons.email,
                        color: Color(0xFF248b9c)
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFF248b9c)
                        ),
                      ),
                      hintText: "E-mail",
                    ),
                  ),
                ),

            SizedBox(height: 35),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField (
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Color(0xFF248b9c)
                  ),
                  prefixIconColor: Color(0xFF248b9c),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF248b9c)),
                  ),
                  hintText: "Password",
                ),
              ),
            ),

            const SizedBox(height: 40),


            SizedBox(
              width: 290,

              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: Color(0xFF00c8f8),
                  ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                  onPressed: () => {
                    _simpleSignIn(context)
                  },
                  child: const Text('Sign In')
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "or use one of your social profiles",
              style: TextStyle(
                  fontFamily: 'Asap',
                  fontSize: 16,
                  color: Color(0xFF232323)
              ),
            ),

          ]
          ),
        )
      )
    );
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future _simpleSignIn(BuildContext context) async {

    var signInSnack;

    if(_emailController.text.isEmpty || _passwordController.text.isEmpty) {

      signInSnack = SnackBar(content: Text('Email and/or password missing'));
      ScaffoldMessenger.of(context).showSnackBar(signInSnack);

    } else {

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text
        );

        _emailController.text = "";
        _passwordController.text = "";

        signInSnack = SnackBar(content: Text('Login Successful'));
        ScaffoldMessenger.of(context).showSnackBar(signInSnack);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewsList()));

      } on FirebaseAuthException catch (e) {

        if (e.code == 'user-not-found') {
          signInSnack = SnackBar(content: Text('No user found for that email'));
          ScaffoldMessenger.of(context).showSnackBar(signInSnack);

        } else if (e.code == 'wrong-password') {
          signInSnack =
              SnackBar(content: Text('Wrong password provided for that user'));
          ScaffoldMessenger.of(context).showSnackBar(signInSnack);

        } else {
          signInSnack =
              SnackBar(content: Text('Someting went wrong, please try again'));
          ScaffoldMessenger.of(context).showSnackBar(signInSnack);
        }
      }
    }
  }



}