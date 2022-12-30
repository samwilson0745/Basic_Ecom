import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comm/mainPages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:select_form_field/select_form_field.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}
final _formkey = GlobalKey<FormState>();
final _scaffoldkey = GlobalKey<ScaffoldState>();

String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp regExp = new RegExp(p);

class _SignUpState extends State<SignUp> {

  final List<Map<String,dynamic>> _items=[
    {
      'value':'Customer',
      'label':'Customer Account'
    },
    {
      'value':'Seller',
      'label':'Seller Account'
    }
  ];

  String email="",password="";
  bool _passwordVisible = true;
  bool _confirmPassword = true;

  TextEditingController _username =new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _type=new TextEditingController();

  SnackBar _showSnackBar(String text){
    return SnackBar(
      content: Text(text),
    );
  }

  Future addUser(String uid,String name,String email)async{
    final product = FirebaseFirestore.instance.collection('user').doc(uid);
    final json={
      'name':name,
      'email':email
    };
    await product.set(json);
  }

  void validation() async {
    final FormState? _formState = _formkey.currentState;
    if(_formState !=null){
      if(_formState.validate()){
        try{
          UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

          if(result.additionalUserInfo!.isNewUser){
            addUser(result.user!.uid, _username.text, _email.text);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=> homePage()));
          }
        } catch (e){
          print(e.toString());
          ScaffoldMessenger.of(context).showSnackBar(_showSnackBar(e.toString()));
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: _scaffoldkey,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Form(
                key: _formkey,
                child: Column(
                      children: <Widget>[
                       Expanded(
                        flex: 3,
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 15),
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 40
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: TextFormField(
                                  controller: _username,
                                  validator: (value){
                                    if (value == ""){
                                      return "Please fill Username";
                                    }
                                    if(value != null ){
                                    if(value.length < 6){
                                      return "Username Is Too Short";
                                    }
                                  }},
                                    decoration:InputDecoration(
                                        hintText: "Username",
                                        hintStyle: TextStyle(color: Colors.black),
                                        border: OutlineInputBorder()
                                    )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: TextFormField(
                                  controller: _email,
                                  onChanged: (value){
                                    setState(() {
                                      email=value;
                                    });
                                  },
                                  validator: (value){
                                    if(value == ""){
                                      return "PLease fill email";
                                    }
                                    if(!regExp.hasMatch(value.toString())){
                                      return "Email is Invalid";
                                    }
                                  },
                                    decoration:InputDecoration(
                                        hintText: "Email",
                                        hintStyle: TextStyle(color: Colors.black),
                                        border: OutlineInputBorder()
                                    )
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                child: SelectFormField(

                                  decoration:InputDecoration(
                                    labelText: 'Type',
                                    border: OutlineInputBorder()

                                  ),
                                  validator: (value){
                                    if(value=='') return 'PLease Select Type';
                                  },
                                  type:  SelectFormFieldType.dropdown,
                                  initialValue: '',
                                  items: _items,
                                ),

                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: TextFormField(
                                  controller: _password,
                                    obscureText: _passwordVisible,
                                    onChanged: (value){
                                     setState(() {
                                       password=value;
                                     });
                                    },
                                    validator: (value){
                                      if(value==""){
                                      return "Please Fill Password";
                                      }
                                    else if(value!=null){
                                      if(value.length<8){
                                        return "Password is too short";
                                      }
                                    }

                                    else{
                                      return "";
                                    }
                                  },

                                    decoration:InputDecoration(
                                        suffixIcon: GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              _passwordVisible=!_passwordVisible;
                                            });
                                          },
                                          child: Icon(
                                            _passwordVisible?Icons.visibility_off:Icons.visibility,
                                          ),
                                        ),
                                        hintText: "Password",
                                        hintStyle: TextStyle(color: Colors.black),
                                        border: OutlineInputBorder()
                                    )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: TextFormField(
                                  obscureText: _confirmPassword,
                                    validator: (value){
                                      if(value != null){
                                        if(value != _password.value.text){
                                          return "Passwords dont match";
                                        }
                                      }
                                    },
                                    decoration:InputDecoration(
                                        suffixIcon: GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              _confirmPassword=!_confirmPassword;
                                            });
                                          },
                                          child: Icon(
                                            _confirmPassword?Icons.visibility_off:Icons.visibility,
                                          ),
                                        ),
                                        hintText: "Confirm Password",
                                        hintStyle: TextStyle(color: Colors.black),
                                        border: OutlineInputBorder()
                                    )
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: (){
                                    validation();
                                  },
                                  child: Text(
                                    'Register'
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text('Already have an account? '),
                                  GestureDetector(
                                    onTap: (){},
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        color:Colors.cyan
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
              )],
            ),
      ));
  }
}

