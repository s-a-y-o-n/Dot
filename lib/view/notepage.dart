import 'package:dot/utils/color_constants.dart';
import 'package:flutter/material.dart';

class NotePage extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String category;
  const NotePage(
      {super.key,
      required this.title,
      required this.description,
      required this.date,
      required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.cardcolor,
      appBar: AppBar(
        backgroundColor: ColorConstants.cardcolor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: TextStyle(
                      color: ColorConstants.primarycolor, fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              title,
              style: TextStyle(
                  color: ColorConstants.primarycolor,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "* $category",
              style:
                  TextStyle(color: ColorConstants.secondarycolor, fontSize: 15),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              description,
              style: TextStyle(color: ColorConstants.primarycolor),
            )
          ],
        ),
      ),
    );
  }
}
