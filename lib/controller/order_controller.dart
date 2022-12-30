import 'package:e_comm/model/Order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderController extends GetxController{

  RxList<OrderItem> orderItems = <OrderItem>[].obs;
  double get totalPrice => orderItems.fold(0,(sum, element) => sum+(element.price*(element.quantity.toInt())));
  final String uid=FirebaseAuth.instance.currentUser!.uid;

  @override
  void onInit(){
    super.onInit();
    fetchOrderItems();
  }

  fetchOrderItems()async{
    var snapshots=await FirebaseFirestore.instance.collection('user').doc(uid).collection('orders').snapshots();
    var result=<OrderItem>[];
    snapshots.forEach((element){
      for(int i=0;i<element.docs.length;i++){
        result.add(
          OrderItem(element.docs[i]['name'],element.docs[i]['image'],element.docs[i]['color'],element.docs[i]['size'],element.docs[i]['price'],element.docs[i]['quantity'],element.docs[i].id,element.docs[i]['totalPrice'])
        );
      }
    });
    orderItems.value=result;
    orderItems.refresh();
    print('hello');
  }

  Future addtoOrder(OrderItem product)async{
    final data=FirebaseFirestore.instance.collection('user').doc(uid).collection('orders').doc(product.productId);
    final json={
      'image':product.image,
      'name':product.name,
      'price':product.price,
      'size':product.size,
      'color':product.color,
      'quantity':product.quantity,
      'totalPrice':product.quantity*product.price
    };
    await data.set(json);
    fetchOrderItems();
  }

  removeFromOrder(Object product,String productId)async{
    orderItems.remove(product);
    await FirebaseFirestore.instance.collection('user').doc(uid).collection('orders').doc(productId).delete();
  }

}
