/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Room type in your schema. */
@immutable
class Room extends Model {
  static const classType = const _RoomModelType();
  final String id;
  final List<Message>? _messages;
  final List<UserRoom>? _userRoom;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  List<Message>? get messages {
    return _messages;
  }
  
  List<UserRoom>? get userRoom {
    return _userRoom;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Room._internal({required this.id, messages, userRoom, createdAt, updatedAt}): _messages = messages, _userRoom = userRoom, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Room({String? id, List<Message>? messages, List<UserRoom>? userRoom}) {
    return Room._internal(
      id: id == null ? UUID.getUUID() : id,
      messages: messages != null ? List<Message>.unmodifiable(messages) : messages,
      userRoom: userRoom != null ? List<UserRoom>.unmodifiable(userRoom) : userRoom);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Room &&
      id == other.id &&
      DeepCollectionEquality().equals(_messages, other._messages) &&
      DeepCollectionEquality().equals(_userRoom, other._userRoom);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Room {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Room copyWith({String? id, List<Message>? messages, List<UserRoom>? userRoom}) {
    return Room._internal(
      id: id ?? this.id,
      messages: messages ?? this.messages,
      userRoom: userRoom ?? this.userRoom);
  }
  
  Room.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _messages = json['messages'] is List
        ? (json['messages'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => Message.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _userRoom = json['userRoom'] is List
        ? (json['userRoom'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => UserRoom.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'messages': _messages?.map((Message? e) => e?.toJson()).toList(), 'userRoom': _userRoom?.map((UserRoom? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "room.id");
  static final QueryField MESSAGES = QueryField(
    fieldName: "messages",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (Message).toString()));
  static final QueryField USERROOM = QueryField(
    fieldName: "userRoom",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (UserRoom).toString()));
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Room";
    modelSchemaDefinition.pluralName = "Rooms";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: Room.MESSAGES,
      isRequired: true,
      ofModelName: (Message).toString(),
      associatedKey: Message.ROOM
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: Room.USERROOM,
      isRequired: true,
      ofModelName: (UserRoom).toString(),
      associatedKey: UserRoom.ROOM
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _RoomModelType extends ModelType<Room> {
  const _RoomModelType();
  
  @override
  Room fromJson(Map<String, dynamic> jsonData) {
    return Room.fromJson(jsonData);
  }
}