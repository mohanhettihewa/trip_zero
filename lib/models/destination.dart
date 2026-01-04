class Destination {
  final String id;
  final String title;
  final String image;
  final String description;

  Destination({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'description': description,
    };
  }

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
    );
  }

  Destination copyWith({
    String? title,
    String? image,
    String? description,
  }) {
    return Destination(
      id: id,
      title: title ?? this.title,
      image: image ?? this.image,
      description: description ?? this.description,
    );
  }
}
