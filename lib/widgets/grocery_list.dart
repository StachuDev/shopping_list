import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/add_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItemsList = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-app-fcec5-default-rtdb.firebaseio.com', 'shopping-list.json');

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error =
              "Problem z pobraniem danych z bazy. \nSpróbuj ponownie później";
        });
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
              (catItem) => catItem.value.name == item.value['category'],
            )
            .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }

      setState(() {
        _groceryItemsList = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = "Coś poszło nie tak. \nSpróbuj ponownie później";
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const AddItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItemsList.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final listIndex = _groceryItemsList.indexOf(item);

    setState(() {
      _groceryItemsList.remove(item);
    });
    final url = Uri.https('flutter-app-fcec5-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryItemsList.insert(listIndex, item);
      });
    }
    // ScaffoldMessenger.of(context).clearSnackBars();
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     duration: const Duration(seconds: 3),
    //     content: const Text('Produkt został usunięty.'),
    //     action: SnackBarAction(
    //       label: 'Undo',
    //       onPressed: () {
    //         setState(() {
    //           _groceryItemsList.insert(listIndex, item);
    //         });
    //       },
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: _groceryItemsList.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(_groceryItemsList[index].id),
        onDismissed: (direction) => _removeItem(_groceryItemsList[index]),
        child: ListTile(
          leading: Container(
            width: 20,
            height: 20,
            color: _groceryItemsList[index].category.color,
          ),
          title: Text(
            _groceryItemsList[index].name,
          ),
          trailing: Text(
            _groceryItemsList[index].quantity.toString(),
          ),
        ),
      ),
    );

    if (_groceryItemsList.isEmpty) {
      content = const Center(
        child: Text('Nie zapisano żadnych produktów'),
      );
    }

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(
          _error!,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Twoje zakupy: ",
        ),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
