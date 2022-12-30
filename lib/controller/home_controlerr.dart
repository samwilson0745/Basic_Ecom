import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/Product.dart';

class HomeController extends GetxController{
  static HomeController instance = Get.find();
  var products = <Product>[].obs;

  @override
  void onInit(){
    super.onInit();
    fetchProducts();
  }

 String getId(){
    return FirebaseAuth.instance.currentUser!.uid;
 }

  void fetchProducts()async{
    var snapshots=await FirebaseFirestore.instance.collection("products").doc('C8tB27Gs3N3u9NSVLRvI').collection('featuredProduct').snapshots();
    var result=<Product>[];
    snapshots.forEach((element) {
      for(int i=0;i<element.docs.length;i++){
        result.add(
          Product(
            element.docs[i].id,
            element.docs[i]['name'],
              element.docs[i]['image'],
            element.docs[i]['description'],
            element.docs[i]['price']
          )
        );
      }
    });
    products.value=result;
  }
}