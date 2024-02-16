import 'package:dot/controller/controllers.dart';
import 'package:dot/utils/color_constants.dart';
import 'package:flutter/material.dart';

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
  int categoryindex = 0;

  @override
  void initState() {
    catController.initializeApp();
    catController.getAllCategories();
    super.initState();
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
    );
  }

  Future<dynamic> bottomSheet(BuildContext context
      // ,{var key, int? indexofEditing, int? currentCategory}
      ) {
    return showModalBottomSheet(
        backgroundColor: ColorConstants.secondarycolor,
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
                                  decoration: InputDecoration(
                                      hintText: "Description",
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color:
                                                  ColorConstants.primarycolor)),
                                      isDense: false),
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
                                child: Row(
                                  children: List.generate(
                                      categories.length + 1,
                                      (index) => index == categories.length
                                          ? InkWell(
                                              onTap: () {},
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
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
                                          : InkWell(
                                              onTap: () {
                                                categoryindex = index;
                                              },
                                              onLongPress: () {},
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                    color:
                                                        categoryindex == index
                                                            ? Colors.black
                                                            : ColorConstants
                                                                .cardcolor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Text(
                                                  categories[index].toString(),
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )),
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                )));
  }
}
