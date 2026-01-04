import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/hero_section.dart';
import '../widgets/trip_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeroSection(),
            SizedBox(height: 24),
            Text(
              "Popular Destinations",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            TripGrid(),
          ],
        ),
      ),
    );
  }
}
