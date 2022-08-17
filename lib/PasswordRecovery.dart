import 'package:feed_you_flutter/NewsList.dart';
import 'package:feed_you_flutter/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordRecovery extends StatefulWidget {

  @override
  _PasswordRecoveryState createState() => _PasswordRecoveryState();

}

class _PasswordRecoveryState extends State<PasswordRecovery> {

  final _emailController = TextEditingController();

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
              "Password Recovery",
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
              "Forgot your Password? Enter your Email, we send you password reset!",
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

              const SizedBox(height: 20),

              SizedBox(
                width: 290,

                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: Color(0xFF00c8f8),
                    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    onPressed: () => {_passwordReset(context)},
                    child: const Text('Reset Password')
                ),
              ),

              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 65),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        "Have an Account?",
                        style: TextStyle(
                            fontFamily: 'Asap',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF232323)
                        ),
                      ),
                    ),

                    Expanded(
                        child: TextButton(
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                                fontFamily: 'Asap',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF248b9c)
                            ),
                          ),
                          onPressed: () => {Navigator.pop(context)},

                        )),

                  ],

                ),
              )

            ]
            )
          )
        )
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future _passwordReset(BuildContext context) async {
    var passwordResetSnack;

      if (!_emailController.text.isEmpty) {
        try {
          await FirebaseAuth.instance.sendPasswordResetEmail(
              email: _emailController.text);

          passwordResetSnack = SnackBar(content: Text(
              'password reset email sent successfully!'));
          ScaffoldMessenger.of(context).showSnackBar(passwordResetSnack);

          Navigator.pop(context);

        } on FirebaseAuthException catch (e) {
            switch(e.code) {
              case 'invalid-email':
                passwordResetSnack = SnackBar(content: Text(
                    'Invalid email'));
                ScaffoldMessenger.of(context).showSnackBar(passwordResetSnack);
                break;

              default:
                passwordResetSnack = SnackBar(content: Text(
                    'Something went wrong, please try again'));
                ScaffoldMessenger.of(context).showSnackBar(passwordResetSnack);
                break;
            }
        }

      } else {
        passwordResetSnack = SnackBar(content: Text(
            'email required'));
        ScaffoldMessenger.of(context).showSnackBar(passwordResetSnack);
      }

  }


}