import 'package:flutter/material.dart';

const styling = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    hintStyle: TextStyle(fontStyle: FontStyle.italic),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    ));
