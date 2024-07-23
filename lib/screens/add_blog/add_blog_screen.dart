import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:zidioblogapp/models/blog.dart";

class AddBlogScreen extends StatefulWidget {
  const AddBlogScreen({super.key});

  @override
  State<AddBlogScreen> createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  final title = TextEditingController();
  final desc = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Blog"),
        actions: [
          IconButton(
              onPressed: (){
                if(formKey.currentState!.validate()){
                  setState(() {
                    loading = true;
                  });
                  addBlog();
                }
              },
              icon: const Icon(Icons.done))
        ],
      ),
      
      body: loading? const Center(child: CircularProgressIndicator(),):
      Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [

            // Title TextBox
            TextFormField(
              controller: title,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Title'
              ),
              
              validator: (value){
                if(value!.isEmpty){
                  return 'Please enter the tile';
                }
                
                return null;
              },
            ),

            const SizedBox(height: 15),

            // Description TextBox
            TextFormField(
              controller: desc,
              maxLines: 10,
              decoration: const InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(),
              ),
              validator: (value){
                if(value!.isEmpty){
                  return 'Please enter the description';
                }

                return null;
              },
              
            )
          ],
        ),
      ),
    );
  }

  addBlog() async{
    final db = FirebaseFirestore.instance.collection("blogs");
    final user = FirebaseAuth.instance.currentUser!;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    Blog blog = Blog(
        title: title.text,
        createdAT: DateTime.now(),
        desc: desc.text,
        id: id,
        userID: user.uid
    );
    
    try{
      await db.doc(id).set(blog.toMap());
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    }on FirebaseException catch(e){
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message?? '')));
    }

  }
}
