import 'package:awexpenses/const/widget.dart';
import 'package:flutter/material.dart';

class AddUserInfo extends StatefulWidget {
  const AddUserInfo({super.key});

  @override
  State<AddUserInfo> createState() => _AddUserInfoState();
}

class _AddUserInfoState extends State<AddUserInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColor.bgColor,
      appBar: AppBar(
        backgroundColor: AllColor.blueColor,
        foregroundColor: AllColor.fontColor,
        title: Text(
          'Add Your Name',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),

      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 25),
        child: Column(
          children: [
            TextField(
              style: TextStyle(color: AllColor.fontColor),
              cursorColor: AllColor.fontColor,
              decoration: InputDecoration(
                labelText: 'Enter Name',
                labelStyle: TextStyle(color: AllColor.fontColor.withOpacity(0.7)),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AllColor.fontColor.withOpacity(.7), width: 1.5)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
