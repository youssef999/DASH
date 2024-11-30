
// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yemen_services_dashboard/features/categories/cat_model.dart';
import 'package:yemen_services_dashboard/features/model/subCat_model.dart';
import 'package:yemen_services_dashboard/features/offers/model/ads_model.dart';
import 'package:yemen_services_dashboard/main.dart';

class AdController extends GetxController{


  final ImagePicker picker = ImagePicker();

  List<XFile> images = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();

  List<String> downloadUrls = [];
  String downloadUrl = '';
  List<Cat> catList = [];
  List<SubCat> subCatList = [];
  List<String> catListNames = [];
  List<String> subCatListNames = [];
  String selectedCat = 'خدمات الصيانة';
  String selectedSubCat = 'فني طابعات و احبار';
  String selectedDays = 'شهر';
  String price='500';

  List<String> daysList = ['شهر', '3 شهور', '6 شهور', 'سنة'];
  List<String> priceList = ['500', '1200', '2200', '3000'];

  DateTime   startDate = DateTime.now();
  DateTime ?endDate=DateTime.now();

  List<Ad> adsList = [];
  //List<WorkerProvider> workerList = [];

Future<void> deleteAdById(String id) async {
  try {
    // Reference to Firestore
    final firestore = FirebaseFirestore.instance;
    
    // Delete the document in the "ads" collection where id matches the given id
    await firestore.collection('ads').doc(id).delete();

    print('Document with id $id deleted successfully.');
    Get.snackbar('', 'تم الحذف بنجاح',
    backgroundColor:Colors.green,
    colorText:Colors.white
    );
    Get.offAll(const Dashboard());
  } catch (e) {
    print('Error deleting document: $e');
  }
}

 Future<void> getAds() async {
    try {
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('ads').get();
      // Map each document to an Ad instance and add to adsList
      adsList = querySnapshot.docs.map((DocumentSnapshot doc) {
        // Convert the document data to the Ad model using fromFirestore
        return Ad.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      update(); // Call update() if using a state management solution like GetX
      // Optional: Print the list for debugging
      print("Ads loaded: ${adsList.length} ads found.");
    } catch (e) {
      // Handle any errors
      print("Error fetching ads: $e");
    }
  }

  getWorkerAds()async{
    print("HERE ADS...");
    final box=GetStorage();
    String email=box.read('email');
    try {
        QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance
            .collection('ads')
            .where('email', isEqualTo: email)
            .get();
        adsList = querySnapshot.docs.map((DocumentSnapshot doc) {
          return Ad.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
        update();
    } catch (e) {
      print("Error fetching ads: $e");
    }
    print("aadsss=="+adsList.length.toString());

  }




  changeDayListValue(String value){
    selectedDays=value;
    if(value=='شهر'){
      price='500';

        endDate = startDate.add(const Duration(days: 30));
    }
    if(value=='3 شهور'){
      price='1200';
      endDate = startDate.add(const Duration(days: 120));
    }
    if(value=='6 شهور'){
      price='2200';
      endDate = startDate.add(const Duration(days: 180));
    }
    if(value=='سنة'){
      price='3000';
      endDate = startDate.add(const Duration(days: 365));
    }
    print("END DATE====="+endDate.toString());
    update();
  }


  Future<void> getSubCats(String cat) async {
    subCatList = [];
    subCatListNames = [];
    print("HERE CATS......");
    try {
      if (cat.length > 1) {
        QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance
            .collection('sub_cat')
            .where('cat', isEqualTo: cat)
            .get();
        subCatList = querySnapshot.docs.map((DocumentSnapshot doc) {
          return SubCat.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
        selectedSubCat = subCatList[0].name;
        update();
      } else {
        QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('sub_cat').get();
        subCatList = querySnapshot.docs.map((DocumentSnapshot doc) {
          return SubCat.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      }

      print("Subcat==XXX=" + subCatList.length.toString());
      for (int i = 0; i < subCatList.length; i++) {
        subCatListNames.add(subCatList[i].name);
      }
      selectedSubCat = subCatListNames[0];
      update();
      print("sub Cat loaded: ${catList.length}.");
      print("sub Cat loaded: ${subCatListNames}.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
  }

  Future<void> pickMultipleImages() async {
    List<XFile>? selectedImages = [];
    images.clear();
    //while (true) {
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImages.add(pickedFile);
    } else {
      //break; // Break the loop if no image is selected
    }
    // }
    if (selectedImages.isNotEmpty) {
      images.addAll(selectedImages); // Add selected images to the list
    }
    update();
  }

  changeCatValue(String cat) {
    selectedCat = cat;
    update();
    getSubCats(cat);
  }

  Future<void> getCats() async {
    catList = [];
    catListNames = [];
    print("....xxxx....HERE CATS.......xxx...");
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('cat').get();
      catList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return Cat.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      for (int i = 0; i < catList.length; i++) {
        catListNames.add(catList[i].name);
      }
      selectedCat = catList[0].name;
      update();
      getSubCats(selectedCat);
      print("Cats loaded: ${catList.length}.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
  }


  changeSubCatValue(String subCat) {
    selectedSubCat = subCat;
    update();
  }



  Future uploadMultiImageToFirebaseStorage(List<XFile> images) async {
    print("UPLOAD IMAGES....");
    print("UPLOAD IMAGES======" + images.length.toString());
    for (int i = 0; i < images.length; i++) {
      print("HERE==" + i.toString());
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference reference =
        FirebaseStorage.instance.ref().child('imagesAds/$fileName');
        UploadTask uploadTask = reference.putFile(File(images[i].path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        downloadUrl = await taskSnapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      } catch (e) {
        // Handle any errors that occur during the upload process
        // ignore: avoid_print
        print('Error uploading image to Firebase Storage: $e');
      }
      print("DOWNLOAD URLS====" + downloadUrls.length.toString());
      print("DOWNLOAD URLS====" + downloadUrls.toString());
    }
    return downloadUrls;
  }

  bool isLoading=false;

  Future<void> addNewAdToFirestore(BuildContext context,String image)
  async {
    isLoading=true;
    update();
      uploadMultiImageToFirebaseStorage(images).then((v) {
        Future.delayed(const Duration(seconds: 3), () async {
          final box=GetStorage();
          String email=box.read('email')??'admin@gmail.com';
            // Generate a new document ID
            String Id =
                FirebaseFirestore.instance.collection('ads').doc().id;
            Map<String, dynamic> data = {
              "id": Id,
             'image': image,
              //downloadUrls[0],
              "cat": selectedCat,
              'title': titleController.text,
              'time':selectedDays,
               'price':price,
              'des': desController.text,
              "sub_cat": selectedSubCat,
              'email':email,
              "current_date":startDate,
              'end_date':endDate,
              //"image": images,
            };

            try {
              // Create a reference with the generated document ID
              CollectionReference collection =
              FirebaseFirestore.instance.collection('ads');
              await collection.doc(Id).set(data).then((value) {

                Get.snackbar('', 'تم اضافة اعلانك بنجاح');
               

                isLoading=false;

                Get.back();

                //Get.offAll( MainHome());
                titleController.clear();
                desController.clear();
                images.clear();
                update();
              });
              print("Data added successfully!");
            } catch (e) {
              print("Error adding data: $e");
            }
          }
        );
      });
    }

  Future<void> updateAdData(String adId,BuildContext context) async {

    isLoading=true;
    update();
     if(images.isNotEmpty){
       try {
         uploadMultiImageToFirebaseStorage(images).then((v) async {
           await FirebaseFirestore.instance.collection
             ('ads').doc(adId).update({
             'title':titleController.text,
             'des':desController.text,
             'image':downloadUrls[0]
           });
           print("Ad data updated successfully.");
            Get.snackbar('', 'تم تعديل اعلانك بنجاح');
          isLoading=false;
          update();
         });

       } catch (e) {
         print("Failed to update ad data: $e");
       }
     }else{



       try {
           await FirebaseFirestore.instance.collection
             ('ads').doc(adId).update({
             'title':titleController.text,
             'des':desController.text,
           });
           print("Ad data updated successfully.");
            print("Ad data updated successfully.");
            Get.snackbar('', 'تم تعديل اعلانك بنجاح');
            
           isLoading=false;
          Get.back();
           update();

       } catch (e) {
         print("Failed to update ad data: $e");
       }

     }

  }

    }












