



// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

 import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:yemen_services_dashboard/core/theme/colors.dart';
import 'package:yemen_services_dashboard/features/offers/controller/offers_controller.dart';
import 'package:yemen_services_dashboard/features/offers/custom_text.dart';
import 'package:yemen_services_dashboard/features/offers/cutom_button.dart';

import 'get_offers_view.dart';

class AddAdView extends StatefulWidget {
  const AddAdView({super.key});

  @override
  State<AddAdView> createState() => _AddAdViewState();
}


 AdController controller = Get.put(AdController());
  String? _imageUrl;
  String? _uploadedFileURL;
class _AddAdViewState extends State<AddAdView> {
 
  @override
  void initState() {
   // controller.getUserData();
    controller.getCats().then((v) {

    });
    // controller.getSubCats(widget.cat).then((v) {});
    super.initState();
  }


   Future<void> imgFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Immediately set the image URL to display in the dialog
      setState(() {
        _imageUrl = pickedFile.path; // Set the picked image path
      });
      // Read the image as bytes for upload
      Uint8List imageData = await pickedFile.readAsBytes();
      // ignore: avoid_print
      print('picked');
      uploadImage(imageData);
    }
  }

    Future<String> uploadImage(Uint8List xfile) async {
    Reference ref = FirebaseStorage.instance.ref().child('Folder');
    String id = const Uuid().v1();
    ref = ref.child(id);

    UploadTask uploadTask = ref.putData(
      xfile,
      SettableMetadata(contentType:'image/png'),
    );
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      _uploadedFileURL = downloadUrl;
    });
    print(downloadUrl);
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdController>(
      builder: (_) {
        return Scaffold(
          backgroundColor:Colors.white,
        //  appBar:CustomAppBar('addAdd'.tr, context),
          body:Padding(
            padding: const EdgeInsets.all(11.0),
            child: ListView(children: [

              const SizedBox(height: 22,),

              CustomButton(
                  color1:primaryColor,
                  text: 'عرض الاعلانات المتاحة بالتطبيق', onPressed: (){

                print("AD...");

                Get.to(const GetOffersView());

              }),
                const SizedBox(height: 22,),

                const Divider(color: Colors.grey,),
                    const SizedBox(height: 22,),

                    const Center(
                      child: Text('اضافة اعلانات جديدة',
                      style:TextStyle(color:primaryColor,
                      fontSize: 22,fontWeight: FontWeight.bold
                      ),
                      ),
                    ),

                Text('صورة القسم الجديد',
                            style: GoogleFonts.cairo(fontSize: 18)),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 150,
                          width: 200,
                          child: GestureDetector(
                            onTap: () async {
                              await imgFromGallery();
                              setState(
                                  () {}); // Call setState inside dialog to update the UI after image is picked
                            },
                            child: _imageUrl == null
                                ? Container(
                                    width: double.infinity,
                                    height: 180,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.image,
                                        color: Colors.grey[600]),
                                  )
                                : Image.network(
                                    _imageUrl!, // Display selected image
                                    width: double.infinity,
                                    height: 430,
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),


              
              const SizedBox(height: 16,),
             const Divider(),
              const SizedBox(height: 16,),
              const Text("عنوان الاعلان",
                style: TextStyle(
                    color:Colors.black,
                    fontSize: 20,fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(height: 12,),
              CustomTextFormField(hint: 'عنوان الاعلان',
                  obs: false,
                  controller: controller.titleController),

              const SizedBox(height: 12,),

              Text("وصف الاعلان ",
              style:TextStyle(
                color:secondaryTextColor,
                fontSize: 20,fontWeight: FontWeight.w600
              ),
              ),
              const SizedBox(height: 12,),
              CustomTextFormField(hint: 'الوصف',
                  obs: false,
                  max: 6,
                  controller: controller.desController),


              const SizedBox(height: 12,),


              Text(
                'القسم الاساسي'.tr,
                style: TextStyle(
                    color:secondaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.83,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Colors.white),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  value: controller.selectedCat,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.changeCatValue(newValue);
                    }
                  },
                  items: controller.catListNames
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          value,
                          style: GoogleFonts.cairo(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              Text(
                'القسم الفرعي '.tr,
                style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.83,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Colors.white),
                child: DropdownButton<String>(
                  underline: const SizedBox.shrink(),
                  isExpanded: true,
                  value: controller.selectedSubCat,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.changeSubCatValue(newValue);
                    }
                  },
                  items: controller.subCatListNames
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          value,
                          style: GoogleFonts.cairo(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

             const SizedBox(height: 11,),


              Text(
                'مدة الاعلان'.tr,
                style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.83,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Colors.white),
                child: DropdownButton<String>(
                  underline: const SizedBox.shrink(),
                  isExpanded: true,
                  value: controller.selectedDays,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.changeDayListValue(newValue);
                    }
                  },
                  items: controller.daysList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          value,
                          style: GoogleFonts.cairo(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text('السعر'+"  =  "+controller.price
                    +" "+'DA',
                style:TextStyle(
                  color: secondaryTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22
                ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),



              (controller.isLoading==false)?
              Padding(
                padding: const EdgeInsets.only(left:28.0,
                right: 28
                ),
                child: CustomButton(
                    color1: primaryColor,
                    text: 'اضف'.tr, onPressed: () async {

                  await controller.addNewAdToFirestore(
                    context,_imageUrl!
                  );

                  Get.snackbar('', 'تم اضافة الاعلان بنجاح',
                      backgroundColor:Colors.green,
                      colorText:Colors.white);

                      Future.delayed(const Duration(seconds: 2), () {
                
                 setState(() {
                  
                    _imageUrl = null;
                  
                  });       
             
              });
                 
                }),
              ):const Center(
                child:CircularProgressIndicator(),
              ),
              const SizedBox(height: 22,),

              //  Get.off(Routes.LOGIN);
               // Get.off(const LoginView());

            ],),
          ),
        );
      }
    );
  }
  Widget buildGridView() {
    return InkWell(
      child: SizedBox(
        height: 342,
      //  width: MediaQuery.of(context).size.width * 0.5,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey[200]),
                child: ClipRRect(
                    borderRadius:BorderRadius.circular(14),
                    child: Image.file(File
                      (controller.images[0].path)))),
          ),
        ),
      ),
      onTap:(){
        controller.pickMultipleImages();
      },
    );
    // return InkWell(
    //   child: GridView.builder(
    //     shrinkWrap: true,
    //     itemCount: controller.images.length,
    //     gridDelegate:
    //     const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    //     itemBuilder: (BuildContext context, int index) {
    //       return Padding(
    //         padding: const EdgeInsets.all(1.0),
    //         child: Container(
    //             decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(7),
    //                 color: Colors.grey[200]),
    //             child: ClipRRect(
    //                 borderRadius:BorderRadius.circular(14),
    //                 child: Image.file(File
    //                   (controller.images[index].path)))),
    //       );
    //     },
    //   ),
    //   onTap: () {
    //     controller.pickMultipleImages();
    //   },
    // );
  }
}

