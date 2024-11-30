


 import 'package:flutter/material.dart';
import 'package:yemen_services_dashboard/core/theme/colors.dart';

class RequestMoney extends StatefulWidget {
   const RequestMoney({super.key});

   @override
   State<RequestMoney> createState() => _RequestMoneyState();
 }

 class _RequestMoneyState extends State<RequestMoney> {
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar:AppBar(
         backgroundColor:primaryColor,
         title: const Text('طلب رسوم',
         style:TextStyle(color:Colors.white,
         fontWeight: FontWeight.bold,
           fontSize: 21
         ),
         ),
       ),
       body:Padding(
         padding: const EdgeInsets.all(8.0),
         child: ListView(children: [
           SizedBox(height: 19,),


         ],),
       ),
     );
   }
 }
