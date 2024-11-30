

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yemen_services_dashboard/core/theme/colors.dart';

import '../../orders/model/proposal.dart';


class StController extends GetxController {


List<Proposal>proposalList=[];
List<Proposal>buySerivcesList=[];


Color color = Colors.white;
Color color2 = Colors.white;
Color color3 = Colors.white;


Color textColor = Colors.black;
Color textColor2 = Colors.black;
Color textColor3 = Colors.black;


List<String>statusList=['مهام مطروحة',
  'مهام مكتملة',
  'مهام قيد التنفيذ','مهام ملغاه',
  'جميع المهام'
];

String selectedStatus= 'جميع المهام';


bool isLoading=false;

changeSelectedStatusForBuyServices(String status){
  selectedStatus=status;
  update();
  String st='';
  if(status=='جميع المهام'){
    st='x';
  }
  if( status=='مهام مطروحة'){
    st='pending';
  }

  if( status=='مهام ملغاه'){
    st='canceled';
  }

  if( status=='مهام قيد التنفيذ'){
    st='accepted';
  }
  if( status=='مهام مكتملة'){
    st='done';
  }
  getBuyServicesWithStatus(st);
}

changeSelectedStatus(String status){

  selectedStatus=status;

  String st='';
  if(status=='جميع المهام'){
    st='x';
    //update();
  }
  if(status=='مهام قيد المراجعة'){
    st='قيد المراجعة';
   // update();
  }

  if( status=='المهام المرفوضة'){
    st='canceled';
  //  update();
  }

  if( status=='المهام المقبولة'){
    st='accepted';
   // update();
  }
  if( status=='المهام المنتهية'){
    st='done';
   // update();
  }
  ///update();
  //print("ST====="+st);
  getWorkerProposalWithStatus(st);
}

changeColor(int index){

  String status='قيد المراجعة';
  if(index==0){
    color = primary;
    color2 = Colors.white;
    color3 = Colors.white;
     textColor = Colors.white;
    textColor2 = Colors.black;
     textColor3 = Colors.black;
    status='قيد المراجعة';
  }

  if(index==1){
    color2 = primary;
    color = Colors.white;
    color3 = Colors.white;
    textColor2 = Colors.white;
    textColor = Colors.black;
    textColor3 = Colors.black;
    status='accepted';
  }
  if(index==2){
    color3 = primary;
    color = Colors.white;
    color2 = Colors.white;
    textColor3 = Colors.white;
    textColor2 = Colors.black;
    textColor = Colors.black;
    status='canceled';
  }
  getWorkerProposalWithStatus(status);
update();

}


bool isBuyServicesLoading=false;

int doneBuyTasks=0;
int refusedBuyTasks=0;
int pendingBuyTasks=0;
int acceptedBuyTasks=0;
int allBuyTasks=0;



Future<void> updateWorkerToken
    () async {

  final box=GetStorage();



String workerDeviceToken
=box.read('WorkerDeviceToken')??'x';

if(workerDeviceToken=='x'){
  try {
    String? token =
    await FirebaseMessaging.instance.getToken();
    String email=box.read('email');
    print("TOKE====${token!}");
    // Reference to the users collection
    final usersCollection =
    FirebaseFirestore.instance.
    collection('serviceProviders');
    // Find the user document by email and update the token field
    await usersCollection
        .where('email', isEqualTo: email)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Update the token field in the document
        snapshot.docs.first.reference.
        update({'fcmToken': token});
      }
      box.write('WorkerDeviceToken', token);
    });
    print("Token updated successfully!");
  } catch (e) {
    print("Error updating token: $e");
  }
}else{
  print("========Token already exists=======");
}

}

getWorkerBuyServices()async{
   doneBuyTasks=0;
   refusedBuyTasks=0;
   pendingBuyTasks=0;
  acceptedBuyTasks=0;
  allBuyTasks=0;
   isBuyServicesLoading=true;
  // buySerivcesList=[];
  // update();
  print("GET WORKER BUY SERVICES...............");
  try {
    print("GET PROPOSALS");
    // Fetch all documents from the 'ads' collection
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.
    collection('buyService').
        //.where('worker_email',isEqualTo:email)
    // .where('user_email',isEqualTo: 'test@gmail.com')
      get();
    buySerivcesList = querySnapshot.docs.map((DocumentSnapshot doc) {
      return Proposal.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
    update();
    for(int i=0;i<buySerivcesList.length;i++){
      if(buySerivcesList[i].status=='done'){
        doneBuyTasks++;
      }
      if(buySerivcesList[i].status=='canceled'){
        refusedBuyTasks++;
      }
      if(buySerivcesList[i].status=='accepted'){
        acceptedBuyTasks++;
      }
      if(buySerivcesList[i].status=='قيد المراجعة'||
      buySerivcesList[i].status=='pending'
      ){
        pendingBuyTasks++;
      }
    }
  } catch (e) {
    print("Error fetching ads: $e");
  }
  isBuyServicesLoading=true;
  update();
}

getBuyServicesWithStatus(String status)async{
  print("ST========$status");
  if(status=='x'){
    getWorkerBuyServices();
  }else{
    print("GET PROPOSALS...............");
    buySerivcesList=[];
    try {
      print("GET PROPOSALS");
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('buyService')
       //   .where('worker_email',isEqualTo:email).
      .where('status',isEqualTo: status)
      // .where('user_email',isEqualTo: 'test@gmail.com')
          .get();
      buySerivcesList =
          querySnapshot.docs.map((DocumentSnapshot doc) {
        return Proposal.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      update();
      print("Tasks loaded: ${buySerivcesList.length} Tasks found.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
  }

}


getWorkerProposalWithStatus(String status)async{
  print("HERE ST=====WITH STATUS.........==$status");

  if(status=='pending'){

    //   .where('status', whereIn: ['pending', 'قيد المراجعة']

    print("GET PROPOSALS...............");
    proposalList=[];

    try {
      print("GET PROPOSALS");
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance
          .collection('proposals')
          .where('status', whereIn: ['pending', 'قيد المراجعة'])
      // .where('user_email',isEqualTo: 'test@gmail.com')
          .get();
      proposalList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return Proposal.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      isLoading=true;
      update();
      print("Tasks loaded: ${proposalList.length} Tasks found.");
    } catch (e) {
      print("Error fetching ads: $e");

    }

  }else{

    print("GET PROPOSALS...............");
    proposalList=[];

    try {
      print("GET PROPOSALS");
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance
          .collection('proposals')
          .where('status',isEqualTo: status)
      // .where('user_email',isEqualTo: 'test@gmail.com')
          .get();
      proposalList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return Proposal.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      isLoading=true;
      update();
      print("Tasks loaded: ${proposalList.length} Tasks found.");
    } catch (e) {
      print("Error fetching ads: $e");

    }
  }

}


 int doneTasks=0;
 int refusedTasks=0;
 int pendingTasks=0;
 int acceptedTasks=0;
 int allTasks=0;


String name='';
Future<String?> getUserNameFromTask(String taskId) async {
  print("ID===$taskId");
  try {
    // Reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Query the `tasks` collection with the given taskId
    DocumentSnapshot taskSnapshot = await firestore
        .collection('tasks')
        .doc(taskId)
        .get();

    // Check if the document exists
    if (taskSnapshot.exists) {
      // Retrieve the `user_name` from the document
      String userName = taskSnapshot.get('user_name');


      name=userName;
      return userName;
    } else {
      print("Task not found");
      return null;
    }
  } catch (e) {
    print("Error retrieving user_name: $e");
    return null;
  }
  update();
}




Future<void> openMap(double latitude, double longitude) async {
  String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  if (await canLaunchUrl(Uri.parse(googleUrl))) {
    await launchUrl(Uri.parse(googleUrl));
  } else {
    await launchUrl(Uri.parse(googleUrl));
    //throw 'Could not open the map.';
  }
}


// List<WorkerProvider>workerList=[];

// getWorkerData()async{
//   final box=GetStorage();
//   String email=box.read('email');
//   try {
//     print("GET PROPOSALS");
//     // Fetch all documents from the 'ads' collection
//     QuerySnapshot querySnapshot =
//     await FirebaseFirestore.instance.
//     collection('serviceProviders')
//         .where('email',isEqualTo:email)
//     // .where('user_email',isEqualTo: 'test@gmail.com')
//         .get();
//     workerList = querySnapshot.docs.map
//       ((DocumentSnapshot doc) {
//       return WorkerProvider
//           .fromFirestore(doc.data()
//       as Map<String, dynamic>, doc.id);
//     }).toList();

//     update();
//     print("WORKER DATA loaded: ${workerList.length} .......");
//   } catch (e) {
//     print("Error fetching ads: $e");
//   }
// }

getWorkerProposal()async{
  isLoading=false;
  update();
  doneTasks=0;
  refusedTasks=0;
  pendingTasks=0;
  acceptedTasks=0;
  allTasks=0;
    try {
      print("GET PROPOSALS");
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('proposals')
     // .where('user_email',isEqualTo: 'test@gmail.com')
      .get();
      proposalList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return Proposal.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      for(int i=0;i<proposalList.length;i++){
        if(proposalList[i].status=='done'){
          doneTasks++;
        }
        if(proposalList[i].status=='canceled'){
          refusedTasks++;
        }
        if(proposalList[i].status=='accepted'){
          acceptedTasks++;
        }
        if(proposalList[i].status=='قيد المراجعة'|| proposalList[i].status=='pending'){
          pendingTasks++;
        }
      }
      
      print("Tasks loaded: ${proposalList.length} Tasks found.");
      isLoading=true;
      update();
    } catch (e) {
      print("Error fetching ads: $e");
    }
}


  getWorkerProposalWithSt(String st)async{
    isLoading=false;
    update();
    doneTasks=0;
    refusedTasks=0;
    pendingTasks=0;
    acceptedTasks=0;
    allTasks=0;
    try {
      print("GET PROPOSALS");
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('proposals')
       .where('status',isEqualTo: st)
          .get();
      proposalList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return Proposal.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      print("Tasks loaded: ${proposalList.length} Tasks found.");
      isLoading=true;
      update();
    } catch (e) {
      print("Error fetching ads: $e");
    }
  }

Future<void> updateWorkerStatus(String status,String id) async {
  final box=GetStorage();
  String email=box.read('email');
  print("EMAIL==$email");
  try {
    // Reference the 'buyService' collection
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('buyService');

    // Query documents where 'worker_email' matches the provided email
    QuerySnapshot querySnapshot =
    await collectionRef
        .where('id', isEqualTo: id)
        .get();

    // Loop through the documents to update each one's status to 'done'
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'status': status});
    }
    getWorkerBuyServices();
    print("Status updated to 'done' for worker with email: $email");
  } catch (e) {
    print("Error updating status: $e");
  }
}


}