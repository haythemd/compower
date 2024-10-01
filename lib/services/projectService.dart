

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/project.dart';

class ProjectService {
  // Private constructor
  ProjectService._privateConstructor() {
    // Initialize Firestore instance in the constructor
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
  final CollectionReference projectCollection = FirebaseFirestore.instance.collection('projects');


  Future<DocumentReference> addProject(Project project) async {
   return await projectCollection.add({
      'id': project.id,
      'title': project.title,
      'description': project.description,
      'photoUrl': project.photoUrl,
    });
  }

  Future<Project?> getProjectById(String docId) async {
    DocumentSnapshot docSnapshot = await projectCollection.doc(docId).get();
    if (docSnapshot.exists) {
      return Project(
        id: docSnapshot['id'],
        title: docSnapshot['title'],
        description: docSnapshot['description'],
        photoUrl: docSnapshot['photoUrl'],
      );
    }
    return null;
  }

  Stream<List<Project>> getAllProjects() {
    return projectCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Project(
          id: doc['id'],
          title: doc['title'],
          description: doc['description'],
          photoUrl: doc['photoUrl'],
        )).toList());
  }


  Future<void> updateProject(String docId, Project project) async {
    await projectCollection.doc(docId).update({
      'title': project.title,
      'description': project.description,
      'photoUrl': project.photoUrl,
    });
  }

  Future<void> deleteProject(String docId) async {
    await projectCollection.doc(docId).delete();
  }






}