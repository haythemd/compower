import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/member.dart';
import '../models/project.dart';
import '../models/todo.dart';

class ProjectService {
  // Private constructor
  ProjectService._privateConstructor() {
    _firestore = FirebaseFirestore.instance;
  }

  // Singleton instance
  static final ProjectService _instance = ProjectService._privateConstructor();

  // Factory constructor to return the singleton instance
  factory ProjectService() {
    return _instance;
  }

  // Firestore instance
  late FirebaseFirestore _firestore;

  // Reference to the projects collection
  final CollectionReference projectCollection = FirebaseFirestore.instance.collection('projects');

  // Add a new project
  Future<DocumentReference> addProject(Project project) async {
    return await projectCollection.add({
      'id': project.id,
      'title': project.title,
      'description': project.description,
      'photoUrl': project.photoUrl,
      'location': project.location,
      'businessType': project.businessType,
      'members': project.members.map((member) => member.toJson()).toList(),
      'tasks': project.tasks.map((task) => task.toJson()).toList(),
    });
  }

  // Get a project by its document ID
  Future<Project?> getProjectById(String docId) async {
    DocumentSnapshot docSnapshot = await projectCollection.doc(docId).get();
    if (docSnapshot.exists) {
      return Project(
        id: docSnapshot['id'],
        title: docSnapshot['title'],
        description: docSnapshot['description'],
        photoUrl: docSnapshot['photoUrl'],
        location: docSnapshot['location'],
        businessType: docSnapshot['businessType'],
        members: (docSnapshot['members'] as List<dynamic>)
            .map((member) => Member.fromJson(member as Map<String, dynamic>))
            .toList(),
        tasks: (docSnapshot['tasks'] as List<dynamic>)
            .map((task) => ToDo.fromJson(task as Map<String, dynamic>))
            .toList(),
      );
    }
    return null;
  }

  // Get a stream of all projects
  Stream<List<Project>> getAllProjects() {
    return projectCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) {
          return Project(
            id: doc['id'],
            title: doc['title'],
            description: doc['description'],
            photoUrl: doc['photoUrl'],
            location: doc['location'],
            businessType: doc['businessType'],
            members: (doc['members'] as List<dynamic>)
                .map((member) => Member.fromJson(member as Map<String, dynamic>))
                .toList(),
            tasks: (doc['tasks'] as List<dynamic>)
                .map((task) => ToDo.fromJson(task as Map<String, dynamic>))
                .toList(),
          );
        }).toList());
  }

  // Update an existing project
  Future<void> updateProject(String docId, Project project) async {
    await projectCollection.doc(docId).update({
      'title': project.title,
      'description': project.description,
      'photoUrl': project.photoUrl,
      'location': project.location,
      'businessType': project.businessType,
      'members': project.members.map((member) => member.toJson()).toList(),
      'tasks': project.tasks.map((task) => task.toJson()).toList(),
    });
  }

  // Delete a project
  Future<void> deleteProject(String docId) async {
    await projectCollection.doc(docId).delete();
  }
}
