import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zidioblogapp/screens/add_blog/add_blog_screen.dart';
import 'package:zidioblogapp/screens/auth/login_screen.dart';
import 'package:zidioblogapp/screens/home/widgets/items_blog.dart';
import 'package:zidioblogapp/screens/my_blog/my_blog_screen.dart';

import '../../models/blog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          PopupMenuButton(itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => MyBlogScreen()));
              },
              child: const Text("My Blogs"),
            ),
            PopupMenuItem(
              onTap: () async {
                final auth = FirebaseAuth.instance;
                await auth.signOut();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()),(route) => false);
              },
              child: const Text('Logout'),)
          ],),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('blogs').snapshots(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }

          if (snapshot.hasData && snapshot.data != null){
            final data = snapshot.data!.docs;
            List<Blog> blogs = [];
            for (var element in data){
              Blog blog = Blog.fromMap(element.data());
              blogs.add(blog);
            }

            return ListView(
              padding: const EdgeInsets.all(15),
              children: [
                for (var blog in blogs)
                  ItemsBlog(blog: blog)
              ],
            );
          }
          return SizedBox();
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddBlogScreen()));
        },
        child: const Icon(CupertinoIcons.plus),
      ),

    );
  }
}
