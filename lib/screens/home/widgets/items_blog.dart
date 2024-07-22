import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/blog.dart';

class ItemsBlog extends StatelessWidget {
  final Blog blog;
  const ItemsBlog({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(blog.title, style: Theme.of(context).textTheme.titleLarge,),
          Text(DateFormat('dd/MM/yyyy hh:mm a').format(blog.createdAT)),
          const SizedBox(height: 15,),
          Text(blog.desc),
        ],
      ),
    );
  }
}
