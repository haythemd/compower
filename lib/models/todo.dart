import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo {
  final DocumentReference? id;
  final DocumentReference projectId;
  final String title;
  final String? description;
  final double price;
  final DateTime? startDate;
  final DateTime? dueDate;
  final bool isDone;
  final int? index;
  final int? groupId;
  final String? duration;
  final Map<String, dynamic>? inventory;
  final DocumentReference? dependency;
  final DocumentReference? assignedMember;

  ToDo({
    required this.id,
    required this.projectId,
    required this.title,
    this.description,
    required this.price,
    this.startDate,
    required this.isDone,
    required this.index,
    required this.groupId,
    this.dueDate,
    this.duration,
    this.inventory,
    this.dependency,
    this.assignedMember,
  });

  // Deserialize from Firestore document
  factory ToDo.fromJson(Map<String, dynamic> doc) {
    final data = doc;
    return ToDo(
      id: doc['id'],
      projectId: data['projectId'],
      title: data['title'],
      description: data['description'],
      price: (data['price'] as num).toDouble(),
      startDate: data['startDate'] != null ? (data['startDate'] as Timestamp).toDate() : null,
      dueDate: data['dueDate'] != null ? (data['dueDate'] as Timestamp).toDate() : null,
      isDone: data['isDone'],
      index: data['index'],
      groupId: data['groupId'],
      duration: data['duration'],
      inventory: data['inventory'],
      dependency: data['dependency'],
      assignedMember: data['assignedMember'],
    );
  }

  factory ToDo.fromFirebase(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ToDo(
      id: doc.reference,
      projectId: data['projectId'],
      title: data['title'],
      description: data['description'],
      price: (data['price'] as num).toDouble(),
      startDate: data['startDate'] != null ? (data['startDate'] as Timestamp).toDate() : null,
      dueDate: data['dueDate'] != null ? (data['dueDate'] as Timestamp).toDate() : null,
      isDone: data['isDone'],
      index: data['index'],
      groupId: data['groupId'],
      duration: data['duration'],
      inventory: data['inventory'],
      dependency: data['dependency'],
      assignedMember: data['assignedMember'],
    );
  }

  // Serialize to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'title': title,
      'description': description,
      'price': price,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'isDone': isDone,
      'index': index,
      'groupId': groupId,
      'duration': duration,
      'inventory': inventory,
      'dependency': dependency,
      'assignedMember': assignedMember,
    };
  }

  // copyWith method
  ToDo copyWith({
    DocumentReference? id,
    DocumentReference? projectId,
    String? title,
    String? description,
    double? price,
    DateTime? startDate,
    DateTime? dueDate,
    bool? isDone,
    int? index,
    int? groupId,
    String? duration,
    Map<String, dynamic>? inventory,
    DocumentReference? dependency,
    DocumentReference? assignedMember,
  }) {
    return ToDo(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
      index: index ?? this.index,
      groupId: groupId ?? this.groupId,
      duration: duration ?? this.duration,
      inventory: inventory ?? this.inventory,
      dependency: dependency ?? this.dependency,
      assignedMember: assignedMember ?? this.assignedMember,
    );
  }
}
