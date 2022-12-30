import 'package:e_comm/controller/order_controller.dart';
import 'package:e_comm/model/CartItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

OrderController controller=Get.find();

class CartController extends GetxController{

  RxList<Cart> cartItems = <Cart>[].obs ;
  double get totalPrice => cartItems.fold(0,(sum, element) => sum+(element.price*(element.quantity.toInt())));
  final String uid=FirebaseAuth.instance.currentUser!.uid;

  @override
  void onInit(){
    super.onInit();
    fetchCartItems();
  }

  void len(){
    print(cartItems.length);
  }

  fetchCartItems()async{
    var snapshots=await FirebaseFirestore.instance.collection('user').doc(uid).collection('cart').snapshots();
    var result=<Cart>[];
    snapshots.forEach((element){
      for(int i=0;i<element.docs.length;i++){
        result.add(
          Cart(element.docs[i]['name'], element.docs[i]['image'], element.docs[i]['color'], element.docs[i]['size'], element.docs[i]['price'], element.docs[i]['quantity'],element.docs[i].id)
       );
      }
    });
    cartItems.value=result;
    cartItems.refresh();
  }

  removeFromCart(Object product,String productID)async{
    cartItems.remove(product);
    await FirebaseFirestore.instance.collection('user').doc(uid).collection('cart').doc(productID).delete();
  }

  addtoCart(Cart product)async{
    final data = FirebaseFirestore.instance.collection('user').doc(uid).collection('cart').doc(product.productId);
    final json={
      'image':product.image,
      'name':product.name,
      'price':product.price,
      'size':product.size,
      'color':product.color,
      'quantity':product.quantity,
    };
    await data.set(json);
    fetchCartItems();
  }

  addtoOrder(){
    cartItems.forEach((element) async{
      final data=FirebaseFirestore.instance.collection('user').doc(uid).collection('orders').doc(element.productId);
      final json={
        'image':element.image,
        'name':element.name,
        'price':element.price,
        'size':element.size,
        'color':element.color,
        'quantity':element.quantity,
        'totalPrice':element.quantity*element.price
      };
      print('removed');
      await data.set(json);
    });
  }
}