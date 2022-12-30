import 'package:e_comm/controller/cart_controller.dart';
import 'package:e_comm/controller/order_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_comm/model/CartItem.dart';

OrderController orderController = Get.find();
CartController cartController= Get.find();

class cartPage extends StatefulWidget {

  @override
  State<cartPage> createState() => _cartPageState();
}

class _cartPageState extends State<cartPage> {

  int _quantity=1,total=0;
  List data=[];

  final Map<String,Color?> color={
    'Red':Colors.red,
    'Blue':Colors.blue,
    'Green':Colors.greenAccent,
    'Yellow':Colors.yellow
  };

  Widget _cartItem(Cart product,int index){
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/4,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: MediaQuery.of(context).size.height/4,
                width: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            product.image
                        ),
                        fit: BoxFit.fitHeight
                    )
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: MediaQuery.of(context).size.height/4,
                padding: EdgeInsets.symmetric(horizontal: 5),
                width: 260,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,style:TextStyle(fontWeight: FontWeight.w400,fontSize: 20)),
                    Text('Rs.${product.price}',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 23)),
                    Row(
                      children: [
                        Text('Size:',style: TextStyle(fontSize: 16),),
                        Text(product.size,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                      ],
                    ),
                    Row(
                      children: [
                        Text('Color: ',style: TextStyle(fontSize: 18),),
                        Container(
                          height: 16,
                          width: 16,
                          color: color[product.color],
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.cyan,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(product.quantity.toString(),style: TextStyle(fontSize: 20),),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 5),
            height: 40,
            child: TextButton(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Are You Sure?"),
                        content: Text("Sure you want to remove from cart"),
                        actions: [
                          TextButton(onPressed: (){
                            cartController.removeFromCart(product, product.productId);
                            Navigator.of(context).pop();
                          }, child: Text('Yes')),
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();
                          }, child: Text('No'))
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_outline,color: Colors.black,),
                    Text('Remove',style: TextStyle(color: Colors.black),),
                  ],
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xffe0dede))
                )
            )
        )
      ],
    );
  }

  SnackBar _showSnackBar(String text){
    return SnackBar(
      content: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart',style: TextStyle(
            fontSize: 22,
            color: Colors.black),),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Obx(() => cartController.cartItems.length==0?Center(child: Text("Nothing in Cart!",style: TextStyle(fontSize: 25,color: Colors.grey),),): ListView.builder(
            itemCount: cartController.cartItems.length,
            itemBuilder:(BuildContext context,index){
              return  _cartItem(cartController.cartItems[index],index);
            })),
        ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: MediaQuery.of(context).size.height/12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text('Total:Rs.${cartController.totalPrice}',style: TextStyle(fontSize: 20),)),
              Container(
                height:MediaQuery.of(context).size.height/15,
                width: MediaQuery.of(context).size.width/2,
                child: ElevatedButton(
                    onPressed: ()async{
                        if(cartController.cartItems.length!=0){
                          await cartController.addtoOrder();
                          for(int i=0;i<cartController.cartItems.length;i++){
                            await cartController.removeFromCart(cartController.cartItems[i], cartController.cartItems[i].productId);
                          }
                          cartController.fetchCartItems();
                          ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Order Placed Succesfully!'));
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Nothing in Cart'));
                        }
                      },
                    child:Text('BUY',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.cyan)
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}