class Comment {
  final int?    id;
  final int     postId;
  final int     authorId;
  final String  text;
  final DateTime createdAt;

  Comment({
    this.id,
    required this.postId,
    required this.authorId,
    required this.text,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Comment.fromMap(Map<String, dynamic> m) => Comment(
    id:         m['id'] as int,
    postId:     m['postId'] as int,
    authorId:   m['authorId'] as int,
    text:       m['text'] as String,
    createdAt:  DateTime.fromMillisecondsSinceEpoch(m['createdAt'] as int),
  );

  Map<String,dynamic> toMap() => {
    'postId':     postId,
    'authorId':   authorId,
    'text':       text,
    'createdAt':  createdAt.millisecondsSinceEpoch,
  };
}
