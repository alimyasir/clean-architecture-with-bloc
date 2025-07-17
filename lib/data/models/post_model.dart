

import 'package:clean_architecture_with_bloc/domain/entities/post.dart';

class PostModel extends Post {
  PostModel({required super.id, required super.title, required super.body});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
  };
}