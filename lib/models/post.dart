// lib/models/post.dart

class Post {
  final int?    id;
  final int     authorId;
  final String? text;
  final String? imagePath;
  final DateTime createdAt;

  Post({
    this.id,
    required this.authorId,
    this.text,
    this.imagePath,
    required this.createdAt,
  });

  factory Post.fromMap(Map<String, dynamic> m) => Post(
    id: (m['id'] as int?),
    authorId: m['authorId'] as int,
    text: m['text'] as String?,
    imagePath: m['imagePath'] as String?,
    createdAt: DateTime.fromMillisecondsSinceEpoch(m['createdAt'] as int),
  );

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'authorId':  authorId,
      'text':      text,
      'imagePath': imagePath,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
