import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatingAction extends StatefulWidget {
  const FloatingAction({super.key});

  @override
  State<FloatingAction> createState() => _FloatingActionState();
}

class _FloatingActionState extends State<FloatingAction> {
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController=TextEditingController();

    return AlertDialog(
      title: Text("Add new item"),
      content: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: "Enter the task"
        ),
      ),
    );
  }
}
