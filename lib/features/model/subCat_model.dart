class SubCat {
  final String id;
  final String cat;
  final String image;
  final String name;


  SubCat({required this.id, required this.image,required this.cat,required this.name});


  factory SubCat.fromFirestore(Map<String, dynamic> json, String documentId) {
    return SubCat(
      id: documentId,
      name:json['name'] ?? '',
      image: json['image'] ?? '',
      cat: json['cat'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cat': cat,
      'name': name,
      'image':image
    };
  }
}
