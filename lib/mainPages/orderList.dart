import 'package:e_comm/controller/order_controller.dart';
import 'package:get/get.dart';
import '../model/Order.dart';
import 'package:flutter/material.dart';

OrderController orderController=Get.find();


class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {

  final Map<String,Color?> color={
    'Red':Colors.red,
    'Blue':Colors.blue,
    'Green':Colors.greenAccent,
    'Yellow':Colors.yellow
  };

  @override
  void initState(){
    orderController.fetchOrderItems();
    super.initState();
  }

  Widget _orderItem(OrderItem order,int index){

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
                            order.image
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
                    Text(order.name,style:TextStyle(fontWeight: FontWeight.w400,fontSize: 20)),
                    Text('Rs.${order.price}',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 23)),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text('Size:',style: TextStyle(fontSize: 16),),
                        Text(order.size,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                      ],
                    ),
                    Row(
                      children: [
                        Text('Color: ',style: TextStyle(fontSize: 18),),
                        Container(
                          height: 16,
                          width: 16,
                          color: color[order.color],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text('Quantity: ',style: TextStyle(fontSize: 18),),
                        Text(order.quantity.toString(),style: TextStyle(fontSize: 20),),
                      ],
                    ),

                    Row(
                      children: [
                        Text('TotalPrice: ',style: TextStyle(fontSize: 18),),
                        Text(order.totalPrice.toString(),style: TextStyle(fontSize: 20),),
                      ],
                    ),
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
                        content: Text("Sure you want cancel your order?"),
                        actions: [
                          TextButton(onPressed: (){
                            orderController.removeFromOrder(order, order.productId);
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
                    Text('Cancel',style: TextStyle(color: Colors.black),),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders',style: TextStyle(
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
        child: Obx(() => orderController.orderItems.length==0?Center(child: Text("Nothing you have ordered!",style: TextStyle(fontSize: 25,color: Colors.grey),),): ListView.builder(
            itemCount: orderController.orderItems.length,
            itemBuilder:(BuildContext context,index){
              return  _orderItem(orderController.orderItems[index],index);
            })),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: MediaQuery.of(context).size.height/12,
          child: Center(child: Obx(() => Text('Total:Rs.${orderController.totalPrice}',style: TextStyle(fontSize: 20),))),
        ),
      ),
    );
  }
}
