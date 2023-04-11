import 'package:cloud_firestore/cloud_firestore.dart';

class ContactItem{
  Map snapshot;
  bool isSelected;
  ContactItem(this.snapshot, this.isSelected);
}