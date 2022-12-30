import 'package:flutter/material.dart';

class ProductView extends StatefulWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  Widget _cardBuilder(String name,String price,String image){
    return Card(
      child: Container(
        height: MediaQuery.of(context).size.height/5,
        width: MediaQuery.of(context).size.width/2.5,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  image:DecorationImage(
                      image: AssetImage(image)
                  )
              ),
              height: MediaQuery.of(context).size.height/5.8,
              width: 150,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(price,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  Text(name,style: TextStyle(fontSize: 18)),
                  Container(
                    height: 40,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.cyan)
                          ),
                          onPressed: (){}, child: Text('ADD TO CART')))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0.2,
        title: Text('Featured',style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search_rounded,color: Colors.black,)),
        ],
        leading:  IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: GridView.count(
          mainAxisSpacing: 5,
          childAspectRatio: 0.78,
          scrollDirection: Axis.vertical,
          crossAxisCount: 2,
              crossAxisSpacing: 0.0,
          children: [
            _cardBuilder("Sports wear", "Rs.450", 'assets/image/shirt.jpg'),
            _cardBuilder("Sports wear", "Rs.450", 'assets/image/dress.jpg'),
            _cardBuilder("Sports wear", "Rs.450", 'assets/image/watch.jpg'),
            _cardBuilder("Sports wear", "Rs.450", 'assets/image/mobile.jpg'),
            _cardBuilder("Sports wear", "Rs.450", 'assets/image/shirt.jpg'),
            _cardBuilder("Sports wear", "Rs.450", 'assets/image/dress.jpg'),
            _cardBuilder("Sports wear", "Rs.450", 'assets/image/watch.jpg'),
            _cardBuilder("Sports wear", "Rs.450", 'assets/image/mobile.jpg')
          ],
        ),
      )
    );
  }
}
