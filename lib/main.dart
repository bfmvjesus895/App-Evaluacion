import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jose Eduardo Zacarias Rodriguez',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentTime = '';
  String _currentDate = '';
  String _weatherDescription = '';
  double _temperature = 0.0;
  String _location = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _fetchWeatherData();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      _currentDate = DateFormat('MMM d, y').format(DateTime.now());
    });
    Future.delayed(Duration(seconds: 1), _updateTime);
  }

  Future<void> _fetchWeatherData() async {
    final apiKey = 'c81d46b4c863da22daed4b1c6b3430a2';
    final city = 'Mexico City';

    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final weatherData = jsonDecode(response.body);
      final weatherDescription = weatherData['weather'][0]['description'];
      final temperature = weatherData['main']['temp'];
      final location = weatherData['name'];

      setState(() {
        _weatherDescription = weatherDescription;
        _temperature = temperature;
        _location = location;
      });
    } else {
      setState(() {
        _weatherDescription = 'Error al obtener el clima';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              _currentDate,
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 5),
            Text(
              '${_temperature.toStringAsFixed(1)}°C',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 15),
            Text(
              _currentTime,
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _location,
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 5),
            Text(
              _weatherDescription,
              style: TextStyle(fontSize: 8),
            ),
          ],
        ),
      ),
    );
  }
}
