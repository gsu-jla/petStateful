import 'package:flutter/material.dart';
import 'dart:async';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> with WidgetsBindingObserver {
  String petName = "";
  bool isNameSet = false;
  int happinessLevel = 50;
  int hungerLevel = 50;
  Color backgroundColor = Colors.red;
  late Timer _hungerTimer;
  bool isGameOver = false;
  Timer? _happinessTimer;
  int _happyTimeElapsed = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    startHungerTimer();
    _startHappinessTracking();
  }

  void startHungerTimer() {
    
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 15).clamp(0, 100);
      });
    });
  }

  void _startHappinessTracking() {
    _happinessTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (happinessLevel >= 80) {
        setState(() {
          _happyTimeElapsed++;
          if (_happyTimeElapsed >= 180) { // 3 minutes = 180 seconds
            _showWinDialog();
            timer.cancel();
          }
        });
      } else {
        setState(() {
          _happyTimeElapsed = 0; // Reset if happiness drops below 80
        });
      }
      
      // Check loss condition
      if (hungerLevel >= 100 && happinessLevel <= 10) {
        setState(() {
          isGameOver = true;
          _showLoseDialog();
        });
        timer.cancel();
        _hungerTimer.cancel();
      }
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You\'ve kept your pet happy for 3 minutes! You\'re a great pet owner!'),
          actions: <Widget>[
            TextButton(
              child: Text('Start New Game'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLoseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Your pet is too hungry and unhappy! Try to take better care next time.'),
          actions: <Widget>[
            TextButton(
              child: Text('Try Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      happinessLevel = 50;
      hungerLevel = 50;
      isGameOver = false;
      _happyTimeElapsed = 0;
      backgroundColor = Colors.yellow;
    });
    _startHappinessTracking();
    startHungerTimer();
  }

  @override
  void dispose() {
    _happinessTimer?.cancel();
    _hungerTimer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
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
            Text(
              'Name: $petName',
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
            if (happinessLevel >= 80) Text(
              'Time at high happiness: ${(_happyTimeElapsed / 60).floor()}:${(_happyTimeElapsed % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 16.0, color: Colors.green),
            ),
            SizedBox(height: 32.0),
            if (!isGameOver) ...[
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
          ],
        ),
      ),
    );
  }
}