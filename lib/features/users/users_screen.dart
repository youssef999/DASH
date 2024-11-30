import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String _searchQuery = '';
  bool _isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المستخدمين',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              icon: const Icon(
                Icons.search,
                size: 40,
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value; // Update the search query
                  });
                },
                decoration: InputDecoration(
                  labelText: 'ابحث عن مستخدم',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: const Icon(Icons.search),
                ),
                style: GoogleFonts.cairo(),
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد مستخدمين',
                      style: GoogleFonts.cairo(),
                    ),
                  );
                }

                // Filter users based on the search query
                var filteredUsers = snapshot.data!.docs.where((user) {
                  String name = user['name'] ?? '';
                  String email = user['email'] ?? '';
                  return name.contains(_searchQuery) ||
                      email.contains(_searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    var user = filteredUsers[index];
                    return _buildUserCard(user);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(QueryDocumentSnapshot user) {
    String email = user['email'] ?? 'لا يوجد بريد';
    String imageUrl = user['image'] ?? '';
    String name = user['name'] ?? 'لا يوجد اسم';
    String phone = user['phone'] ?? 'لا يوجد رقم';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: imageUrl.isNotEmpty
              ? NetworkImage(
              imageUrl)
              : const AssetImage(
                      'assets/images/default_avatar.png') // Placeholder image
                  as ImageProvider,
        ),
        title: Text(
          name,
          style: GoogleFonts.cairo(),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(email, style: GoogleFonts.cairo()),
            Text(phone, style: GoogleFonts.cairo()),
          ],
        ),
        trailing:IconButton(
          icon:const Icon(Icons.delete,
          size: 33,color:Colors.redAccent,
          ),
          onPressed:(){
            showDeleteDialog(context,user.id);

          },
        ),
      ),
    );
  }
}

void showDeleteDialog(BuildContext context,String id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذاالمستخدم ؟'),
        actions: <Widget>[
          TextButton(
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
            onPressed: () {
              FirebaseFirestore.instance.collection('users').doc(id).delete();
              // Add your delete action here
              Navigator.of(context).pop();

              Get.snackbar('', 'تم الحذف بنجاح',
              backgroundColor:Colors.green,
              colorText:Colors.white);
            },
          ),
          TextButton(
            child: const Text('الغاء', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}