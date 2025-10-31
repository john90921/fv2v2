import 'package:flutter/material.dart';
import 'package:fv2/models/Filter.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:provider/provider.dart';

Future<Filter?> showFilterDialog({
  required BuildContext context,

}) {
  
  Filter? currentFilter = Provider.of<PostProvider>(context,listen:false).currentFilter;
  String selectedDate = currentFilter?.date ?? "today";
  String selectedSortBy = currentFilter?.sortBy ?? "popular";

  return showDialog<Filter>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text("Select Filter"),
            content: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Date Range"),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedDate,
                    items: <String>["today", "week", "month", "year"]
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedDate = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text("Sort By"),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedSortBy,
                    items: <String>['latest', 'popular']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedSortBy = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(
                              Filter(
                                date: selectedDate.toLowerCase(),
                                sortBy: selectedSortBy.toLowerCase(),
                              ),
                            );
                          },
                          child: const Text("Apply"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(Filter.initial());
                          },
                          child: const Text("Reset"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
