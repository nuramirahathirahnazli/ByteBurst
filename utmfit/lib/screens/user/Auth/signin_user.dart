import 'package:flutter/material.dart';
import 'package:utmfit/screens/user/Auth/signup_user.dart';


class loginScreen extends StatelessWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('UTM FIT'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const signupScreen()),
              );
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 187, 0),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),



        body: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFFECAA00),
              Color.fromARGB(255, 224, 207, 159),
            ]),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 22),
            child: Text(
              'Welcome\nSign in!',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            height: double.infinity,
            width: double.infinity,
            child:  Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.check,color: Colors.grey,),
                      label: Text('Email',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:Color.fromARGB(255, 117, 117, 115),
                      ),)
                    ),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.visibility_off,color: Colors.grey,),
                        label: Text('Password',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:Color.fromARGB(255, 117, 117, 115),
                        ),)
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Forgot Password?',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color(0xff281537),
                    ),),
                  ),
                  const SizedBox(height: 70,),
                  Container(
                    height: 55,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFECAA00),
                          Color.fromARGB(255, 224, 207, 159),
                        ]
                      ),
                    ),
                    child: const Center(child: Text('LOGIN',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                    ),),),
                  ),
                  const SizedBox(height: 150,),
                   GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const signupScreen()),
                        );
                      },
                      child: const Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Don't have an account?", style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                            ),),
                            Text("Sign up", style: TextStyle(///done login page
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.black
                            ),),
                      ],
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
