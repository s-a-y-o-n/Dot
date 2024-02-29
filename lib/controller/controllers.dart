import 'package:dot/model/notes_model.dart';
import 'package:dot/view/widgets/add_categorydialog.dart';
import 'package:dot/view/widgets/remove_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';

class CategoryController {
  final CatBox = Hive.box('categories');
  final notebox = Hive.box('noteBox');
  void initializeApp() async {
    List<String> defaultCategories = ['Work', 'Personal', 'Ideas'];
    bool categoriesExist = CatBox.isNotEmpty;
    if (!categoriesExist) {
      for (String categoryname in defaultCategories) {
        CatBox.add(categoryname);
      }
    }
  }

  List getAllCategories() {
    return CatBox.values.toList();
  }

  void addUserCategory(String categoryname) {
    CatBox.add(categoryname);
  }

  addCategory(
      {required BuildContext context,
      required TextEditingController categoryController,
      required CategoryController catController,
      required void Function() fetchdata}) {
    return showDialog(
        context: context,
        builder: (context) => AddCategoryDialog(
            categorycontroller: categoryController,
            catController: catController,
            fetchdata: fetchdata));
  }

  void removeUserCategory(
      {required int catIndex, required void Function() fetchData}) {
    print(catIndex);
    print(CatBox.get(catIndex));
    print(notebox.get(catIndex));
    notebox.delete(catIndex);
    CatBox.delete(catIndex);
    fetchData();
  }

  removeCategory(
      {required int catIndex,
      required String catName,
      required BuildContext context,
      required void Function() fetchData}) {
    return showDialog(
        context: context,
        builder: (context) => RemoveCategoryDialog(
            categoryName: catName,
            categoryIndex: catIndex,
            fetchData: fetchData));
  }
}

class NotesController {
  final noteBox = Hive.box('noteBox');

  void addNotes(
      {required GlobalKey<FormState> formkey,
      required String title,
      required String description,
      required String date,
      required int category,
      required TextEditingController titleController,
      required TextEditingController desController,
      required BuildContext context}) {
    if (formkey.currentState!.validate()) {
      List<NotesModel> currentNotes = noteBox.containsKey(category)
          ? noteBox.get(category)!.cast<NotesModel>()
          : []; // Initialize as an empty list if category doesn't exist

      var note = NotesModel(
        title: title,
        description: description,
        date: date,
        category: category,
      );

      currentNotes.add(note);
      noteBox.put(category, currentNotes);
      titleController.clear();
      desController.clear();
      Navigator.pop(context);
    }
  }

  void deleteNote({
    required var key,
    required NotesModel note,
    required void Function() fetchData,
    required int index,
  }) {
    List<NotesModel> list = noteBox.get(key)!.cast<NotesModel>();
    print("before: $list");
    print("index: $index");
    print("lis length  : ${list.length}");

    if (index < 0 || index >= list.length) {
      print("Invalid index: $index. Index out of range.");
      return; // Exit the function if index is out of range
    }

    print("before2: $list");
    list.remove(note);
    print("after: $list");
    noteBox.put(key, list);
    print("updated: ${noteBox.get(key)}");

    if (list.length == 0) {
      noteBox.delete(key);
    }
  }

  void editNote({
    required String title,
    required String description,
    required String date,
    required int category,
    required GlobalKey<FormState> formkey,
    required int indexOfNote,
    required int oldCategory,
  }) {
    List<NotesModel> currentNotes =
        noteBox.get(oldCategory)?.cast<NotesModel>() ?? [];
    NotesModel note = NotesModel(
      title: title,
      description: description,
      date: date.toString(),
      category: category,
    );

    currentNotes.removeAt(indexOfNote);
    noteBox.put(oldCategory, currentNotes);

    if (currentNotes.isEmpty) {
      noteBox.delete(oldCategory);
    }

    List<NotesModel> updatedNotes =
        noteBox.get(category)?.cast<NotesModel>() ?? [];
    updatedNotes.add(note);
    noteBox.put(category, updatedNotes);
  }

  void shareNote({required String Note}) {
    Share.share(Note);
  }
}
