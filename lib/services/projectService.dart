import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project.dart';

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
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  // Add a new project
  Future<DocumentReference> addProject(Project project) async {
    final docRef = await projectCollection.add({
      'title': project.title,
      'description': project.description,
      'photoUrl': project.photoUrl,
      'location': project.location,
      'businessType': project.businessType,
      'members': project.members.map((member) => member).toList(), // Storing DocumentReferences directly
      'tasks': project.tasks.map((task) => task).toList(),         // Storing DocumentReferences directly
      'metaData': project.metaData,
    });
    return docRef;
  }

  // Add a ToDo reference to a project
  Future<void> addTodoToProject(DocumentReference projectRef, DocumentReference todoRef) async {
    try {
      await projectRef.update({
        'tasks': FieldValue.arrayUnion([todoRef])
      });
    } catch (e) {
      print('Error adding ToDo to project: $e');
    }
  }

  // Remove a ToDo reference from a project
  Future<void> removeTodoFromProject(DocumentReference projectRef, DocumentReference todoRef) async {
    try {
      await projectRef.update({
        'tasks': FieldValue.arrayRemove([todoRef])
      });
    } catch (e) {
      print('Error removing ToDo from project: $e');
    }
  }

  // Get a project by its document ID
  Future<Project?> getProjectById(String docId) async {
    DocumentSnapshot docSnapshot = await projectCollection.doc(docId).get();
    if (docSnapshot.exists) {
      return Project(
        id: docSnapshot.id,
        title: docSnapshot['title'],
        description: docSnapshot['description'],
        photoUrl: docSnapshot['photoUrl'],
        location: docSnapshot['location'],
        businessType: docSnapshot['businessType'],
        members: (docSnapshot['members'] as List<dynamic>)
            .map((member) => member as DocumentReference)
            .toList(),  // Retrieving DocumentReferences
        tasks: (docSnapshot['tasks'] as List<dynamic>)
            .map((task) => task as DocumentReference)
            .toList(),   // Retrieving DocumentReferences
        metaData: docSnapshot['metaData'] as Map<String, dynamic>,
      );
    }
    return null;
  }

  // Get a stream of all projects
  Stream<List<Project>> getAllProjects() {
    return projectCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) {
          return Project(
            id: doc.id,
            title: doc['title'],
            description: doc['description'],
            photoUrl: doc['photoUrl'],
            location: doc['location'],
            businessType: doc['businessType'],
            members: (doc['members'] as List<dynamic>)
                .map((member) => member as DocumentReference)
                .toList(),  // Retrieving DocumentReferences
            tasks: (doc['tasks'] as List<dynamic>)
                .map((task) => task as DocumentReference)
                .toList(),  // Retrieving DocumentReferences
            metaData: doc['metaData'] as Map<String, dynamic>,
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
      'members': project.members.map((member) => member).toList(),  // Storing DocumentReferences
      'tasks': project.tasks.map((task) => task).toList(),          // Storing DocumentReferences
      'metaData': project.metaData,
    });
  }

  // Delete a project
  Future<void> deleteProject(String docId) async {
    await projectCollection.doc(docId).delete();
  }
}
