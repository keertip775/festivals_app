import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(FestivalCountdownApp());
}

class FestivalCountdownApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: FestivalListScreen(),
    );
  }
}

class Festival {
  final String name;
  final DateTime date;
  final String image;

  Festival({required this.name, required this.date, required this.image});
}

class FestivalListScreen extends StatelessWidget {
  final List<Festival> festivals = [
    Festival(
        name: "Diwali",
        date: DateTime(2025, 10, 23),
        image: "assets/diwali.png"),
    Festival(
        name: "Christmas",
        date: DateTime(2025, 12, 25),
        image: "assets/christmas.png"),
    Festival(name: "Eid", date: DateTime(2025, 4, 21), image: "assets/eid.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Festival Countdown")),
      body: ListView.builder(
        itemCount: festivals.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CountdownScreen(festival: festivals[index]),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.asset(festivals[index].image,
                        height: 150, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      festivals[index].name,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CountdownScreen extends StatefulWidget {
  final Festival festival;
  CountdownScreen({required this.festival});

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late Timer _timer;
  Duration _timeLeft = Duration();

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      _timeLeft = widget.festival.date.difference(DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.festival.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${_timeLeft.inDays} Days \n${_timeLeft.inHours % 24} Hours \n${_timeLeft.inMinutes % 60} Minutes \n${_timeLeft.inSeconds % 60} Seconds",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Image.asset(widget.festival.image, height: 200, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}
