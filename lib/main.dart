import "package:flutter/material.dart";
import "package:shopping_list/widgets/grocery_list.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Artykuły spożywcze",
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 122, 162, 227),
          brightness: Brightness.light,
          surface: const Color.fromARGB(255, 106, 212, 221),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 248, 246, 227),
      ),
      home: const GroceryList(),
    );
  }
}
