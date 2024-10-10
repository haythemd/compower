// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      photoUrl: json['photoUrl'] as String,
      location: json['location'] as String,
      businessType: json['businessType'] as String,
      members: (json['members'] as List<dynamic>)
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => ToDo.fromJson(e as Map<String, dynamic>))
          .toList(),
      metaData: json['metaData'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'location': instance.location,
      'businessType': instance.businessType,
      'members': instance.members,
      'tasks': instance.tasks,
      'metaData': instance.metaData,
    };
