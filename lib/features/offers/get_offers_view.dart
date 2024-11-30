


// ignore_for_file: must_be_immutable

  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yemen_services_dashboard/features/offers/ad_details.dart';
import 'package:yemen_services_dashboard/features/offers/controller/offers_controller.dart';
import 'package:yemen_services_dashboard/features/offers/model/ads_model.dart';

class GetOffersView extends StatefulWidget {
  const GetOffersView({super.key});

  @override
  State<GetOffersView> createState() => _GetOffersViewState();
}
class _GetOffersViewState extends State<GetOffersView> {
  
  AdController controller=Get.put(AdController());

  @override
  void initState() {
    controller.getAds();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الاعلانات",style:TextStyle(color:Colors.white,fontSize: 21),),
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<AdController>(
          builder: (_) {
            return ListView(children:  [
              const SizedBox(height: 22,),
           (controller.adsList.isNotEmpty)?
              GridView.builder(
                shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          mainAxisSpacing: 10.0, // Spacing between rows
          crossAxisSpacing: 10.0, // Spacing between columns
          childAspectRatio: 1.7, // Aspect ratio of each item
        ),
        itemCount: controller.adsList.length, // Total number of items in the grid
        itemBuilder: (BuildContext context, int index) {

          return AdWidget(ad:controller.adsList[index]);


        }):const Center(
          child: CircularProgressIndicator(),
        )
              




              
            ],);
          }
        ),
      ),
    );
  }
}

class AdWidget extends StatelessWidget {
  Ad ad;
   AdWidget({super.key,required this.ad});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration:BoxDecoration(
          borderRadius:BorderRadius.circular(14),
          color:Colors.grey[200]
        ),
        child:Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:Image.network
              (
                Uri.encodeFull(ad.imageUrl),
              //  ad.imageUrl,
                height: 250,width: 500,fit: BoxFit.cover,),
            ),
            const SizedBox(height: 12,),
            Text(ad.title,style:const TextStyle(color:Colors.black,fontSize: 22,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
      onTap:(){

        Get.to(AdDetails(
          ad: ad,
        ));

        
      },
    );
  }
}