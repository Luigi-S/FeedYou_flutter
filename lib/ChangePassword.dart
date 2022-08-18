import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChangePassword extends StatelessWidget {

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();


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
                  fontSize: 20.0
              )
          ),
        ),
        body: Column(
            children: [

              const SizedBox(height: 25),


              const SizedBox(
                width: 290,
                child: Text(
                  "Change Password",
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
                  controller: _oldPasswordController ,
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
                  controller: _newPasswordController ,
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
                  controller: _confirmPasswordController ,
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
                width: 290,

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


  Future _changePassword(BuildContext context) async {

    var changePasswordSnack;
    final credential = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: _oldPasswordController.text);

    if(_oldPasswordController.text.isEmpty || _confirmPasswordController.text.isEmpty
    || _newPasswordController.text.isEmpty) {

      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential).then((_) async {

            if (_newPasswordController.text == _confirmPasswordController.text) {

              await FirebaseAuth.instance.currentUser!.updatePassword(
                  _newPasswordController.text);

        } else {

          changePasswordSnack =
              SnackBar(content: const Text('Password Confirmation failed'));
              ScaffoldMessenger.of(context).showSnackBar(changePasswordSnack);
        }
      }).catchError((error) {
        changePasswordSnack = SnackBar(content: const Text('Wrong old password'));
        ScaffoldMessenger.of(context).showSnackBar(changePasswordSnack);
      });

    } else {

      changePasswordSnack = SnackBar(content: const Text('All fields required'));
      ScaffoldMessenger.of(context).showSnackBar(changePasswordSnack);

    }


  }


}