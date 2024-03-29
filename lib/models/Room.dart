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
  final String? _lastMessageSent;
  final String? _roomType;
  final List<Message>? _messages;
  final List<UserRoom>? _userRoom;
  final String? _isHidden;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get lastMessageSent {
    return _lastMessageSent;
  }
  
  String get roomType {
    try {
      return _roomType!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<Message>? get messages {
    return _messages;
  }
  
  List<UserRoom>? get userRoom {
    return _userRoom;
  }
  
  String get isHidden {
    try {
      return _isHidden!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime get createdAt {
    try {
      return _createdAt!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime get updatedAt {
    try {
      return _updatedAt!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  const Room._internal({required this.id, lastMessageSent, required roomType, messages, userRoom, required isHidden, required createdAt, required updatedAt}): _lastMessageSent = lastMessageSent, _roomType = roomType, _messages = messages, _userRoom = userRoom, _isHidden = isHidden, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Room({String? id, String? lastMessageSent, required String roomType, List<Message>? messages, List<UserRoom>? userRoom, required String isHidden, required TemporalDateTime createdAt, required TemporalDateTime updatedAt}) {
    return Room._internal(
      id: id == null ? UUID.getUUID() : id,
      lastMessageSent: lastMessageSent,
      roomType: roomType,
      messages: messages != null ? List<Message>.unmodifiable(messages) : messages,
      userRoom: userRoom != null ? List<UserRoom>.unmodifiable(userRoom) : userRoom,
      isHidden: isHidden,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Room &&
      id == other.id &&
      _lastMessageSent == other._lastMessageSent &&
      _roomType == other._roomType &&
      DeepCollectionEquality().equals(_messages, other._messages) &&
      DeepCollectionEquality().equals(_userRoom, other._userRoom) &&
      _isHidden == other._isHidden &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Room {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("lastMessageSent=" + "$_lastMessageSent" + ", ");
    buffer.write("roomType=" + "$_roomType" + ", ");
    buffer.write("isHidden=" + "$_isHidden" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Room copyWith({String? id, String? lastMessageSent, String? roomType, List<Message>? messages, List<UserRoom>? userRoom, String? isHidden, TemporalDateTime? createdAt, TemporalDateTime? updatedAt}) {
    return Room._internal(
      id: id ?? this.id,
      lastMessageSent: lastMessageSent ?? this.lastMessageSent,
      roomType: roomType ?? this.roomType,
      messages: messages ?? this.messages,
      userRoom: userRoom ?? this.userRoom,
      isHidden: isHidden ?? this.isHidden,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  Room.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _lastMessageSent = json['lastMessageSent'],
      _roomType = json['roomType'],
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
      _isHidden = json['isHidden'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'lastMessageSent': _lastMessageSent, 'roomType': _roomType, 'messages': _messages?.map((Message? e) => e?.toJson()).toList(), 'userRoom': _userRoom?.map((UserRoom? e) => e?.toJson()).toList(), 'isHidden': _isHidden, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id, 'lastMessageSent': _lastMessageSent, 'roomType': _roomType, 'messages': _messages, 'userRoom': _userRoom, 'isHidden': _isHidden, 'createdAt': _createdAt, 'updatedAt': _updatedAt
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField LASTMESSAGESENT = QueryField(fieldName: "lastMessageSent");
  static final QueryField ROOMTYPE = QueryField(fieldName: "roomType");
  static final QueryField MESSAGES = QueryField(
    fieldName: "messages",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (Message).toString()));
  static final QueryField USERROOM = QueryField(
    fieldName: "userRoom",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (UserRoom).toString()));
  static final QueryField ISHIDDEN = QueryField(fieldName: "isHidden");
  static final QueryField CREATEDAT = QueryField(fieldName: "createdAt");
  static final QueryField UPDATEDAT = QueryField(fieldName: "updatedAt");
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
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Room.LASTMESSAGESENT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Room.ROOMTYPE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
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
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Room.ISHIDDEN,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Room.CREATEDAT,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Room.UPDATEDAT,
      isRequired: true,
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