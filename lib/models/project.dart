import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'todo.dart';  // Import the ToDo model here
import 'member.dart'; // Import the Member model here

part 'project.g.dart';

@JsonSerializable()
class Project {
  final int id;
  final String title;
  final String description;
  final String photoUrl;
  final String location;         // Location of the project
  final String businessType;     // Type of business the project is related to
  final List<Member> members;    // List of members involved in the project
  final List<ToDo> tasks;        // List of tasks (ToDos) associated with the project

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.photoUrl,
    required this.location,
    required this.businessType,
    required this.members,        // Initialize members
    required this.tasks,          // Initialize tasks
  });

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

  factory Project.fromDocument(DocumentSnapshot doc) {
    var tasksFromJson = (doc['tasks'] as List)
        .map((task) => ToDo.fromJson(task as Map<String, dynamic>))
        .toList();

    var membersFromJson = (doc['members'] as List)
        .map((member) => Member.fromJson(member as Map<String, dynamic>))
        .toList();

    return Project(
      id: doc['id'],
      title: doc['title'],
      description: doc['description'],
      photoUrl: doc['photoUrl'],
      location: doc['location'],
      businessType: doc['businessType'],
      members: membersFromJson,    // Deserialize members
      tasks: tasksFromJson,
    );
  }

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
