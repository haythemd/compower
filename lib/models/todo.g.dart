// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ToDo _$ToDoFromJson(Map<String, dynamic> json) => ToDo(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      isDone: json['isDone'] as bool,
      index: (json['index'] as num).toInt(),
      groupId: (json['groupId'] as num).toInt(),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      duration: json['duration'] as String?,
      inventory: json['inventory'] as bool?,
      dependency: json['dependency'] as String?,
      assignedMember: json['assignedMember'] as String?,
    );

Map<String, dynamic> _$ToDoToJson(ToDo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'isDone': instance.isDone,
      'index': instance.index,
      'groupId': instance.groupId,
      'dueDate': instance.dueDate?.toIso8601String(),
      'duration': instance.duration,
      'inventory': instance.inventory,
      'dependency': instance.dependency,
      'assignedMember': instance.assignedMember,
    };
