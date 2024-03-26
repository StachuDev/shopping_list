import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() {
    return _AddItemState();
  }
}

class _AddItemState extends State<AddItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem() {
    _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj nowy produkt')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(label: Text('Nazwa')),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Musi zawierać od 2 do 50 znaków';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredName = value!;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(label: Text('Ilość')),
                        keyboardType: TextInputType.number,
                        initialValue: _enteredQuantity.toString(),
                        // int.tryParse wtedy gdy nie da się skonwertować do int
                        // int.tryParse('-11') => -11; int.tryParse('f1') => null
                        validator: (value) {
                          // zwraca null
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'To musi być liczba naturalna';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredQuantity = int.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField(
                        value: _selectedCategory,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    color: category.value.color,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(category.value.name),
                                ],
                              ),
                            )
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: const Text('Resetuj'),
                    ),
                    ElevatedButton(
                        onPressed: _saveItem,
                        child: const Text('Dodaj produkt'))
                  ],
                )
              ],
            )),
      ),
    );
  }
}
