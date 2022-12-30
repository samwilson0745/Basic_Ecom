import 'package:flutter/material.dart';
import 'package:e_comm/controller/cart_controller.dart';
import 'package:e_comm/model/CartItem.dart';
import 'package:get/get.dart';
CartController cartController= Get.find();

class CartItemWidget extends StatelessWidget{
  final Cart cartItem;
  final String uid;

  final Map<String,Color?> color={
    'Red':Colors.red,
    'Blue':Colors.blue,
    'Green':Colors.greenAccent,
    'Yellow':Colors.yellow
  };

  CartItemWidget(this.cartItem,this.uid);

  @override
  Widget build(BuildContext context){
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
                            cartItem.image
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
                    Text(cartItem.name,style:TextStyle(fontWeight: FontWeight.w400,fontSize: 20)),
                    Text('Rs.${cartItem.price}',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 23)),
                    Row(
                      children: [
                        Text('Size:',style: TextStyle(fontSize: 16),),
                        Text(cartItem.size,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                      ],
                    ),
                    Row(
                      children: [
                        Text('Color: ',style: TextStyle(fontSize: 18),),
                        Container(
                          height: 16,
                          width: 16,
                          color: color[cartItem.color],
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
                          GestureDetector(
                            child: Icon(Icons.remove),
                            onTap: ()async{
                              // cartController.increment(cartItem);
                            },
                          ),
                Text(cartItem.quantity.toString(),style: TextStyle(fontSize: 20),),
                          GestureDetector(
                            child: Icon(Icons.add),
                            onTap: ()async{
                              // cartController.decrement(cartItem);
                            },
                          ),
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
                            cartController.removeFromCart(cartItem,  cartItem.productId);
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
}