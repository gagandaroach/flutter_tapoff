import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TapOff',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tap Off Home Page'),
    );
  }
}

class ColorButton extends StatelessWidget {
  final int counter;
  final VoidCallback onPressed;
  final Color color;
  final String player;

  const ColorButton({
    super.key,
    required this.counter,
    required this.onPressed,
    required this.color,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, double.infinity),
      ),
      onPressed: onPressed,
      child: Text(
        '$player\n$counter',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? _timer;
  int _centerCounter = 0;
  int _buttonCounter1 = 0;
  int _buttonCounter2 = 0;
  final int _winCount = 5;
  String _winner = '';

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      if (_buttonCounter1 < _winCount && _buttonCounter2 < _winCount) {
        setState(() {
          _centerCounter++;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _winner = _buttonCounter1 >= _winCount ? 'Player 1 Wins!' : 'Player 2 Wins!';
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap Off'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ColorButton(
              counter: _buttonCounter1,
              color: Colors.blue,
              player: 'Player 1',
              onPressed: () {
                if (_buttonCounter1 < _winCount && _winner.isEmpty) {
                  setState(() {
                    _buttonCounter1++;
                    if (_buttonCounter1 >= _winCount) {
                      _winner = 'Player 1 Wins!';
                      _timer?.cancel();
                    }
                  });
                }
              },
            ),
          ),
          if (_winner.isNotEmpty)
            Text(
              _winner,
              style: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          if (_winner.isEmpty)
            Text(
              'Timer: $_centerCounter ms',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          Expanded(
            flex: 1,
            child: ColorButton(
              counter: _buttonCounter2,
              color: Colors.red,
              player: 'Player 2',
              onPressed: () {
                if (_buttonCounter2 < _winCount && _winner.isEmpty) {
                  setState(() {
                    _buttonCounter2++;
                    if (_buttonCounter2 >= _winCount) {
                      _winner = 'Player 2 Wins!';
                      _timer?.cancel();
                    }
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
