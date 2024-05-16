import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery_app/categories_data.dart';
import 'package:grocery_app/category.dart';
import 'package:grocery_app/grocery_iteem.dart';
import 'package:http/http.dart'as http;

class NewItem extends StatefulWidget {
  const NewItem({Key? key}) : super(key: key);

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final formKey = GlobalKey<FormState>();
  var enteredName = '';
  var enteredQuantity = 1;
  var selectedCategoryy = categories[Categories.vegetables]!;

  void save() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final url= Uri.https("grocery-8a7d1-default-rtdb.firebaseio.com", "shopping-list.json");
      final responses= await http.post(url,headers: {
        'Content-type': 'Application/json',
      },
        body: jsonEncode({
          'name': enteredName,
          'quantity': enteredQuantity,
          'category': selectedCategoryy.title,
        })
      );
      print(responses.body);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Items",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length >= 50) {
                    return "Invalid Name";
                  }
                  return null;
                },
                onSaved: (value) {
                  enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: enteredQuantity.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return "Invalid Data";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text("Quantity"),
                      ),
                      onSaved: (value) {
                        enteredQuantity = int.tryParse(value!)!;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButton(
                        value: selectedCategoryy,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 16,
                                      width: 16,
                                      color: category.value.color,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(category.value.title)
                                  ],
                                ))
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedCategoryy = value!;
                          });
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        formKey.currentState!.reset();
                      },
                      child: const Text("Reset")),
                  ElevatedButton(onPressed: save, child: const Text("Save"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
