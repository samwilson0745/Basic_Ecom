import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comm/controller/cart_controller.dart';
import 'package:e_comm/controller/home_controlerr.dart';
import 'package:e_comm/controller/order_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'frontPages/SignUp.dart';
import 'frontPages/login.dart';
import 'mainPages/cartPage.dart';
import 'mainPages/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

//we are creating class instances



void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value){

    //this is done so that we can access the controllers from anywhere
    Get.put(HomeController());
    Get.put(CartController());
    Get.put(OrderController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx,snapshot){
          if(snapshot.hasData){
            return homePage();
          }
          else{
            return Login();
          }
          return Container(
            color: Colors.white,
            height:MediaQuery.of(context).size.height ,
            width:MediaQuery.of(context).size.width,
            child: Text('Something went Wrong'),
          );
        },
      )
    );
  }
}
