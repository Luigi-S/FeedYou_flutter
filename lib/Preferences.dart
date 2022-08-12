
import 'package:feed_you_flutter/NewsList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Assets.dart';

class PreferencesView extends StatefulWidget {
  PreferencesView({Key? key}) : super(key: key);

  @override
  PreferencesViewState createState() => PreferencesViewState();
}

class PreferencesViewState extends State<PreferencesView> {
  String? lang;
  DropDown dropdown = DropDown();
  List<bool> checkedPrefs = [];

  @override
  Widget build(BuildContext context) {
    if(lang==null) {
      return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.teal),
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: const Text(
                    "Feed You",
                    style: TextStyle(
                        fontFamily: 'RockSalt',
                        color: Colors.teal,
                        fontSize: 20.0
                    )
                ),
              ),
              body:Padding(
               padding: const EdgeInsets.fromLTRB(4, 128, 4, 0),
               child: Center(
                   child: Column(
                       children: [
                         const Text("Select Language:"),
                         dropdown,
                         ElevatedButton(
                           onPressed: () {
                             _langSelected();
                           },
                           child: const Text('Continue'),
                         )
                       ]
                   )
               ),
              )
          )
      );
    }else{
      var topics = Assets().topics(lang!);
      for (int i =0; i<topics.length; i++) {
        checkedPrefs.add(false);
      }
      var checkboxes = Padding(
        padding: const EdgeInsets.fromLTRB(82, 8, 82, 8),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: topics.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                MyCheckBox(checkedPrefs: checkedPrefs, index: index),
                Text(topics[index])
              ],
            );
          })
        );

      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.teal),
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              "Feed You",
              style: TextStyle(
                  fontFamily: 'RockSalt',
                  color: Colors.teal,
                  fontSize: 20.0
              )
            ),
          ),
          body:Padding(
            padding: const EdgeInsets.fromLTRB(4, 64, 4, 0),
            child: Center(
              child: Column(
                children: [
                  const Text("Select the topics you're interested in"),
                  Align(alignment: Alignment.center,child: checkboxes),
                  ElevatedButton(
                    onPressed: () {
                      _topicsSelected();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Select the topics you're interested in"),
                      ));
                    },
                    child: const Text('Continue'),
                  )
                ],
              )
            )
          )
        )
      );
    }
  }

  void _langSelected(){
    setState(() {
      lang = dropdown.getValue();
    });
  }

  _topicsSelected() async {
    int numPrefs = 0;
    for(bool val in checkedPrefs){
      if(val){
        numPrefs++;
      }
    }
    if(numPrefs ==0){
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    //Calcolare le prefs
    double inTopic=0.0;
    double offTopic=0.0;
    if(numPrefs == checkedPrefs.length){
      inTopic = 1/numPrefs;
    }else{
      inTopic= 0.8/numPrefs;
      offTopic= 0.2/(checkedPrefs.length - numPrefs);
    }
    List<double> preferences = [];
    for(bool val in checkedPrefs){
      if(val){
        preferences.add(inTopic);
      }else{
        preferences.add(offTopic);
      }
    }
    prefs.clear();
    await prefs.setString('prefTopics', preferences.toString());
    await prefs.setString('lang', lang!);
    //vai a newslist
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewsList()));
  }

}


class DropDown extends StatefulWidget {
  DropDown({Key? key}) : super(key: key);
  _DropDownState? _state;

  String getValue(){
    return _state!.getValue();
  }

  @override
  _DropDownState createState() {
    _state = _DropDownState();
    return _state!;
  }
}

class _DropDownState extends State<DropDown> {
  String dropdownValue = 'it';

  String getValue(){
    return dropdownValue;
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black45),
      underline: Container(
        height: 2,
        color: Colors.black45,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: Assets().langs()
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(Assets().fullLangName(value), style: TextStyle(color: Colors.black45),),
        );
      }).toList(),
    );
  }
}

class MyCheckBox extends StatefulWidget{
  var index;
  var checkedPrefs;

  MyCheckBox({Key? key, required this.checkedPrefs, required this.index}) : super(key: key);

  @override
  State<MyCheckBox> createState() => _MyCheckBoxState(checkedPrefs, index);
}

class _MyCheckBoxState extends State<MyCheckBox>{
  final checkedPrefs;
  final index;
  bool isChecked = false;

  _MyCheckBoxState(this.checkedPrefs, this.index);

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.black45;
      }
      return Colors.teal;
    }
    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? val){
        if(val??false){
          checkedPrefs[index] = val!;
        }
        setState(() {
          isChecked = val!;
        });
      },
    );
  }
}