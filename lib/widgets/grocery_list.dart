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
    await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const AddItem(),
      ),
    );
  }

  void _removeItem(GroceryItem item) {
    final listIndex = groceryItemsList.indexOf(item);

    setState(() {
      groceryItemsList.remove(item);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Produkt został usunięty.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              groceryItemsList.insert(listIndex, item);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: groceryItemsList.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(groceryItemsList[index].id),
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.8),
        ),
        onDismissed: (direction) => _removeItem(groceryItemsList[index]),
        child: ListTile(
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

    if (groceryItemsList.isEmpty) {
      content = const Center(
        child: Text('Nie zapisano żadnych produktów'),
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
