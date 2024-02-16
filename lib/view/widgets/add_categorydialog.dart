import 'package:dot/controller/controllers.dart';
import 'package:dot/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddCategoryDialog extends StatelessWidget {
  const AddCategoryDialog(
      {super.key,
      required this.categorycontroller,
      required this.catController,
      required this.fetchdata});
  final TextEditingController categorycontroller;
  final CategoryController catController;
  final void Function() fetchdata;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Category'),
      content: TextField(
        controller: categorycontroller,
        maxLines: 1,
        decoration: InputDecoration(
            labelText: "Category",
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: ColorConstants.primarycolor)),
            isDense: false,
            contentPadding: EdgeInsets.all(20)),
      ),
      actions: [
        SizedBox(
            width: 200,
            child: ElevatedButton(
                onPressed: () {
                  categorycontroller.clear();
                  Navigator.pop(context);
                },
                child: Text('Close'))),
        ElevatedButton(
            onPressed: () {
              catController.addUserCategory(categorycontroller.text);
              categorycontroller.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Category Added Successfully")));
              fetchdata();
            },
            child: Text("Add"))
      ],
    );
  }
}
