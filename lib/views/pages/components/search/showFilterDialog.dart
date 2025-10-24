import 'package:flutter/material.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
Future<Map<String, dynamic>?> showFilterDialog({
  required BuildContext context,
}) {
  String? Date;
  String? SortBy;
  return showDialog(
    context: context,
    builder: (context) {

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Select Filter"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text("Date Range"),
           SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              value: "Today",
              items: <String>["Today",'Week', 'Month','Year'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                // Handle sort by change
              },
            ),
            SizedBox(height: 20),
            Text("Sort By"),
            SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              value: "latest",
              items: <String>['latest', 'Popularity'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                // Handle sort by change
              },
            )
            ,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Apply"),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],)
          ],
        ),
      );
    },
  );
}
