import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zidioblogapp/screens/home/home_screen.dart';
import 'package:zidioblogapp/screens/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  const SizedBox(height: 100,),
                  Text("Register",style: Theme.of(context).textTheme.displaySmall,),
                  const Text("Please enter the name, email and password to get started"),

                  //Input Text Boxes

                  const SizedBox(height: 30),

                  //Name Textbox
                  TextFormField(
                    controller: name,
                    decoration: const InputDecoration(
                      hintText: "Name",
                    ),

                    validator: (value){
                      if (value!.isEmpty){
                        return "Please enter the name";
                      }

                      return null;

                    },
                  ),

                  const SizedBox(height: 15),

                  //Email Textbox
                  TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),

                    validator: (value){
                      if (value!.isEmpty){
                        return "Please enter the email";
                      }

                      return null;

                    },
                  ),

                  const SizedBox(height: 15),
                  //Password Textbox
                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),

                    validator: (value){
                      if (value!.isEmpty){
                        return "Please enter the password";
                      }

                      return null;

                    },
                  ),

                  //Login Button
                  const SizedBox(height: 30,),
                  loading? const Center(child: CircularProgressIndicator(),):
                  ElevatedButton(onPressed: (){
                    if (formKey.currentState!.validate()){
                      setState(() {
                        loading = true;
                        startRegister();
                      });

                    }
                  },
                    child: const Text("Register",style: TextStyle(fontSize: 18),),
                  ),

                ],
              ),
            ),
          ),

          OutlinedButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
            child: const Text("Already have an account ? Login Now"),
          ),

          const SizedBox(height: 15,)
        ],
      ),
    );
  }

  startRegister() async{
    try{
     final result = await auth.createUserWithEmailAndPassword(email: email.text, password: password.text);
     await result.user?.updateDisplayName(name.text);
     setState(() {
       loading = false;
     });
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
    }on FirebaseAuthException catch(e){
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message?? ''),
        ));
    }
  }
}
