
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/theme.dart';

void showCustomSnackbar(BuildContext context, String message) {
  Flushbar(
    messageText: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      maxLines: 3, // Ensure text does not exceed three lines
      overflow: TextOverflow.ellipsis, // Handle overflow
    ),
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: redColor,
    duration: const Duration(seconds: 3),
  ).show(context);
}

class SearchableDialog extends StatefulWidget {
  final List<String> items;
  final String title;

  SearchableDialog({super.key, required this.items, required this.title});

  @override
  _SearchableDialogState createState() => _SearchableDialogState(items: items, title: title);
}

class _SearchableDialogState extends State<SearchableDialog> {
  List<String> filteredItems = [];
  final List<String> items;
  final String title;
  String? selectedItem; // Track the selected item

  _SearchableDialogState({required this.items, required this.title});

  @override
  void initState() {
    super.initState();
    filteredItems.addAll(items);
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      for (var item in items) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        filteredItems.clear();
        filteredItems.addAll(dummyListData);
      });
    } else {
      setState(() {
        filteredItems.clear();
        filteredItems.addAll(items);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            cursorColor: Colors.green,
            onChanged: (value) {
              filterSearchResults(value);
            },
            decoration: InputDecoration(
              hintText: 'Cari',
              prefixIcon: Icon(Icons.search), // Set prefix icon color
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Radio<String>(
                    value: filteredItems[index],
                    groupValue: selectedItem,
                    onChanged: (String? value) {
                      setState(() {
                        selectedItem = value;
                      });
                    },
                    activeColor: Colors.green, // Set radio button color
                  ),
                  title: Text(filteredItems[index]),
                  onTap: () {
                    setState(() {
                      selectedItem = filteredItems[index];
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black)
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text(
              'Select',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
          ),
          onPressed: () {
            Navigator.pop(context, {
              'index': items.indexOf(selectedItem!),
              'item': selectedItem,
            });
          },
        ),
      ],
    );
  }
}