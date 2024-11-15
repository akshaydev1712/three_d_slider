import 'package:flutter/material.dart';
import 'package:three_d_slider/three_d_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = [
      'https://images.pexels.com/photos/27308352/pexels-photo-27308352/free-photo-of-a-wooden-path-leading-to-the-beach-at-sunset.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      'https://images.pexels.com/photos/28859529/pexels-photo-28859529/free-photo-of-aerial-view-of-coastal-wind-turbine-farm.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      'https://images.pexels.com/photos/29034179/pexels-photo-29034179/free-photo-of-autumn-leaves-on-a-wooden-dock-by-the-water.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      'https://images.pexels.com/photos/29087771/pexels-photo-29087771/free-photo-of-stunning-starry-night-over-lake-in-lombardia-italy.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      'https://images.pexels.com/photos/14344721/pexels-photo-14344721.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Determine if the platform should be treated as web based on screen width.
    // A width of 481 pixels or more is considered a web platform.
    bool isWeb = screenWidth >= 481;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ThreeDSlider(
                frameHeight: screenHeight * (isWeb ? 0.3 : 0.2),
                frameWidth: screenWidth * (isWeb ? 0.2 : 0.5),
                sideFrameVisibility: 0.2,
                frameDecoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 95, 94, 94),
                      offset: Offset(0, 10),
                      blurRadius: 20.0,
                    )
                  ],
                ),
                cards: imageUrls
                    .map((url) => Image.network(url, fit: BoxFit.fill))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
