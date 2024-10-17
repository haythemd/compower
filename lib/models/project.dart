import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final String photoUrl;
  final String location;         // Location of the project
  final String businessType;     // Type of business the project is related to
  final List<DocumentReference> members;    // List of members involved in the project
  final List<DocumentReference> tasks;      // List of tasks (ToDos) associated with the project
  final Map<String, dynamic> metaData;      // Meta data for the project

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.photoUrl,
    required this.location,
    required this.businessType,
    required this.members,        // Initialize members
    required this.tasks,
    required this.metaData,
  });


  factory Project.fromDocument(DocumentSnapshot doc) {
    var tasksFromJson = (doc['tasks'] as List)
        .map((task) => task as DocumentReference)
        .toList();

    var membersFromJson = (doc['members'] as List)
        .map((member) => member as DocumentReference)
        .toList();

    return Project(
      id: doc['id'],
      title: doc['title'],
      description: doc['description'],
      photoUrl: doc['photoUrl'],
      location: doc['location'],
      businessType: doc['businessType'],
      members: membersFromJson,    // Deserialize members as DocumentReference
      tasks: tasksFromJson,        // Deserialize tasks as DocumentReference
      metaData: doc['metaData'] as Map<String, dynamic>,
    );
  }

}
