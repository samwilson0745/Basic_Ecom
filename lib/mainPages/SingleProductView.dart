import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comm/controller/home_controlerr.dart';
import 'package:e_comm/mainPages/cartPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_comm/controller/cart_controller.dart';
import 'package:e_comm/model/Product.dart';
import 'package:e_comm/model/CartItem.dart';

HomeController _home=Get.find();
CartController cartController= Get.find();

class SingleProduct extends StatefulWidget {

  Product product;

  SingleProduct(this.product);

  @override
  State<SingleProduct> createState() => _SingleProductState();
  
}



class _SingleProductState extends State<SingleProduct> {

  int i=0;
  int _quantity=1;
  String colorValue='';
  String sizeValue='';
  String error='',buttonString='ADD TO CART';
  String uid=_home.getId();


  void checkCart(){
    final result = FirebaseFirestore.instance.collection('user').doc(uid).collection('cart').snapshots();
    result.forEach((element) {
      element.docs.forEach((element) {
        if(widget.product.id==element.id){
          setState(() {
            buttonString='GO TO CART';
          });
        }
      });
    });
  }

  Widget _buildBox(String size){
    return GestureDetector(
      onTap: (){
        setState(() {
          sizeValue=size;
        });
      },
      child: Container(
        height: 60,
        width: 60,
        color: Color(0xfff2f2f2),
        margin: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Text(size,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
      ),
    );
  }

  Widget _buildColorBox(Color color,String value){
    return GestureDetector(
      onTap: (){
        setState(() {
          colorValue=value;
        });
      },
      child: Container(
        height: 60,
        width: 60,
        color: color,
        margin: EdgeInsets.all(10),
      ),
    );
  }

  @override
  void initState() {
    checkCart();
    super.initState();
  }

  Future addtoCart(Cart cart)async{
    final product = FirebaseFirestore.instance.collection('user').doc(uid).collection('cart').doc(widget.product.id);
    final json={
      'image':cart.image,
      'name':cart.name,
      'price':cart.price,
      'size':cart.size,
      'color':cart.color,
      'quantity':cart.quantity,
      'TotalPrice':cart.price*cart.quantity.toInt()
    };
    await product.set(json);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.notifications_none_rounded,color: Colors.black,)),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget> [
                  Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffe0dede),
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                        ),
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.height/2.2,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(widget.product.image),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                        ),
                      )
                  ),
                  Expanded(
                      flex: 7,
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width:double.infinity,
                              height: MediaQuery.of(context).size.height/7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.product.name,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25),),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text('${widget.product.price}',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 30)),
                                  ),
                                  Text('(Only few items left)',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red),),
                                ],
                              ),
                            ),
                            Expanded(
                             flex: 4,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                width:double.infinity,
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Description',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35),),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Text('Sportswear is typically designed to be lightweight so as not to encumber the wearer.The best athletic wear for some forms of exercise,for example cycling,should not create drag or be too bulky.On the other hand,sportswear should be loose enough so as not to restrict movement.Some sports have specific style requirements, for example the keikogi used in karate. Various physically dangerous sports require protective gear, e.g. for fencing, American football, or ice hockey.Standardized sportswear may also function as a uniform. In team sports the opposing sides are usually identified by the colors of their clothing, while individual team members can be recognized by a back number on a shirt.In some sports, specific items of clothing are worn to differentiate roles within a team. For example, in volleyball, the libero (a specialist in defensive play) wears a different colour to that of their teammates.',
                                        style: TextStyle(
                                          fontSize: 20
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: MediaQuery.of(context).size.height/8,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Quantity',
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Container(
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
                                                  onTap: (){
                                                    if(_quantity>=2){
                                                    setState(() {
                                                      _quantity--;
                                                    });}
                                                  },
                                                ),
                                                Text('${_quantity}',style: TextStyle(fontSize: 20),),
                                                GestureDetector(
                                                  child: Icon(Icons.add),
                                                  onTap: (){
                                                    setState(() {
                                                      _quantity++;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: MediaQuery.of(context).size.height/7,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('Size',
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              _buildBox('S'),
                                              _buildBox('M'),
                                              _buildBox('L'),
                                              _buildBox('XL')
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: MediaQuery.of(context).size.height/7,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('Color',
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              _buildColorBox(Colors.yellowAccent,'Yellow'),
                                              _buildColorBox(Colors.redAccent,'Red'),
                                              _buildColorBox(Colors.greenAccent,'Green'),
                                              _buildColorBox(Colors.blueAccent,'Blue'),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      error!=''?error:'',style: TextStyle(
                                      fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold
                                    ),
                                    ),
                                    Container(
                                      height: 60,
                                      margin: EdgeInsets.symmetric(vertical: 25),
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: ()async{
                                            if(buttonString=='ADD TO CART'){
                                              if((colorValue=='' && sizeValue=='') || colorValue=='' || sizeValue==''){
                                                setState(() {
                                                  error="Select Size and Color";
                                                });
                                              }
                                              else{
                                                cartController.addtoCart(Cart(widget.product.name,widget.product.image,colorValue,  sizeValue,widget.product.price, _quantity,widget.product.id));
                                              await Future.delayed(const Duration(seconds: 2), (){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (ctx)=> cartPage())
                                                );
                                              });
                                            }}
                                            else{
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (ctx)=> cartPage())
                                              );
                                            }

                                        },
                                        child: Text(buttonString),
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(25)
                                                  )
                                              )
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      )
                  )
                ],
              ),
            ),
          )
        ],
      ),

    );
  }
}