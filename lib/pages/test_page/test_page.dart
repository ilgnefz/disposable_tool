import 'package:disposable_tool/pages/simple_tree/example.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool checked = false;
  bool checked1 = false;
  bool checked2 = false;

  void onChanged(bool? v) {
    setState(() {
      checked = !checked;
    });
  }

  void onChanged1(bool? v) {
    setState(() {
      checked1 = !checked1;
    });
  }

  void onChanged2(bool? v) {
    setState(() {
      checked2 = !checked2;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return ExpandableDropdown();
    return const Column(
      children: [
        Expanded(child: CustomExTDemo()),
        Expanded(child: CustomExTDemo2()),
      ],
    );
  }
}

class ExpandableDropdown extends StatefulWidget {
  @override
  _ExpandableDropdownState createState() => _ExpandableDropdownState();
}

class _ExpandableDropdownState extends State<ExpandableDropdown> {
  String? selectedValue;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      onSelected: (value) {
        setState(() {
          selectedValue = value;
          isExpanded = false; // 收起ExpansionTile
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          child: ExpansionTile(
            title: Text('Select an option'),
            children: [
              ListTile(
                title: Text('Option 1'),
                onTap: () {
                  setState(() {
                    selectedValue = 'Option 1';
                    isExpanded = false; // 收起ExpansionTile
                  });
                  Navigator.pop(context); // Close the popup menu
                },
              ),
              ListTile(
                title: Text('Option 2'),
                onTap: () {
                  setState(() {
                    selectedValue = 'Option 2';
                    isExpanded = false; // 收起ExpansionTile
                  });
                  Navigator.pop(context); // Close the popup menu
                },
              ),
              ListTile(
                title: Text('Option 3'),
                onTap: () {
                  setState(() {
                    selectedValue = 'Option 3';
                    isExpanded = false; // 收起ExpansionTile
                  });
                  Navigator.pop(context); // Close the popup menu
                },
              ),
            ],
          ),
        ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedValue ?? 'Select an option'),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
