import 'package:feed_you_flutter/NewsList.dart';
import 'package:feed_you_flutter/PasswordRecovery.dart';
import 'package:feed_you_flutter/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

            const SizedBox(height: 40),

            const Text(
              "Sign In",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Color(0xFF313131)
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Hi there! Nice to see you again!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Asap',
                  fontSize: 16,
                  color: Color(0xFF232323)
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

            const SizedBox(height: 15),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 50),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  const Expanded(
                      child: Text(
                          "or continue without an account",
                          style: TextStyle(
                              fontFamily: 'Asap',
                              fontSize: 16,
                              color: Color(0xFF232323)
                          ),
                        ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                      child: ElevatedButton.icon(
                        label: const Text("Anonymous"),
                        icon: const Icon(Icons.account_circle),
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Color(0xFF313131),
                        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                        onPressed: () => {_anonymousSignIn(context)},
                  )),
                ],
              ),
            ),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 35),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: TextButton(
                        child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                            fontFamily: 'Asap',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF232323)
                          ),
                        ),
                      onPressed: () => {_passwordRecover(context)},

                    )),


                  Expanded(
                      child: TextButton(
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontFamily: 'Asap',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF248b9c)
                          ),
                        ),
                        onPressed: () => {_signUp(context)},

                      )),

              ],

          ),
        )
      ])
    )));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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

        DatabaseReference? refLang = FirebaseAuth.instance.currentUser?.uid != null ?
          FirebaseDatabase.instance.ref("users/${FirebaseAuth.instance.currentUser!.uid}/lang") :
          null;
        DatabaseReference? refTopics = FirebaseAuth.instance.currentUser?.uid != null ?
          FirebaseDatabase.instance.ref("users/${FirebaseAuth.instance.currentUser!.uid}/topics") :
          null;
        if(refLang != null && refTopics != null){
          String? lang;
          String? topics;
          refLang.onValue.listen((DatabaseEvent event) {
            lang = event.snapshot.value as String;
          });
          refTopics.onValue.listen((DatabaseEvent event) {
            topics = event.snapshot.value.toString();
          });
          if(lang != null && topics != null){
            setSharedPrefs(topics!,lang!);
          }
        }

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewsList()));

      } on FirebaseAuthException catch (e) {
        switch(e.code) {

          case 'user-not-found':
            signInSnack = SnackBar(content: Text('No user found for that email'));
            ScaffoldMessenger.of(context).showSnackBar(signInSnack);
            break;

          case 'wrong-password':
            signInSnack = SnackBar(content: Text('Wrong password provided for that user'));
            ScaffoldMessenger.of(context).showSnackBar(signInSnack);
            break;

          default:
            signInSnack = SnackBar(content: Text('Someting went wrong, please try again'));
            ScaffoldMessenger.of(context).showSnackBar(signInSnack);
            break;
        }
      }
    }
  }

  void _passwordRecover(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PasswordRecovery()));
  }

  void _signUp(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUp()));
  }

  Future _anonymousSignIn(BuildContext context) async {
    var signInSnack;

    try {

      await FirebaseAuth.instance.signInAnonymously();
      signInSnack = SnackBar(content: Text('Login Successful'));
      ScaffoldMessenger.of(context).showSnackBar(signInSnack);

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewsList()));

    } on FirebaseAuthException catch (e) {

      switch (e.code) {

        default:
          signInSnack = SnackBar(content: Text('Someting went wrong, please try again'));
          ScaffoldMessenger.of(context).showSnackBar(signInSnack);
          break;
      }
    }
  }

  setSharedPrefs(String preferences, String lang) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await prefs.setString('prefTopics', preferences);
    await prefs.setString('lang', lang);
  }
}