

import 'package:flutter/material.dart';
import 'package:weather_application/weather_app_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


@override
void initState() {
  super.initState();

  Future.delayed(const Duration(seconds: 3), () {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WeatherAppScreen()),
      );
    }
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Center(child: Text("Discover The \nWeather In Your City ",
              textAlign: TextAlign.center,
               style: TextStyle(
                
               fontSize: 30,
               fontWeight: FontWeight.w800,
               letterSpacing: 0.5,
               height: 1.2,
               color: Theme.of(context).colorScheme.secondary,
               
               ),
              ),
              ),
              Spacer(),
              Image.asset('assets/images/splash1.png', height: 250,),
              Spacer(),

               Center(child: Text("Get to know your weather apps\nradar recipitations forcast ",
              textAlign: TextAlign.center,
               style: TextStyle(
               
               fontSize: 16,
               fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.secondary,
              
               ),
              ),
              ),
              Padding(padding: EdgeInsetsGeometry.only(
                top: 30,),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(20),
                    )
                  ),
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WeatherAppScreen()));
                  }, child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    child: Text(
                      'Get Started',
                       style: TextStyle(
                        fontWeight: FontWeight.bold,
                         fontSize: 18,
                          color: Theme.of(context).colorScheme.secondary,
                         ),
                         ),
                  ))
                )
            ],
          ),
        ),
      ),
    );

  }
}