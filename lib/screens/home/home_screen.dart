import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zidioblogapp/screens/Splash/splash_screen.dart';
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
  @override
  void initState() {
    print("HOMEEEEEEEEEEEEEEEEEEE");
    super.initState();
  }
final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: const Text("Home", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.tealAccent.shade400,
          elevation: 0,

        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 'my_blogs') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MyBlogScreen()));
              } else if (value == 'logout') {
                await auth.signOut();
                Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (_) => const SplashScreen()),(route) => false,);
              }
            },

            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'my_blogs',
                child: Text("My Blogs"),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text("Logout"),
              ),
            ],
          ),
        ],
      ),


      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('blogs').snapshots(),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData && snapshot.data != null) {
              final data = snapshot.data!.docs;
              List<Blog> blogs = data.map((doc) => Blog.fromMap(doc.data() as Map<String, dynamic>)).toList();

              return ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: blogs.length,
                itemBuilder: (context, index) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ItemsBlog(blog: blogs[index]),
                ),
              );
            }

            return const Center(child: Text('No blogs available.', style: TextStyle(color: Colors.black54)));
          },
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddBlogScreen()));
        },
        backgroundColor: Colors.tealAccent.shade400,
        child: const Icon(CupertinoIcons.add, color: Colors.black87),
      ),
    );
  }
}
