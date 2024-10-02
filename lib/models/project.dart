
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';


part 'project.g.dart';

@JsonSerializable()
class Project{
  final int id;
  final String title;
  final String description;
  final String photoUrl;
  

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.photoUrl
});

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

  factory Project.fromDocument(DocumentSnapshot doc) {
    return Project(
      id: doc['id'],
      title: doc['title'],
      description: doc['description'],
      photoUrl: doc['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() => _$ProjectToJson(this);

}