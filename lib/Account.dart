import 'package:feed_you_flutter/ChangePassword.dart';
import 'package:feed_you_flutter/LogIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: TextButton(
                    onPressed: null,
                    child: Row(
                      children: const [
                        Icon(Icons.email_outlined, color: Colors.teal,),
                        Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Text(
                              "Email", style: TextStyle(color: Colors.teal),)
                        )
                      ],
                    ),
                  )
              ),

              Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: SizedBox(
                      width: 360,
                      child: Text(
                          FirebaseAuth.instance.currentUser!.email.toString(),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontFamily: 'Asap',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF313131)
                          )
                      )
                  )
              ),

              Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: TextButton(
                    onPressed: () {_changePassword(context);},
                    child: Row(
                      children: const [
                        Icon(Icons.password, color: Colors.teal,),
                        Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Text("Change Password",
                              style: TextStyle(color: Colors.teal),)
                        )
                      ],
                    ),
                  )
              ),

              Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: TextButton(
                    onPressed: () {
                      _showDeleteAlert(context);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.delete_forever_outlined, color: Colors.red,),
                        Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Text("Delete Account",
                              style: TextStyle(color: Colors.red),)
                        )
                      ],
                    ),
                  )
              ),

            ]


        )
    );
  }

  Future _deleteAccount(BuildContext context) async {
    var accountSnack;

    try {
      await FirebaseAuth.instance.currentUser!.delete();
      accountSnack =
          const SnackBar(content: Text('Account deleted successfully, bye!'));
      ScaffoldMessenger.of(context).showSnackBar(accountSnack);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
            (Route<dynamic> route) => false,
      );

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        default:
          accountSnack =
              const SnackBar(content: Text('Someting went wrong, please try again'));
          ScaffoldMessenger.of(context).showSnackBar(accountSnack);
          break;
      }
    }
  }

  void _changePassword(BuildContext context) {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePassword(),
    ));

  }


  void _showDeleteAlert(BuildContext context) {
    Widget deleteButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        _deleteAccount(context);
      Navigator.of(context).pop();
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Image.asset(
        'images/logo.png',
        width: 100,
        height: 100,

      ),
      content: const Text(
          "Are you sure you want to delete your Account? Operation cannot be undone!",
            style: TextStyle(
            fontFamily: 'Asap',
            fontSize: 16,
            color: Color(0xFF232323)
        ),
      ),
      actions: [
        cancelButton,
        deleteButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
