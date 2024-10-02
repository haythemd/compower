import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  final String id;           // Unique identifier for the member
  final String name;         // Name of the member
  final String? role;        // Role of the member in the project (optional)
  final String? email;       // Email address of the member (optional)

  Member({
    String? id,               // ID can be provided or autogenerated
    required this.name,
    this.role,
    this.email,
  }) : id = id ?? _generateId(); // Use a private method to generate an ID if not provided

  // Factory method to create a Member instance from JSON
  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  // Convert a Member instance to JSON
  Map<String, dynamic> toJson() => _$MemberToJson(this);

  // Private method to generate a unique ID (you can customize this)
  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
