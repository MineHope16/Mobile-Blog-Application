import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:zidioblogapp/screens/home/home_screen.dart";
import "package:zidioblogapp/screens/auth/register_screen.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
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
                  Text("Login",style: Theme.of(context).textTheme.displaySmall,),
                  const Text("Please enter the email and password to get started"),
            
                  //Input Text Boxes
            
                  const SizedBox(height: 30),
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
                  loading? const Center(child: CircularProgressIndicator()):
                  ElevatedButton(onPressed: (){
                    if (formKey.currentState!.validate()){
                      setState(() {
                        loading = true;
                      });
                      startLogin();
                    }
                  },
                      child: const Text("Login",style: TextStyle(fontSize: 18),),
                  ),
            
                ],
              ),
            ),
          ),
          
          OutlinedButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
          }, 
              child: const Text("Don't have an account ? Register Now"),
          ),

          const SizedBox(height: 15,)
        ],
      ),      
    );
  }


  startLogin() async{
    try {
      await auth.signInWithEmailAndPassword(email: email.text, password: password.text);
      setState(() {
        loading = false;
      });
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
    }on FirebaseAuthException catch (e){
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message?? ""),
      ));
    }
  }
}
