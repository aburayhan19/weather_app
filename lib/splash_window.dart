import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class SplashWindow extends StatefulWidget {
  const SplashWindow({Key? key}) : super(key: key);

  @override
  State<SplashWindow> createState() => _SplashWindowState();
}

class _SplashWindowState extends State<SplashWindow> {
  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;

    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image.asset('images/weather.png',width: size.width*0.4),
          const  SpinKitWave(
              color: Colors.white,
              size: 40.0,
            )
      ]),
    );
  }
}
