import 'dart:convert';

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
  Position ?position;
   determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }


    position= await Geolocator.getCurrentPosition();
    setState(() {
      latitude= position!.latitude;
      longitude=position!.longitude;
    });
  fetchWeatherData();
   }
  var latitude;
   var longitude;
   Map<String, dynamic>?weatherMap;
  Map<String, dynamic>?forecastMap;


  fetchWeatherData() async {
     String weatherUrl = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=7785187aa0220111b2132cc9e9f5aea1';
     String forecastUrl= 'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=7785187aa0220111b2132cc9e9f5aea1';
     var weatherResponse= await http.get(Uri.parse(weatherUrl));
     var forecastResponse= await http.get(Uri.parse(forecastUrl));
     weatherMap= Map<String,dynamic>.from(jsonDecode(weatherResponse.body));
     forecastMap= Map<String,dynamic>.from(jsonDecode(forecastResponse.body));
     setState(() {

     });
// print("$latitude, $longitude");
   }
   @override
  void initState() {
    // TODO: implement initState
     determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return  Scaffold(
      body: forecastMap !=null? Column(
        children: [
          Expanded(flex: 2,
            child: Container(
              height: size.height,
              width: size.width,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.only(top: 45.0),
              decoration:
              BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors:  [
                    Color(0xff9d80cb),
                    Color(0xff8364e8),
                  ],
                  begin: Alignment.bottomCenter ,
                  end: Alignment.topCenter,
                  stops: [0.20, 0.60] ,
                ),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text ('${weatherMap!['name']}',style: myTxtStyl(35, FontWeight.bold,Colors.white)),
                  ),
                  Text (Jiffy(DateTime.now()).format('EEEE, do MMMM'),style: myTxtStyl(15, FontWeight.bold,Colors.white)),
                  const SizedBox(height: 10.0),
                  Image.asset('images/${weatherMap!['weather'][0]['icon']}.png',width: size.width*0.3),
                  const SizedBox(height: 10.0),
                  Text (weatherMap!['weather'][0]['description'].toString().toUpperCase(),style: myTxtStyl(35, FontWeight.bold,Colors.white)),
                  Text ('${weatherMap!['main']['temp']}\u00B0c',style: myTxtStyl(50, FontWeight.bold,Colors.white)),
                  // const SizedBox(height: 60.0,),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(children: [
                          Image.asset('images/wind.png',color: Colors.white,width: size.width*0.15),
                          const SizedBox(height: 5.0),
                          Text ('${weatherMap!['wind']['speed']} km/h',style: myTxtStyl(20, FontWeight.bold,Colors.white),),
                          const SizedBox(height: 10.0),
                          Text ('Wind Speed',style: myTxtStyl(17, FontWeight.bold,Colors.white.withOpacity(0.6),),),],
                        ),
                        Column(children: [
                          Image.asset('images/humidity.png',color: Colors.white,width: size.width*0.15),
                          const SizedBox(height: 5.0),
                          Text ('${weatherMap!['main']['humidity']}',style: myTxtStyl(20, FontWeight.bold,Colors.white),),
                          const SizedBox(height: 10.0),
                          Text ('Humidity',style: myTxtStyl(17, FontWeight.bold,Colors.white.withOpacity(0.6),),),],
                        ),
                        Column(children: [
                          Image.asset('images/feels.png',color: Colors.white,width: size.width*0.15),
                          const SizedBox(height: 5.0),
                          Text ('${weatherMap!['main']['feels_like']}\u00B0c',style: myTxtStyl(20, FontWeight.bold,Colors.white),),
                          const SizedBox(height: 10.0),
                          Text ('Feels Like',style: myTxtStyl(17, FontWeight.bold,Colors.white.withOpacity(0.6),),),],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
const SizedBox(height: 10,),
          Expanded( child: ListView.builder(
            shrinkWrap: true,
            itemCount: forecastMap?.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
            return Container(
              // color: Colors.green,
              height:size.height*0.20,
              width: size.width*0.50,
              margin: const EdgeInsets.only(left: 10.0,bottom: 10.0),
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(20.0)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text(Jiffy(forecastMap!['list'][index]['dt_txt']).format('EEE, h:mm'),style: myTxtStyl(18, FontWeight.normal,Colors.white)),
                    const SizedBox(height: 10.0),
                    Image.asset('images/${forecastMap!['list'][index]['weather'][0]['icon']}.png',width: size.width*0.25,),
                    const SizedBox(height: 10.0),
                    Text("${forecastMap!['list'][index]['main']['temp_min']} / ${forecastMap!['list'][index]['main']['temp_max']}\u00B0c",style: myTxtStyl(15, FontWeight.normal,Colors.white)),
                    const SizedBox(height: 10.0),
                    Text(forecastMap!['list'][index]['weather'][0]['description'].toString().toUpperCase(),style: myTxtStyl(18, FontWeight.w700, Colors.white),),

              ]),
            );
          }),),

        ],
      ): const SplashWindow()
    );
  }
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(DiagnosticsProperty<Map<String, dynamic>>('weatherMap', weatherMap));
//   }
}
myTxtStyl(double size, FontWeight weight, [Color? color]){
  return TextStyle(fontSize: size, fontWeight: weight, color: color);
}
