import 'package:hive_flutter/hive_flutter.dart';

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

  void addUserCategory(String text) {}

  void removeUserCategory(
      {required int catIndex, required void Function() fetchData}) {}
}
