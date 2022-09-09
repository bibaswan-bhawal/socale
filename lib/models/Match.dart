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
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Match type in your schema. */
@immutable
class Match extends Model {
  static const classType = const _MatchModelType();
  final String id;
  final String? _matchingPercentage;
  final User? _user;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;
  final String? _matchUserId;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get matchingPercentage {
    return _matchingPercentage;
  }
  
  User? get user {
    return _user;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  String? get matchUserId {
    return _matchUserId;
  }
  
  const Match._internal({required this.id, matchingPercentage, user, createdAt, updatedAt, matchUserId}): _matchingPercentage = matchingPercentage, _user = user, _createdAt = createdAt, _updatedAt = updatedAt, _matchUserId = matchUserId;
  
  factory Match({String? id, String? matchingPercentage, User? user, String? matchUserId}) {
    return Match._internal(
      id: id == null ? UUID.getUUID() : id,
      matchingPercentage: matchingPercentage,
      user: user,
      matchUserId: matchUserId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Match &&
      id == other.id &&
      _matchingPercentage == other._matchingPercentage &&
      _user == other._user &&
      _matchUserId == other._matchUserId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Match {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("matchingPercentage=" + "$_matchingPercentage" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null") + ", ");
    buffer.write("matchUserId=" + "$_matchUserId");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Match copyWith({String? id, String? matchingPercentage, User? user, String? matchUserId}) {
    return Match._internal(
      id: id ?? this.id,
      matchingPercentage: matchingPercentage ?? this.matchingPercentage,
      user: user ?? this.user,
      matchUserId: matchUserId ?? this.matchUserId);
  }
  
  Match.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _matchingPercentage = json['matchingPercentage'],
      _user = json['user']?['serializedData'] != null
        ? User.fromJson(new Map<String, dynamic>.from(json['user']['serializedData']))
        : null,
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null,
      _matchUserId = json['matchUserId'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'matchingPercentage': _matchingPercentage, 'user': _user?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format(), 'matchUserId': _matchUserId
  };

  static final QueryField ID = QueryField(fieldName: "match.id");
  static final QueryField MATCHINGPERCENTAGE = QueryField(fieldName: "matchingPercentage");
  static final QueryField USER = QueryField(
    fieldName: "user",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (User).toString()));
  static final QueryField MATCHUSERID = QueryField(fieldName: "matchUserId");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Match";
    modelSchemaDefinition.pluralName = "Matches";
    
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
      key: Match.MATCHINGPERCENTAGE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasOne(
      key: Match.USER,
      isRequired: false,
      ofModelName: (User).toString(),
      associatedKey: User.ID
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
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Match.MATCHUSERID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _MatchModelType extends ModelType<Match> {
  const _MatchModelType();
  
  @override
  Match fromJson(Map<String, dynamic> jsonData) {
    return Match.fromJson(jsonData);
  }
}