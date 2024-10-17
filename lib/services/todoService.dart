import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/services/projectService.dart';
import '../models/todo.dart';

class TodoService {
  // Singleton instance
  static final TodoService _instance = TodoService._internal();
  factory TodoService() => _instance;
  TodoService._internal();

  // Firestore collection reference
  final CollectionReference _todoCollection =
  FirebaseFirestore.instance.collection('todos');
  final CollectionReference projectCollection =
  FirebaseFirestore.instance.collection('projects');

  final ProjectService _projectService = ProjectService();

  // Create a new ToDo
  Future<void> createTodo(ToDo todo) async {
    try {
      DocumentReference todoRef = await _todoCollection.add({
        'projectId': todo.projectId,
        'title': todo.title,
        'description': todo.description,
        'price': todo.price,
        'startDate': todo.startDate != null ? Timestamp.fromDate(todo.startDate!) : null,
        'dueDate': todo.dueDate != null ? Timestamp.fromDate(todo.dueDate!) : null,
        'isDone': todo.isDone,
        'index': todo.index,
        'groupId': todo.groupId,
        'duration': todo.duration,
        'inventory': todo.inventory,
        'dependency': todo.dependency,
        'assignedMember': todo.assignedMember,
      });
      await _projectService.addTodoToProject(todo.projectId, todoRef);
    } catch (e) {
      print('Error creating ToDo: $e');
    }
  }

  // Read ToDos
  Future<List<ToDo>> getTodos() async {
    try {
      QuerySnapshot querySnapshot = await _todoCollection.get();
      return querySnapshot.docs.map((doc) {
        return ToDo(
          id: doc.reference,
          projectId: doc['projectId'],
          title: doc['title'],
          description: doc['description'],
          price: (doc['price'] as num).toDouble(),
          startDate: (doc['startDate'] as Timestamp?)?.toDate(),
          dueDate: (doc['dueDate'] as Timestamp?)?.toDate(),
          isDone: doc['isDone'],
          index: doc['index'],
          groupId: doc['groupId'],
          duration: doc['duration'],
          inventory: doc['inventory'] != null
              ? Map<String, dynamic>.from(doc['inventory'])
              : null,
          dependency: doc['dependency'],
          assignedMember: doc['assignedMember'],
        );
      }).toList();
    } catch (e) {
      print('Error reading ToDos: $e');
      return [];
    }
  }

  Future<List<ToDo>> getTodosByProjectId(String projectId) async {

    print(projectId);
    try {

      QuerySnapshot querySnapshot = await _todoCollection
          .where('projectId', isEqualTo: projectCollection.doc(projectId))
          .get();

      print(querySnapshot.docs.length);
      return querySnapshot.docs.map((doc) {
        return ToDo(
          id: doc.reference,
          projectId: doc['projectId'],
          title: doc['title'],
          description: doc['description'],
          price: (doc['price'] as num).toDouble(),
          startDate: (doc['startDate'] as Timestamp?)?.toDate(),
          dueDate: (doc['dueDate'] as Timestamp?)?.toDate(),
          isDone: doc['isDone'],
          index: doc['index'],
          groupId: doc['groupId'],
          duration: doc['duration'],
          inventory: doc['inventory'] != null
              ? Map<String, dynamic>.from(doc['inventory'])
              : null,
          dependency: doc['dependency'],
          assignedMember: doc['assignedMember'],
        );
      }).toList();
    } catch (e) {
      print('Error reading ToDos: $e');
      return [];
    }
  }

  // Update an existing ToDo
  Future<void> updateTodo(String docId, ToDo updatedTodo) async {
    try {
      await _todoCollection.doc(docId).update({
        'title': updatedTodo.title,
        'description': updatedTodo.description,
        'price': updatedTodo.price,
        'startDate': updatedTodo.startDate != null ? Timestamp.fromDate(updatedTodo.startDate!) : null,
        'dueDate': updatedTodo.dueDate != null ? Timestamp.fromDate(updatedTodo.dueDate!) : null,
        'isDone': updatedTodo.isDone,
        'index': updatedTodo.index,
        'groupId': updatedTodo.groupId,
        'duration': updatedTodo.duration,
        'inventory': updatedTodo.inventory,
        'dependency': updatedTodo.dependency,
        'assignedMember': updatedTodo.assignedMember,
      });
    } catch (e) {
      print('Error updating ToDo: $e');
    }
  }

  // Delete a ToDo
  Future<void> deleteTodo(String docId, DocumentReference projectId) async {
    try {
      DocumentReference todoRef = _todoCollection.doc(docId);
      await todoRef.delete();
      await _projectService.removeTodoFromProject(projectId, todoRef);
    } catch (e) {
      print('Error deleting ToDo: $e');
    }
  }
}
