

import 'package:cloud_firestore/cloud_firestore.dart';

class Ad {
  final String id;
  final String imageUrl;
  final String cat;
  final String subCat;
  final String email;
  final String title;
  final String des;
  final Timestamp startDate;
  final Timestamp endDate;
  final String time;

  Ad({required this.id, required this.imageUrl,
    required this.startDate,
    required this.endDate,required this.title,
    required this.des,required this.subCat,
    required this.email,required this.time,


    required this.cat});

  // Factory method to create an Ad instance from a Firestore document snapshot
  factory Ad.fromFirestore(Map<String, dynamic> json, String documentId) {
    return Ad(
      id: documentId,
      cat: json['cat'] ?? '',
      startDate: json['current_date'] ?? DateTime.now(),
      endDate: json['end_date'] ?? DateTime.now(),
      title: json['title'] ?? '',
      email: json['email'] ?? '',
      des: json['des'] ?? '',
      imageUrl: json['image'] ?? '',
      subCat: json['sub_cat']??'',
      time: json['time']??'',
      // Default to empty string if no image
    );
  }
  // Method to convert Ad instance to a Map (useful for uploading data to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'image': imageUrl,
    };
  }
}
