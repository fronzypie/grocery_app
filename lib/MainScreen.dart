import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/addNewItemScreen.dart';
import 'package:grocery_app/categories_data.dart';
import 'package:grocery_app/data.dart';
import 'package:http/http.dart' as http;

import 'grocery_iteem.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<GroceryItem> Items = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  void loadItems() async {
    final url = Uri.https(
        "grocery-8a7d1-default-rtdb.firebaseio.com", "shopping-list.json");
    final responses = await http.get(url);
    final Map<String, dynamic> listData = jsonDecode(responses.body);
    print(listData);
    final List<GroceryItem> loadeslist = [];
    for (final items in listData.entries) {
      final categoryy = categories.entries.firstWhere(
          (catItem) => catItem.value.title == items.value['category']);
      loadeslist.add(
        GroceryItem(
            id: items.key,
            name: items.value['name'],
            quantity: items.value['quantity'],
            category: categoryy.value),
      );
    }
    setState(() {
      Items=loadeslist;
    });
  }

  void addItem() async {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => NewItem()));
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: addItem, icon: const Icon(Icons.add))],
        title: const Text(
          "Grocery Items",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
          itemCount: Items.length,
          itemBuilder: (ctx, index) {
            return ListTile(
              title: Text(Items[index].name),
              leading: Container(
                height: 16,
                width: 16,
                color: Items[index].category.color,
              ),
            );
          }),
    );
  }
}
