//import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "";
  bool isNameSet = false;
  int happinessLevel = 50;
  int hungerLevel = 50;
  Color backgroundColor = Colors.red;

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _setPetEmotion();
      _updateHunger();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _setPetEmotion();
    });
  }
  void _setPetEmotion() {
    setState(() {
      if (happinessLevel > 70) {
        backgroundColor = Colors.green;
      } else if (happinessLevel < 30) {
        backgroundColor = Colors.red;
      } else {
        backgroundColor = Colors.yellow;
      }
    });
  }
  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
    _updateMood;
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  // changing mood text
  String mood = "Neutral";
  void _updateMood() {
    setState(() {
    if (happinessLevel < 30) {
      mood.replaceAll("Neutral","Unhappy");
      mood = "Unhappy";
    } else if (happinessLevel > 70){
      mood.replaceAll("Neutral","Happy");
    } else {
      mood.replaceAll("Happy","Neutral");
      mood.replaceAll("Unhappy","Neutral");
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: !isNameSet ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter Pet Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      petName = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: petName.isEmpty ? null : () {
                setState(() {
                  isNameSet = true;
                });
              },
              child: Text('Confirm Name'),
            ),
          ],
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/pic/dog_pic.jpg'
            ),
            Text(
              'Name: $petName ($mood)',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}