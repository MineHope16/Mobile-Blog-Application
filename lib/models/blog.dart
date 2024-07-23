class Blog{
  String id, userID, title, desc;
  DateTime createdAT;

  Blog({required this.title, required this.createdAT, required this.desc, required this.id, required this.userID});

  factory Blog.fromMap(Map<String, dynamic> map) {
    return Blog(
      id: map['id'] ?? '',  // Default to an empty string if null
      userID: map['userID'] ?? '',
      title: map['title'] ?? '',
      desc: map['desc'] ?? '',
      createdAT: map['createdAT'] != null
          ? DateTime.parse(map['createdAT'])
          : DateTime.now(), // Default to the current date if null
    );
  }


  Map<String, dynamic> toMap() {
    return{
      'id': id,
      'desc':desc,
      'title': title,
      'createdAT': createdAT.toString(),
      'userID': userID
    };
  }
}