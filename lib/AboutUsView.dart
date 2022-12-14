import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: DraggableScrollableSheet(
            minChildSize: 0,
            maxChildSize: 1,
            initialChildSize: 1,
            builder: (context, scrollController) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {

            return Column(
            children: const [
              Center(
                  child:  Image(image: AssetImage('images/logo.png'),height: 100,width: 100)
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 10, 32, 10),
                child: Text("""Welcome to Feed You! v1.0\n\nThank you for joining us,\nFeed You is a simple app that will provide you with RSS Feeds coming from the most important international Newspapers.\n\nWe\'ll walk with you during your day, keeping you informed about what\'s happening meanwhile in the world, in accordance with your personal preferences and choices.\n\nOur main goal is to give to all of our users the best mobile reading experience."""),
              )
            ],
            );
            }
          );
            }
        )
      )
    );
  }
  
}