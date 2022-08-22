import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.teal),
          centerTitle: true,
          title:const Text(
            "Feed You",
            style: TextStyle(
              fontFamily: 'RockSalt',
              color: Colors.teal,
              fontSize: 16.0
            )
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: const [
              Center(
                  child:  Image(image: AssetImage('images/logo.png'),height: 100,width: 100)
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 10, 32, 10),
                child: Text("""Welcome to Feed You! v1.0\n\nThank you for joining us,\nFeed You is a simple app that will provide you with RSS Feeds coming from the most important international Newspapers.\n\nWe\'ll walk with you during your day, keeping you informed about what\'s happening meanwhile in the world, in accordance with your personal preferences and choices.\n\nOur main goal is to give to all of our users the best mobile reading experience."""),
              )
            ],
          ),
        ),
      
    );

  }
  
}