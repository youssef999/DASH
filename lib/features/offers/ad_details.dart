

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yemen_services_dashboard/features/offers/cutom_button.dart';
import 'package:yemen_services_dashboard/features/offers/model/ads_model.dart';

import 'controller/offers_controller.dart';

// ignore: must_be_immutable
class AdDetails extends StatelessWidget {
  Ad ad;
   AdDetails({super.key,required this.ad});

  @override
  Widget build(BuildContext context) {
      // Convert Timestamp to DateTime
  DateTime dateTime = ad.startDate.toDate();
 DateTime endDateTime = ad.endDate.toDate();
  // Format DateTime to String (using intl package for custom format)
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  String endFormattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(endDateTime);
   AdController controller=Get.put(AdController());
    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          const SizedBox(height: 22,),
          ClipRRect(
            borderRadius:BorderRadius.circular(14),
            child: Image.network(ad.imageUrl,height: 250,width: 500,fit: BoxFit.contain,),
          ),
          const SizedBox(height: 12,),
         const Padding(
           padding: EdgeInsets.all(8.0),
           child: Divider(color: Colors.blue,),
         ),
          Row(
            children: [
              const Text('  الاسم ',style:TextStyle(color:Colors.black,fontSize: 18,),),
              const SizedBox(width: 22,),
              Text(ad.title,style:const TextStyle(color:Colors.black,fontSize: 22,fontWeight: FontWeight.bold),),
            ],
          ),
          const SizedBox(height: 12,),
          Row(
            children: [
               const Text(' الوصف ',style:TextStyle(color:Colors.black,fontSize: 18,),),
               const SizedBox(width: 22,),
              Text(ad.des,style:const TextStyle(color:Colors.black,fontSize: 18,),),
            ],
          ),
            const SizedBox(height: 12,),

         const SizedBox(height: 12,),
          Row(
            children: [
              const Text('التصنيف',style:TextStyle(color:Colors.black,fontSize: 18,),),
              const SizedBox(width: 12,),
              Text(ad.cat,style:const TextStyle(color:Colors.blue,fontSize: 18,),),
            ],
          ),
            const SizedBox(height: 12,),

            Row(
              children: [
                const Text('تاريخ البدء',style:TextStyle(color:Colors.black,fontSize: 18,),),
               const SizedBox(width: 22,),
                Text(formattedDate,style:const TextStyle(color:Colors.black,fontSize: 18,),),
              ],
            ),
            const SizedBox(height: 12,),
             Row(
               children: [
                 const Text('تاريخ نهاية الاعلان',style:TextStyle(color:Colors.black,fontSize: 18,),),
                 const SizedBox(width: 22,),
                 Text(endFormattedDate,style:const TextStyle(color:Colors.black,fontSize: 18,),),
               ],
             ),
            const SizedBox(height: 12,),

            Row(children: [
              CustomButton(text: ' حذف الاعلان ', onPressed: (){

                controller.deleteAdById(ad.id);

              })
            ],)

        ],),
      ),
    );
  }
}