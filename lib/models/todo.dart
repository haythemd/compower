import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable()class ToDo {
  final int id;
  final String title;
  final String description;
  final double price;
  final bool isDone;
  final int index;
  final int groupId;

  ToDo({
    required this.id,
    required this.title,required this.description,
    required this.price,
    required this.isDone,
    required this.index,
    required this.groupId,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) => _$ToDoFromJson(json);

  Map<String, dynamic> toJson() => _$ToDoToJson(this);
}