import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/blog.dart';
import '../home/widgets/items_blog.dart';

class MyBlogScreen extends StatefulWidget {
  const MyBlogScreen({super.key});

  @override
  State<MyBlogScreen> createState() => _MyBlogScreenState();
}

class _MyBlogScreenState extends State<MyBlogScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  
  @overridead
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Blogs'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('blogs').where('userID',isEqualTo: user.uid).snapshots(),
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
    );
  }
}
