import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Product{
   final String name;
   final String image;
   final double price;

  Product(@required this.name,@required this.image,@required this.price);

  Map<String , dynamic> toJson() =>{
    'image':image,
    'name':name,
    'price':price
  };
  static Product fromJson(Map<String,dynamic> json)=> Product(
    json['name'],
    json['image'],
    json['price']
  );
}
class GetStudentName extends StatelessWidget {
  final String documentId;

  GetStudentName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference students = FirebaseFirestore.instance.collection('students');

    return FutureBuilder<DocumentSnapshot>(
      //Fetching data from the documentId specified of the student
      future: students.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {


        //Error Handling conditions
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        //Data is output to the user
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        return Text("loading");
      },
    );
  }
}