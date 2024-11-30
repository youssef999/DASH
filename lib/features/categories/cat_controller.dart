



// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:yemen_services_dashboard/main.dart';

import 'cat_model.dart';

class CatController extends GetxController{

 String? uploadedFileURL;
 final ImagePicker picker = ImagePicker();
bool isImageUploading = false; 
List<XFile> images = [];
    String? imageUrl;

  Future<void> pickMultipleImages() async {
   
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Immediately set the image URL to display in the dialog
     // setState(() {
        imageUrl = pickedFile.path; // Set the picked image path
     // });
      // Read the image as bytes for upload
      Uint8List imageData = await pickedFile.readAsBytes();
      // ignore: avoid_print
      print('picked');
      update();
      uploadImage(imageData);
    }
  }
   Future<String> uploadImage(Uint8List xfile) async {
    Reference ref = FirebaseStorage.instance.ref().child('Folder');
    String id = const Uuid().v1();
    ref = ref.child(id);

    UploadTask uploadTask = ref.putData(
      xfile,
      SettableMetadata(contentType: 'image/png'),
    );
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
   // setState(() {
      uploadedFileURL = downloadUrl;
      update();
   // });
    // ignore: avoid_print
    print(downloadUrl);
    return downloadUrl;
  }

   Future<void> imgFromGallery() async {
    final pickedFile =
        await ImagePicker().
        pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
    //  setState(() {
        imageUrl = pickedFile.path; // Set the picked image path
        isImageUploading = true; // Set uploading status to true
       update();
      // Read the image as bytes for upload
      Uint8List imageData = await pickedFile.readAsBytes();
      print('picked');
      await uploadImage(imageData); // Await the image upload
    }
  }



  TextEditingController subCatNameController=TextEditingController();

  String selectedItem = 'خدمات الكمبيوتر';

   List<String>catListNames=[];

    changeCatValue(String val) {
    selectedItem = val;
    update();
  }

  List<Cat>catList=[];

  Future<void> getCats() async {
    catListNames = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('cat').get();

      catList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return Cat.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      update();

      for (int i = 0; i < catList.length; i++) {
        catListNames.add(catList[i].name);
        update();
      }
      selectedItem = catList[0].name;
      update();
      // ignore: avoid_print
      print("Cats loaded: ${catList.length} ads found.");
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching ads: $e");
    }
  }



  passCatValue(String val) {
    selectedItem = val;
    update();
  }

 Future<void> updateSubCategoryDocument(String name, Map<String, dynamic> newData) async {
   try {
     // Reference to the Firestore collection
     CollectionReference subCatCollection = FirebaseFirestore.instance.collection('sub_cat');

     // Query to find the document where the "name" field matches the provided name
     QuerySnapshot querySnapshot = await subCatCollection.where('name', isEqualTo: name).get();

     // Check if the document exists
     if (querySnapshot.docs.isNotEmpty) {
       // Get the document ID and update it
       String docId = querySnapshot.docs.first.id;
       await subCatCollection.doc(docId).update(newData);

       print('Document updated successfully!');
       Get.offAll(const Dashboard());
       Get.snackbar('', 'تم تعديل القسم بنجاح',
       colorText:Colors.white,
         backgroundColor: Colors.green
       );
     } else {
       print('No document found with the name: $name');
     }
   } catch (e) {
     print('Failed to update document: $e');
   }
 }


   bool isLoading = false;
  Future<void> addSubCategory(BuildContext context) async {
    
    if (uploadedFileURL == null || subCatNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: 
        Text('يرجى اضافة الصورة واسم التصنيف')),
      );
      return;
    }

    // Check the number of existing categories
    final categoryCount =
        await FirebaseFirestore.instance.collection('sub_cat').get();

    if (categoryCount.docs.length >= 230) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content:
         Text('لا يمكن إضافة أكثر من 12 تصنيف')),
      );
      return;
    }

    //setState(() {
      isLoading = true; // Show loading indicator
      update();
    //});

    try {
      // Add category to Firestore
      await FirebaseFirestore.instance.collection('sub_cat').add({
        'name': subCatNameController.text,
        'image': uploadedFileURL,
        'cat':selectedItem
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت اضافة التصنيف بنجاح')),
      );
      subCatNameController.clear();
      
        imageUrl = null; // Clear the image URL
        uploadedFileURL = null; // Clear uploaded file URL
        update();

        
    } catch (error) {
      if (error is FirebaseException) {
        // ignore: avoid_print
        print('Firebase Error: ${error.message}');
      } else {
        // ignore: avoid_print
        print('Error: $error');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ ما')),
      );
    } finally {

        isLoading = false;
        update(); // Hide loading indicator
    }
  }


}