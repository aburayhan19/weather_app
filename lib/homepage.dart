import 'dart:convert';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:weather_app/splash_window.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? position;
  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return showToast("Location services are disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return showToast("Location permissions are denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return showToast("Location permissions are permanently denied");
    }

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position!.latitude;
      longitude = position!.longitude;
    });
    fetchWeatherData();
  }

  // ignore: prefer_typing_uninitialized_variables
  var latitude;
  // ignore: prefer_typing_uninitialized_variables
  var longitude;
  Map<String, dynamic>? weatherMap;
  Map<String, dynamic>? forecastMap;

  fetchWeatherData() async {
    String weatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=7785187aa0220111b2132cc9e9f5aea1';
    String forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=7785187aa0220111b2132cc9e9f5aea1';
    var weatherResponse = await http.get(Uri.parse(weatherUrl));
    var forecastResponse = await http.get(Uri.parse(forecastUrl));
    weatherMap = Map<String, dynamic>.from(jsonDecode(weatherResponse.body));
    forecastMap = Map<String, dynamic>.from(jsonDecode(forecastResponse.body));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: forecastMap != null
          ? Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "images/scf/${weatherMap!['weather'][0]['icon']}.jpg"),
                    fit: BoxFit.cover),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              blurRadius: 20,
                              spreadRadius: 20,
                              color: Colors.black.withOpacity(0.10))
                        ]),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 4.0,
                            sigmaY: 4.0,
                          ),
                          child: Container(
                            width: size.width * 0.92,
                            // padding: const EdgeInsets.only(top: 45.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(width: 2.0, color: Colors.white30),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Padding(
                                  // padding: const EdgeInsets.only(top: 10),
                                  // child: 
                                  SafeArea(
                                    child: Text(
                                        weatherMap!['name']
                                            .toString()
                                            .toUpperCase(),
                                        style: myTxtStyl(
                                            40, FontWeight.bold, Colors.white)),
                                  ),
                                // ),
                                
                                Text(
                                    Jiffy(DateTime.now())
                                        .format('EEEE, do MMMM'),
                                    style: myTxtStyl(
                                        15, FontWeight.bold, Colors.white)),
                                const SizedBox(height: 10.0),
                                Image.asset(
                                    'images/${weatherMap!['weather'][0]['icon']}.png',
                                    width: size.width * 0.3),
                                const SizedBox(height: 10.0),
                                Text(
                                    weatherMap!['weather'][0]['description']
                                        .toString()
                                        .toUpperCase(),
                                    style: myTxtStyl(
                                        30, FontWeight.bold, Colors.white)),
                                Text('${weatherMap!['main']['temp']}\u00B0c',
                                    style: myTxtStyl(
                                        40, FontWeight.bold, Colors.white)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Image.asset('images/wind.png',
                                              color: Colors.white,
                                              width: size.width * 0.15),
                                          const SizedBox(height: 5.0),
                                          Text(
                                            '${weatherMap!['wind']['speed']} km/h',
                                            style: myTxtStyl(20,
                                                FontWeight.bold, Colors.white),
                                          ),
                                          const SizedBox(height: 10.0),
                                          Text(
                                            'Wind Speed',
                                            style: myTxtStyl(
                                              17,
                                              FontWeight.bold,
                                              Colors.white.withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Image.asset('images/humidity.png',
                                              color: Colors.white,
                                              width: size.width * 0.15),
                                          const SizedBox(height: 5.0),
                                          Text(
                                            '${weatherMap!['main']['humidity']}',
                                            style: myTxtStyl(20,
                                                FontWeight.bold, Colors.white),
                                          ),
                                          const SizedBox(height: 10.0),
                                          Text(
                                            'Humidity',
                                            style: myTxtStyl(
                                              17,
                                              FontWeight.bold,
                                              Colors.white.withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Image.asset('images/feels.png',
                                              color: Colors.white,
                                              width: size.width * 0.15),
                                          const SizedBox(height: 5.0),
                                          Text(
                                            '${weatherMap!['main']['feels_like']}\u00B0c',
                                            style: myTxtStyl(20,
                                                FontWeight.bold, Colors.white),
                                          ),
                                          const SizedBox(height: 10.0),
                                          Text(
                                            'Feels Like',
                                            style: myTxtStyl(
                                              17,
                                              FontWeight.bold,
                                              Colors.white.withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: forecastMap?.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, bottom: 10.0),
                            child: Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    blurRadius: 20,
                                    color: Colors.black.withOpacity(0.10))
                              ]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                clipBehavior: Clip.hardEdge,
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 4.0,
                                    sigmaY: 4.0,
                                  ),
                                  child: Container(
                                    height: size.height * 0.20,
                                    width: size.width * 0.50,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          width: 2.0, color: Colors.white30),
                                    ),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              Jiffy(forecastMap!['list'][index]
                                                      ['dt_txt'])
                                                  .format('EEE, h:mm'),
                                              style: myTxtStyl(
                                                  18,
                                                  FontWeight.normal,
                                                  Colors.white)),
                                          const SizedBox(height: 5.0),
                                          Image.asset(
                                            'images/forecast/${forecastMap!['list'][index]['weather'][0]['icon']}.png',
                                            width: size.width * 0.25,
                                          ),
                                          const SizedBox(height: 5.0),
                                          Text(
                                              "${forecastMap!['list'][index]['main']['temp_min']} / ${forecastMap!['list'][index]['main']['temp_max']}\u00B0c",
                                              style: myTxtStyl(
                                                  15,
                                                  FontWeight.normal,
                                                  Colors.white)),
                                          const SizedBox(height: 10.0),
                                          Text(
                                            forecastMap!['list'][index]
                                                        ['weather'][0]
                                                    ['description']
                                                .toString()
                                                .toUpperCase(),
                                            style: myTxtStyl(18,
                                                FontWeight.w700, Colors.white),
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )
          : const SplashWindow(),
    );
  }
}

myTxtStyl(double size, FontWeight weight, [Color? color]) {
  return TextStyle(fontSize: size, fontWeight: weight, color: color);
}

showToast(String title) {
  return Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 10,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
