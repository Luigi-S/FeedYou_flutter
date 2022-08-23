import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChangePassword extends StatefulWidget {

  @override
  _ChangePasswordState createState() => _ChangePasswordState();

}

class _ChangePasswordState extends State<ChangePassword> {

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.teal),
          title: const Text(
              "Feed You",
              style: TextStyle(
                  fontFamily: 'RockSalt',
                  color: Colors.teal,
                  fontSize: 16.0
              )
          ),
        ),
        body: Column(
            children: [

              const SizedBox(height: 25),


              const Text(
                  "Change Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Color(0xFF313131)
                  ),
                ),

              const SizedBox(height: 20),

              const SizedBox(
                width: 250,
                child: Text(
                  "Password should contain at least: 6 characters length, 1 capital letter, 1 number, 1 special character.",
                  style: TextStyle(
                      fontFamily: 'Asap',
                      fontSize: 16,
                      color: Color(0xFF232323)
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: _oldPasswordController,
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
                    hintText: "Old Password",
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: _newPasswordController,
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
                    hintText: "New Password",
                  ),
                ),
              ),

              const SizedBox(height: 40),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: _confirmPasswordController,
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
                    hintText: "Confirm New Password",
                  ),
                ),
              ),

              const SizedBox(height: 30),


              SizedBox(
                width: 260,

                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: Color(0xFF00c8f8),
                    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    onPressed: () => {_changePassword(context)},
                    child: const Text('Change Password')
                ),
              ),

            ]
        )
    );
  }


  void _changePassword(BuildContext context) async {
    var changePasswordSnack;
    RegExp passwordRegex =
    RegExp(
        "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[{}@#\$%^&+=*?'_ç£!<>])(?=\\S+\$).{6,}\$");

    if (_oldPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty
        && _newPasswordController.text.isNotEmpty) {

      if (_newPasswordController.text == _confirmPasswordController.text) {

        if (passwordRegex.hasMatch(_newPasswordController.text)) {

          try {

            final credential = EmailAuthProvider.credential(
                email: FirebaseAuth.instance.currentUser!.email!,
                password: _oldPasswordController.text);

            await FirebaseAuth.instance.currentUser!
                .reauthenticateWithCredential(credential);

            await FirebaseAuth.instance.currentUser!.updatePassword(
                _newPasswordController.text);

            changePasswordSnack =
                SnackBar(content: const Text(
                    'Password Changed Successfully!'));
            ScaffoldMessenger.of(context).showSnackBar(changePasswordSnack);

            Navigator.pop(context);

          } on FirebaseAuthException catch (e) {
            switch (e.code) {
              case "wrong-password":
                changePasswordSnack =
                    SnackBar(content: const Text(
                        'Wrong old password'));
                ScaffoldMessenger.of(context).showSnackBar(changePasswordSnack);
                break;

              default:
                changePasswordSnack =
                    SnackBar(content: const Text(
                        'Something went wrong, please try again'));
                ScaffoldMessenger.of(context).showSnackBar(changePasswordSnack);
                break;
            }
          }

        } else {

          changePasswordSnack =
              SnackBar(content: const Text('New Password Too Weak'));
          ScaffoldMessenger.of(context).showSnackBar(changePasswordSnack);

          }

        } else {

          changePasswordSnack =
              SnackBar(content: const Text('Password Confirmation failed'));
          ScaffoldMessenger.of(context).showSnackBar(changePasswordSnack);

          }

      } else {

        changePasswordSnack =
            SnackBar(content: const Text('All fields required'));
        ScaffoldMessenger.of(context).showSnackBar(changePasswordSnack);

    }
  }
}