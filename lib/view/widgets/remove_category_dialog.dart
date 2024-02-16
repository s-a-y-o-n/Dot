import 'package:dot/controller/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RemoveCategoryDialog extends StatelessWidget {
  RemoveCategoryDialog(
      {super.key,
      required this.categoryName,
      required this.categoryIndex,
      required this.fetchData});
  String categoryName;
  int categoryIndex;
  final void Function() fetchData;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete $categoryName ?"),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel')),
        ElevatedButton(
            onPressed: () {
              print(categoryIndex);
              CategoryController().removeUserCategory(
                  catIndex: categoryIndex, fetchData: fetchData);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$categoryName Deleted successfully")));
              fetchData();
            },
            child: Text("Delete"))
      ],
    );
  }
}
