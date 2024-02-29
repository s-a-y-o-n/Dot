import 'dart:math';

import 'package:dot/controller/controllers.dart';
import 'package:dot/utils/color_constants.dart';
import 'package:dot/view/notepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget(
      {super.key,
      required this.title,
      required this.description,
      required this.date,
      required this.category,
      required this.onDelete,
      required this.onUpdate});

  final String title;
  final String description;
  final String date;
  final String category;
  final void Function()? onDelete;
  final void Function()? onUpdate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NotePage(
                    title: title,
                    description: description,
                    date: date,
                    category: category))),
        child: Card(
          elevation: 20,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            height: 200,
            width: MediaQuery.sizeOf(context).width - 80,
            decoration: BoxDecoration(
                color: ColorConstants.secondarycolor2,
                borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                        PopupMenuButton(
                            iconColor: Colors.white,
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  enabled: false,
                                  child: TextButton(
                                    onPressed: onUpdate,
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: TextButton(
                                    onPressed: onDelete,
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                )
                              ];
                            })
                      ],
                    ),
                    Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                    IconButton(
                        onPressed: () {
                          String note =
                              "$title \n\n $description \n \n                          $date";
                          NotesController().shareNote(Note: note);
                        },
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
