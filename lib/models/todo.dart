import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable()
class ToDo {
  final int id;
  final String title;
  final String? description; // Nullable description
  final double price;
  final bool isDone;
  final int index;
  final int groupId;
  final DateTime? dueDate; // Nullable due date
  final String? duration; // Duration as a String
  final bool? inventory; // Inventory count
  final String? dependency; // Added correct field
  final String? assignedMember; // Added correct field

  ToDo({
    required this.id,
    required this.title,
    this.description, // Optional description
    required this.price,
    required this.isDone,
    required this.index,
    required this.groupId,
    this.dueDate, // Optional due date
    this.duration, // Optional duration
    this.inventory, // Optional inventory
    this.dependency, // Optional dependency
    this.assignedMember, // Optional assigned member
  });

  factory ToDo.fromJson(Map<String, dynamic> json) => _$ToDoFromJson(json);

  Map<String, dynamic> toJson() => _$ToDoToJson(this);
}
