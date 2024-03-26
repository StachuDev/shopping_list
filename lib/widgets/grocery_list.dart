import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/add_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> groceryItemsList = [];
  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const AddItem()));
    if (newItem == null) {
      return;
    }

    setState(() {
      groceryItemsList.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        itemCount: groceryItemsList.length,
        itemBuilder: (context, index) => ListTile(
          leading: Container(
            width: 20,
            height: 20,
            color: groceryItemsList[index].category.color,
          ),
          title: Text(
            groceryItemsList[index].name,
          ),
          trailing: Text(
            groceryItemsList[index].quantity.toString(),
          ),
        ),
      ),
    );
  }
}
