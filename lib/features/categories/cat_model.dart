
class Cat {
  final String id;
  final String imageUrl;
  final String name;

  Cat({required this.id, required this.imageUrl,required this.name});


  factory Cat.fromFirestore(Map<String, dynamic> json, String documentId) {
    return Cat(
      id: documentId,
      name:json['name'] ?? '',
      imageUrl: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': imageUrl,
      'name': name,
    };
  }
}
