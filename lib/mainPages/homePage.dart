import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comm/controller/home_controlerr.dart';
import 'package:e_comm/mainPages/SingleProductView.dart';
import 'package:e_comm/mainPages/orderList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_comm/mainPages/productView.dart';
import 'package:get/get.dart';
import 'cartPage.dart';
import 'package:e_comm/model/Product.dart';
HomeController _home=Get.find();

class homePage extends StatefulWidget {

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();



  @override
  void initState(){

    super.initState();
  }


  Widget _circularAvatorBuilder(String name ,String image){
    return GestureDetector(
      onTap: (){},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  image
              ),
            ),
            Text(name,style:TextStyle(fontSize: 18))
          ],
        ),
      ),
    );
  }

  Widget _cardBuilder(String name,int price,String image,String productid,String description){
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx)=> SingleProduct(Product(productid,name,image,description,price)))
        );
      },
      child: Card(
        child: Container(
          height: MediaQuery.of(context).size.height/5,
          width: MediaQuery.of(context).size.width/2.5,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    image:DecorationImage(
                        image: NetworkImage(image),
                      fit: BoxFit.cover
                    )
                ),
                height: 150,
                width: 150,
              ),
              Container(
                width: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rs.${price}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    Text(name,style: TextStyle(fontSize: 18))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: _key,
        drawer: Drawer(
          child: FutureBuilder(
            future: FirebaseFirestore.instance.collection('user').doc(_home.getId()).get(),
            builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot) {
              if(snapshot.hasError){
                print(snapshot.hasError);
                return Center(
                  child: Text(snapshot.hasError.toString()),
                );
              }
              if(snapshot.hasData){
                return ListView(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                          color: Colors.cyan
                      ),
                      child: Container(
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${snapshot.data!['name']}'),
                            Text('${snapshot.data!['email']}'),
                          ],
                        )
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_bag_outlined,color: Colors.black,),
                      title: Text('Orders'),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Order()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout,color: Colors.black,),
                      title: Text('Logout'),
                      onTap: (){
                        FirebaseAuth.instance.signOut();
                      },
                    ),

                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );

            }
          ),
        ),
        appBar: AppBar(
          elevation: 0.2,
          backgroundColor: Colors.grey[100],
          leading: IconButton(
            icon: Icon(Icons.menu,color: Colors.black,),
            onPressed: (){
              _key.currentState!.openDrawer();
            },
          ),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.search_rounded,color: Colors.black,)),
            IconButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (ctx)=> cartPage()));}, icon: Icon(Icons.notifications_none_rounded,color: Colors.black,)),
          ],
        ),
        body:CustomScrollView(slivers:[SliverFillRemaining(
              hasScrollBody: false,
              child: GetX<HomeController>(
                builder: (controller) {
                    return Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: Column(
                          children: [
                          Container(
                          margin:EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text("Categories",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    TextButton(onPressed:(){
    },child: Text("See All",style: TextStyle(color: Colors.black),)),
    ],
    ),
    ),
    Container(
    height: MediaQuery.of(context).size.height/4,
    width: double.infinity,
    child: ListView(
    scrollDirection: Axis.horizontal,
    children: [
    _circularAvatorBuilder('Men','assets/Category/men.jpg' ),
    _circularAvatorBuilder('Women', 'assets/Category/women.jpg'),
    _circularAvatorBuilder('Women', 'assets/Category/women.jpg'),
    _circularAvatorBuilder('Children', 'assets/Category/child.jpg'),
    ],
    ),
    )
    ],
    ),
    ),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
    child: Column(
    children: [
    Container(
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text("Featured",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
    TextButton(
    onPressed:(){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (ctx)=> ProductView())
    );
    },

    child: Text("See All",style: TextStyle(color: Colors.black),)),
    ],
    ),
    ),
    Container(
    height: MediaQuery.of(context).size.height/3.5,
    width: double.infinity,
    child:controller.products.length==0?Center(child: Text('Something went error'),):ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.products.length,
        itemBuilder: (context,index){
          return _cardBuilder(controller.products[index].name,controller.products[index].price, controller.products[index].image, controller.products[index].id,controller.products[index].description);
        })
    ),
    ],
    ),
    ),

    ],
    ),

    );

                  }

              ),
            )]
        )
      ));
  }
}