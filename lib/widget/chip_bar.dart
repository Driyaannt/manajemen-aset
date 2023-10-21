// model
import 'package:flutter/material.dart';

class ItemChipBar {
  final int id;
  final String title;
  final String selectedImg;
  final String unSelectedImg;
  final Widget bodyWidget;

  ItemChipBar(
    this.id,
    this.title,
    this.selectedImg,
    this.unSelectedImg,
    this.bodyWidget,
  );
}

