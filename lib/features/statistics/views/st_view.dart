


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yemen_services_dashboard/core/theme/colors.dart';
import 'package:yemen_services_dashboard/features/offers/cutom_button.dart';
import 'package:yemen_services_dashboard/features/statistics/controller/st_controller.dart';
import 'package:yemen_services_dashboard/features/statistics/views/st4.dart';
import 'st2.dart';

class WorkersHome extends StatefulWidget {
  const WorkersHome({super.key});

  @override
  State<WorkersHome> createState() => _WorkersHomeState();
}

class _WorkersHomeState extends State<WorkersHome> {
 StController controller = Get.put(StController());

  @override
  void initState() {
    controller.getWorkerProposal();
    controller.getWorkerBuyServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.2,
            backgroundColor: primary),

          body: Padding(
            padding:  const EdgeInsets.all(8.0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [

                const SizedBox(height: 12),
              // CustomButton(text: 'عرض الخدمات', onPressed: () {
              //   Get.to(WorkerTasks2
              //     (statusType: 'x'
              //   ));
              // }),

               
              

            Divider(color: Colors.grey[200]!,
            ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [

                     const SizedBox(width: 8,),
                      Text("  احصائيات عن الخدمات المعروضة",style: TextStyle(
                          color:secondaryTextColor,
                          fontSize: 21,fontWeight:FontWeight.bold
                      )),
                    ],
                  ),
                ),



                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                  InkWell(
                    child: StWidget(
                      txt: 'مهام  مطروحة ',
                      number:controller.pendingTasks.toString()
                    ),
                    onTap:(){

                      Get.to(WorkerTasks2(statusType: 'pending',
                        title: 'مهام  مطروحة ',
                      ));


                    },
                  ),

                  InkWell(
                    child: StWidget(
                      txt: 'مهام مكتملة',
                      number:controller.doneTasks.toString()
                    ),
                    onTap:(){

                      Get.to(WorkerTasks2(statusType: 'done',

                      title:'مهام مكتملة',
                      ));

                    },
                  ),
                ],),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: StWidget(
                          txt: 'مهام قيد التنفيذ',
                          number:controller.acceptedTasks.toString()
                      ),
                      onTap: (){

                        Get.to(WorkerTasks2(statusType: 'accepted',
                        title: 'مهام قيد التنفيذ',
                        ));



                      },
                    ),

                    InkWell(
                      child: StWidget(
                          txt: 'مهام ملغاه',
                          number:controller.refusedTasks.toString()
                      ),
                      onTap:(){

                        Get.to(WorkerTasks2(statusType: 'cancelled',
                        title:'مهام ملغاه',
                        ));
                      },
                    ),
                  ],),
                const SizedBox(height: 7),
                const Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [


                    StWidget(
                        txt: 'رصيدك',
                        number:'0'
                    ),
                  ],),

               const SizedBox(height: 5,),
                Divider(height: 20, thickness: 0.2,
                  color:greyTextColor,
                ),

                // CustomButton(text: 'عرض الطلبات المباشرة', onPressed: () {
                //   Get.to(ServicesOrders
                //     (statusType: 'x'
                //   ));
                // }),
                // const SizedBox(height:20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [

                      // SvgPicture.asset('assets/images/st.svg',
                      //   height: 20,color: buttonColor,
                      // ),
                      //  Image.asset('assets/images/st2.webp',
                      // // width: ,
                      //    height: 42
                      //  ),
                      const SizedBox(width: 8,),
                      Text("  احصائيات عن طلباتك المباشرة",style: TextStyle(
                          color:secondaryTextColor,
                          fontSize: 21,fontWeight:FontWeight.bold
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: StWidget(
                          txt: 'مهام  مطروحة ',
                          number:controller
                              .pendingBuyTasks.toString()
                      ),
                      onTap:(){
                        Get.to(ServicesOrders
                          (statusType: 'pending'
                        ));
                        //  Get.to(WorkerTasks2
                        //   (
                        //   statusType: 'مهام قيد المراجعة'
                        // ));

                      },
                    ),

                    InkWell(
                      child: StWidget(
                          txt: 'مهام مكتملة',
                          number:controller
                              .doneBuyTasks.toString()
                      ),
                      onTap:(){
                        Get.to(ServicesOrders
                          (statusType: 'done'
                        ));
//             Get.to(UserTasksView(statusType: 'المهام المنتهية'));
//                         Get.to(WorkerTasks2
//                           (
//                             statusType: 'المهام المنتهية'
//                         ));
                      },
                    ),
                  ],),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: StWidget(
                          txt: 'مهام قيد التنفيذ',
                          number:
                          controller
                              .acceptedBuyTasks.toString()
                      ),
                      onTap: (){
                        Get.to(ServicesOrders
                          (statusType: 'accepted'
                        ));


                   // Get.to(WorkerTasks2
                   //        (
                   //          statusType: 'المهام المقبولة')
                   //      );

                      },
                    ),

                    InkWell(
                      child: StWidget(
                          txt: 'مهام ملغاه',
                          number:controller.refusedBuyTasks.toString()
                      ),
                      onTap:(){
                        Get.to(ServicesOrders
                          (statusType: 'cancelled'
                        ));

                        //
                        // Get.to(WorkerTasks2
                        //   (
                        //     statusType: 'المهام المرفوضة'
                        // )
                        // );

                      },
                    ),
                  ],),
                const SizedBox(height: 7),

                Divider(height: 20, thickness: 0.2,
                  color:greyTextColor,
                ),
                const SizedBox(height: 5,),

                // Task List Section
               
              ],
            ),
          ),
        );
      },
    );
  }



  // Widget for when the task list is empty
  Widget _buildEmptyTaskState() {
    return Center(
      child: Column(
        children: [
          // Image.asset(
          //   AppAssets.emptyTasks,
          //   height: 300,
          // ),
          const SizedBox(height: 20),
          Text(
            "لا يوجد مهام",
            style: TextStyle(
              color: secondaryTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}

class StWidget extends StatelessWidget {
  final String txt;
  final String number;

  const StWidget({super.key, required this.txt, required this.number});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: 310,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          color: primary.withOpacity(0.9),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Column(
            children: [
              Text(
                txt,
                style: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                number,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class FeaturesSection extends StatelessWidget {
//   const FeaturesSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: primary.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: Custom_Text(
//               text: 'مميزات التعامل من خلال التطبيق',
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: secondaryTextColor,
//             ),
//           ),
//           const SizedBox(height: 12),
//           const FeatureItem(
//             icon: Icons.star_border,
//             text:
//                 '١- الحصول على تقييم جيد يعطيك إمكانية اختيارك في الكثير من الأعمال',
//           ),
//           const SizedBox(height: 8),
//           const FeatureItem(
//             icon: Icons.work_outline,
//             text:
//                 '٢- يتم ظهور عدد مشاريعك للعملاء مما يوفر لك فرص عمل أقوى وأكثر',
//           ),
//           const SizedBox(height: 8),
//           const FeatureItem(
//             icon: Icons.security_outlined,
//             text: '٣- التطبيق يساعد في ضمان حقوقك',
//           ),
//           const SizedBox(height: 8),
//           const FeatureItem(
//             icon: Icons.card_giftcard,
//             text:
//                 '٤- مستقبلاً سيتم إضافة ميزات للفنيين الأكثر عملاً وتحصيل نقاط كهدايا',
//           ),
//           const SizedBox(height: 8),
//           const FeatureItem(
//             icon: Icons.warning_amber_outlined,
//             text: '٥- التعامل الخارجي يعد مخالفة لسياستنا وقد يعرض حسابك للحظر',
//           ),

//         ],
//       ),
//     );
//   }
// }

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color:primary, size: 28),
        const SizedBox(width: 12),
        // Expanded(
        //   child: Custom_Text(
        //     text: text,
        //     fontSize: 18,
        //     color: secondaryTextColor,
        //     fontWeight: FontWeight.w500,
        //   ),
        // ),
      ],
    );
  }
}
