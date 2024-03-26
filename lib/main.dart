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
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 227, 100, 20),
          brightness: Brightness.light,
          surface: const Color.fromARGB(255, 95, 15, 64),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 251, 139, 36),
      ),
      home: const GroceryList(),
    );
  }
}
