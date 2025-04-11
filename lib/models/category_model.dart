import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  final String audioPath; // You might need to add audio playing logic later

  Category({required this.name, required this.icon, this.audioPath = ''});
}
