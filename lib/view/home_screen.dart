import 'package:dot/controller/controllers.dart';
import 'package:dot/model/notes_model.dart';
import 'package:dot/utils/color_constants.dart';
import 'package:dot/view/widgets/note_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formkey = GlobalKey<FormState>();

  var titlecontroller = TextEditingController();

  var descriptionController = TextEditingController();
  List categories = [];
  CategoryController catController = CategoryController();
  NotesController notesController = NotesController();
  int categoryindex = 0;
  TextEditingController categoryController = TextEditingController();
  var noteBox = Hive.box('noteBox');
  List myKeysList = [];
  bool isEditing = false;

  @override
  void initState() {
    catController.initializeApp();
    categories = catController.getAllCategories();
    fetchdata();
    super.initState();
  }

  void fetchdata() {
    myKeysList = noteBox.keys.toList();
    categories = catController.getAllCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primarybackgroundcolor,
      floatingActionButton: FloatingActionButton(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 2, color: Colors.white)),
        elevation: 0,
        onPressed: () => bottomSheet(context),
        backgroundColor: ColorConstants.secondarycolor2,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerboxisscrollable) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                // pinned: true,
                // floating: true,
                expandedHeight: 120,
                flexibleSpace: Column(
                  children: [
                    Image.asset(
                      "assets/dot.png",
                      height: 85,
                      width: 85,
                    ),
                  ],
                ),
                bottom: AppBar(),
              )
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(top: 30, left: 20),
            child: ListView.separated(
                itemBuilder: (context, index) {
                  List<NotesModel> notesInCategory =
                      noteBox.get(myKeysList[index])!.cast<NotesModel>();
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categories[myKeysList[index]],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: ColorConstants.primarycolor),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              notesInCategory.length,
                              (inIndex) {
                                return NoteWidget(
                                  title: notesInCategory[
                                          notesInCategory.length - inIndex - 1]
                                      .title,
                                  description: notesInCategory[
                                          notesInCategory.length - inIndex - 1]
                                      .description,
                                  date: notesInCategory[
                                          notesInCategory.length - inIndex - 1]
                                      .date,
                                  category: categories[myKeysList[index]],
                                  onDelete: () {
                                    print(
                                        "index1: ${notesInCategory.length - inIndex - 1}");
                                    notesController.deleteNote(
                                      key: myKeysList[index],
                                      note: notesInCategory[
                                          notesInCategory.length - inIndex - 1],
                                      fetchData: fetchdata,
                                      index:
                                          notesInCategory.length - inIndex - 1,
                                    );
                                    fetchdata();
                                    setState(() {});
                                  },
                                  onUpdate: () {
                                    titlecontroller.text = notesInCategory[
                                            notesInCategory.length -
                                                inIndex -
                                                1]
                                        .title;
                                    descriptionController.text =
                                        notesInCategory[notesInCategory.length -
                                                inIndex -
                                                1]
                                            .description;
                                    categoryindex = notesInCategory[
                                            notesInCategory.length -
                                                inIndex -
                                                1]
                                        .category;
                                    isEditing = true;
                                    bottomSheet(context,
                                        key: myKeysList[index],
                                        indexofEditing: notesInCategory.length -
                                            inIndex -
                                            1,
                                        currentCategory: notesInCategory[
                                                notesInCategory.length -
                                                    inIndex -
                                                    1]
                                            .category);
                                    setState(() {});
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                      height: 20,
                    ),
                itemCount: myKeysList.length),
          ),
        ),
      ),
    );
  }

  Future<dynamic> bottomSheet(BuildContext context,
      {var key, int? indexofEditing, int? currentCategory}) {
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        shape: OutlineInputBorder(
            borderSide: BorderSide(width: 0),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        isScrollControlled: true,
        builder: (context) => StatefulBuilder(
            builder: (context, InsetState) => Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Form(
                          key: _formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: titlecontroller,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    labelText: "Title",
                                    labelStyle: TextStyle(
                                        color: ColorConstants.primarycolor,
                                        fontWeight: FontWeight.bold),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    isDense: false,
                                    contentPadding: EdgeInsets.all(20)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter title";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 150,
                                child: TextFormField(
                                  controller: descriptionController,
                                  maxLines: null,
                                  expands: true,
                                  keyboardType: TextInputType.multiline,
                                  textAlignVertical: TextAlignVertical.top,
                                  textAlign: TextAlign.justify,
                                  decoration: InputDecoration(
                                      hintText: "Description",
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color:
                                                  ColorConstants.primarycolor),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      isDense: false,
                                      contentPadding: const EdgeInsets.all(20)),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter description';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Category',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: ColorConstants.primarycolor),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                      categories.length + 1,
                                      (index) => index == categories.length
                                          ? InkWell(
                                              onTap: () =>
                                                  catController.addCategory(
                                                      context: context,
                                                      categoryController:
                                                          categoryController,
                                                      catController:
                                                          catController,
                                                      fetchdata: fetchdata),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                    color: ColorConstants
                                                        .secondarycolor2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: const Text(
                                                  " + Add Category",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: InkWell(
                                                onTap: () {
                                                  categoryindex = index;
                                                  InsetState(() {});
                                                },
                                                onLongPress: () {
                                                  print(index);
                                                  print(categories[index]
                                                      .toString());
                                                  catController.removeCategory(
                                                      catIndex: index,
                                                      catName: categories[index]
                                                          .toString(),
                                                      context: context,
                                                      fetchData: fetchdata);
                                                  fetchdata();

                                                  setState(() {});
                                                  InsetState(() {});
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 15,
                                                    vertical: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: categoryindex ==
                                                              index
                                                          ? ColorConstants
                                                              .secondarycolor2
                                                          : ColorConstants
                                                              .cardcolor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Text(
                                                    categories[index]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            )),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    ColorConstants
                                                        .secondarycolor2)),
                                        onPressed: () {
                                          titlecontroller.clear();
                                          descriptionController.clear();
                                          Navigator.pop(context);
                                          isEditing = false;
                                          setState(() {});
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    ColorConstants
                                                        .secondarycolor2)),
                                        onPressed: () {
                                          if (isEditing) {
                                            notesController.editNote(
                                                title: titlecontroller.text,
                                                description:
                                                    descriptionController.text,
                                                date: DateFormat('dd:MM:yyyy')
                                                    .format(DateTime.now())
                                                    .toString(),
                                                category: categoryindex,
                                                oldCategory: currentCategory!,
                                                formkey: _formkey,
                                                indexOfNote: indexofEditing!);
                                            isEditing = false;
                                            titlecontroller.clear();
                                            descriptionController.clear();
                                            fetchdata();
                                            categoryindex = 0;
                                            Navigator.pop(context);
                                          } else {
                                            notesController.addNotes(
                                                formkey: _formkey,
                                                title: titlecontroller.text,
                                                description:
                                                    descriptionController.text,
                                                date: DateFormat('dd:MM:yyyy')
                                                    .format(DateTime.now())
                                                    .toString(),
                                                category: categoryindex,
                                                context: context,
                                                desController:
                                                    descriptionController,
                                                titleController:
                                                    titlecontroller);

                                            fetchdata();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text("Note added ")));
                                            setState(() {});
                                          }
                                        },
                                        child: isEditing
                                            ? const Text(
                                                "Edit",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            : const Text(
                                                "Add",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                  ),
                                ],
                              )
                            ],
                          )),
                    ),
                  ),
                )));
  }
}
