import 'package:feed_you_flutter/Account.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignUp extends StatefulWidget {

  @override
  _SignUpState createState() => _SignUpState();

}



class _SignUpState extends State<SignUp> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _checked = false;

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
                  "Sign Up",
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
                  "Hi there! First time here?",
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

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),

                child: CheckboxListTile(
                  title: const Text(
                    "I agree to the Terms of Services and Privacy Policy.",
                    style: TextStyle(
                        fontFamily: 'Asap',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF232323)
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.platform,
                  value: _checked,
                  onChanged: (bool? value) {
                    setState(() {
                      _checked = value!;
                    });
                  },
                  activeColor: Color(0xFF248b9c),
                  checkColor: Colors.white,

                )
              ),

              SizedBox(height: 15),

              SizedBox(
                width: 290,

                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: Color(0xFF00c8f8),
                    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    onPressed: () => {_signUp(context)},
                    child: const Text('Sign Up')
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
          ],
        ),
        )));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future _signUp(BuildContext context) async {
    var signUpSnack;
    RegExp passwordRegex =
    RegExp("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[{}@#\$%^&+=*?'_ç£!<>])(?=\\S+\$).{6,}\$");

    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      if (_checked) {
        if (passwordRegex.hasMatch(_passwordController.text)) {

          if(FirebaseAuth.instance.currentUser == null) {

            _createAccount(_emailController.text, _passwordController.text);

          } else {

            _linkAnonymous(_emailController.text, _passwordController.text);

          }

        } else {
            signUpSnack = const SnackBar(content: Text(
                'Password too Weak'));
            ScaffoldMessenger.of(context).showSnackBar(signUpSnack);
          }
      } else {
        signUpSnack = const SnackBar(content: Text(
            'You must accept terms and policy'));
        ScaffoldMessenger.of(context).showSnackBar(signUpSnack);
      }
    } else {
      signUpSnack = const SnackBar(content: Text(
          'email and/or password missing'));
      ScaffoldMessenger.of(context).showSnackBar(signUpSnack);
    }
  }

  Future _createAccount(String email, String password) async {

    var signUpSnack;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      signUpSnack = const SnackBar(content: Text(
          'Account created Successfully!'));
      ScaffoldMessenger.of(context).showSnackBar(signUpSnack);

      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          signUpSnack = const SnackBar(content: Text(
              'Invalid email'));
          ScaffoldMessenger.of(context).showSnackBar(signUpSnack);
          break;

        case 'email-already-in-use':
          signUpSnack = const SnackBar(content: Text(
              'The account already exists for that email'));
          ScaffoldMessenger.of(context).showSnackBar(signUpSnack);
          break;

        default:
          signUpSnack = const SnackBar(content: Text(
              'Something went wrong, please try again'));
          ScaffoldMessenger.of(context).showSnackBar(signUpSnack);
          break;
      }
    }
  }

  Future _linkAnonymous(String email, String password) async {

    var linkSnack;

    final credential = EmailAuthProvider.credential(
        email: _emailController.text,
        password: _passwordController.text);

    try {
      await FirebaseAuth.instance.currentUser!.linkWithCredential(credential);

      linkSnack = const SnackBar(content: Text(
          'Account linked Successfully!'));
      ScaffoldMessenger.of(context).showSnackBar(linkSnack);

      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Account()),
      );

    } on FirebaseAuthException catch (e) {
      switch (e.code) {

        case "provider-already-linked":
          linkSnack = const SnackBar(content: Text(
              'Email/password Account already linked'));
          ScaffoldMessenger.of(context).showSnackBar(linkSnack);
          break;

        case "invalid-credential":
          linkSnack = const SnackBar(content: Text(
              'Invalid credential'));
          ScaffoldMessenger.of(context).showSnackBar(linkSnack);
          break;

          case "credential-already-in-use":
            linkSnack = const SnackBar(content: Text(
            'The account corresponding to the credential already exists, or is already linked to a Firebase User.'));
            ScaffoldMessenger.of(context).showSnackBar(linkSnack);
            break;

        default:
          linkSnack = const SnackBar(content: Text(
              'Something went wrong, please try again'));
          ScaffoldMessenger.of(context).showSnackBar(linkSnack);
          break;
      }
    }

  }


}