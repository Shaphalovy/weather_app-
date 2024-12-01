import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => new _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityName = "";
  String weatherInfo = "Enter a city to get weather details";
  String iconCode = "";
  String iconUrl = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                elevation: 5,
                shadowColor: Colors.blue,
                child: TextField(
                  onChanged: (value) {
                    cityName = value;
                  },
                  decoration: const InputDecoration(
                      labelText: "City Name",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: Colors.blue,
                      )),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (cityName.isNotEmpty) {
                        fetchWeather(cityName);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Enter a valid city'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    side: const BorderSide(color: Colors.blue),
                  ),
                  child: const Text(
                    "Get Weather",
                    style: TextStyle(color: Colors.blue),
                  )),

              const SizedBox(height: 32),

              // Weather Info and Icon Display in One Card

              Card(
                color: Colors.lightBlueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      // Weather Info Text
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          weatherInfo,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),

                      const SizedBox(height: 16), // Space between weather info and icon

                      // Weather Icon Display
                      if (iconUrl.isNotEmpty)
                        Image.network(
                          iconUrl,
                          width: 50,
                          height: 50,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //json data fetching function
  Future<void> fetchWeather(String city) async {
    const String apiKey = "7c2d6bce1c7b1b65cff35b47d05fe75f";
    final String url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          weatherInfo =
              "Temperature: ${data['main']['temp']}°C\n Feels Like: ${data['main']['feels_like']} \n Min Temperature: ${data['main']['temp_min']} \n Max Temperature: ${data['main']['temp_max']} \n Condition: ${data['weather'][0]['description']}";
          iconCode = data['weather'][0]['icon'];
          iconUrl =
              "https://openweathermap.org/img/wn/$iconCode@2x.png";
          // update the iconUrl
        });
      } else {
        setState(() {
          weatherInfo = "City not found. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        weatherInfo =
            "Error fetching weather data. \n Please check your internet connection.";
      });
    }
  }
}
