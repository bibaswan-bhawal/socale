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


/** This is an auto generated class representing the User type in your schema. */
@immutable
class User extends Model {
  static const classType = const _UserModelType();
  final String id;
  final String? _email;
  final String? _schoolEmail;
  final String? _firstName;
  final String? _lastName;
  final TemporalDate? _dateOfBirth;
  final TemporalDate? _graduationMonth;
  final List<String>? _major;
  final List<String>? _minor;
  final String? _college;
  final List<String>? _skills;
  final List<String>? _careerGoals;
  final List<String>? _selfDescription;
  final List<String>? _leisureInterests;
  final String? _idealFriendDescription;
  final List<int>? _situationalDecisions;
  final List<String>? _academicInterests;
  final String? _avatar;
  final String? _anonymousUsername;
  final List<Message>? _messages;
  final List<UserRoom>? _userRoom;
  final List<String>? _matches;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get email {
    try {
      return _email!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get schoolEmail {
    try {
      return _schoolEmail!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get firstName {
    try {
      return _firstName!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get lastName {
    return _lastName;
  }
  
  TemporalDate get dateOfBirth {
    try {
      return _dateOfBirth!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDate get graduationMonth {
    try {
      return _graduationMonth!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String> get major {
    try {
      return _major!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String> get minor {
    try {
      return _minor!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get college {
    try {
      return _college!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String> get skills {
    try {
      return _skills!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String> get careerGoals {
    try {
      return _careerGoals!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String> get selfDescription {
    try {
      return _selfDescription!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String> get leisureInterests {
    try {
      return _leisureInterests!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get idealFriendDescription {
    try {
      return _idealFriendDescription!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<int> get situationalDecisions {
    try {
      return _situationalDecisions!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String> get academicInterests {
    try {
      return _academicInterests!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get avatar {
    return _avatar;
  }
  
  String get anonymousUsername {
    try {
      return _anonymousUsername!;
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
  
  List<String> get matches {
    try {
      return _matches!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const User._internal({required this.id, required email, required schoolEmail, required firstName, lastName, required dateOfBirth, required graduationMonth, required major, required minor, required college, required skills, required careerGoals, required selfDescription, required leisureInterests, required idealFriendDescription, required situationalDecisions, required academicInterests, avatar, required anonymousUsername, messages, userRoom, required matches, createdAt, updatedAt}): _email = email, _schoolEmail = schoolEmail, _firstName = firstName, _lastName = lastName, _dateOfBirth = dateOfBirth, _graduationMonth = graduationMonth, _major = major, _minor = minor, _college = college, _skills = skills, _careerGoals = careerGoals, _selfDescription = selfDescription, _leisureInterests = leisureInterests, _idealFriendDescription = idealFriendDescription, _situationalDecisions = situationalDecisions, _academicInterests = academicInterests, _avatar = avatar, _anonymousUsername = anonymousUsername, _messages = messages, _userRoom = userRoom, _matches = matches, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory User({String? id, required String email, required String schoolEmail, required String firstName, String? lastName, required TemporalDate dateOfBirth, required TemporalDate graduationMonth, required List<String> major, required List<String> minor, required String college, required List<String> skills, required List<String> careerGoals, required List<String> selfDescription, required List<String> leisureInterests, required String idealFriendDescription, required List<int> situationalDecisions, required List<String> academicInterests, String? avatar, required String anonymousUsername, List<Message>? messages, List<UserRoom>? userRoom, required List<String> matches}) {
    return User._internal(
      id: id == null ? UUID.getUUID() : id,
      email: email,
      schoolEmail: schoolEmail,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      graduationMonth: graduationMonth,
      major: major != null ? List<String>.unmodifiable(major) : major,
      minor: minor != null ? List<String>.unmodifiable(minor) : minor,
      college: college,
      skills: skills != null ? List<String>.unmodifiable(skills) : skills,
      careerGoals: careerGoals != null ? List<String>.unmodifiable(careerGoals) : careerGoals,
      selfDescription: selfDescription != null ? List<String>.unmodifiable(selfDescription) : selfDescription,
      leisureInterests: leisureInterests != null ? List<String>.unmodifiable(leisureInterests) : leisureInterests,
      idealFriendDescription: idealFriendDescription,
      situationalDecisions: situationalDecisions != null ? List<int>.unmodifiable(situationalDecisions) : situationalDecisions,
      academicInterests: academicInterests != null ? List<String>.unmodifiable(academicInterests) : academicInterests,
      avatar: avatar,
      anonymousUsername: anonymousUsername,
      messages: messages != null ? List<Message>.unmodifiable(messages) : messages,
      userRoom: userRoom != null ? List<UserRoom>.unmodifiable(userRoom) : userRoom,
      matches: matches != null ? List<String>.unmodifiable(matches) : matches);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
      id == other.id &&
      _email == other._email &&
      _schoolEmail == other._schoolEmail &&
      _firstName == other._firstName &&
      _lastName == other._lastName &&
      _dateOfBirth == other._dateOfBirth &&
      _graduationMonth == other._graduationMonth &&
      DeepCollectionEquality().equals(_major, other._major) &&
      DeepCollectionEquality().equals(_minor, other._minor) &&
      _college == other._college &&
      DeepCollectionEquality().equals(_skills, other._skills) &&
      DeepCollectionEquality().equals(_careerGoals, other._careerGoals) &&
      DeepCollectionEquality().equals(_selfDescription, other._selfDescription) &&
      DeepCollectionEquality().equals(_leisureInterests, other._leisureInterests) &&
      _idealFriendDescription == other._idealFriendDescription &&
      DeepCollectionEquality().equals(_situationalDecisions, other._situationalDecisions) &&
      DeepCollectionEquality().equals(_academicInterests, other._academicInterests) &&
      _avatar == other._avatar &&
      _anonymousUsername == other._anonymousUsername &&
      DeepCollectionEquality().equals(_messages, other._messages) &&
      DeepCollectionEquality().equals(_userRoom, other._userRoom) &&
      DeepCollectionEquality().equals(_matches, other._matches);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("User {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("schoolEmail=" + "$_schoolEmail" + ", ");
    buffer.write("firstName=" + "$_firstName" + ", ");
    buffer.write("lastName=" + "$_lastName" + ", ");
    buffer.write("dateOfBirth=" + (_dateOfBirth != null ? _dateOfBirth!.format() : "null") + ", ");
    buffer.write("graduationMonth=" + (_graduationMonth != null ? _graduationMonth!.format() : "null") + ", ");
    buffer.write("major=" + (_major != null ? _major!.toString() : "null") + ", ");
    buffer.write("minor=" + (_minor != null ? _minor!.toString() : "null") + ", ");
    buffer.write("college=" + "$_college" + ", ");
    buffer.write("skills=" + (_skills != null ? _skills!.toString() : "null") + ", ");
    buffer.write("careerGoals=" + (_careerGoals != null ? _careerGoals!.toString() : "null") + ", ");
    buffer.write("selfDescription=" + (_selfDescription != null ? _selfDescription!.toString() : "null") + ", ");
    buffer.write("leisureInterests=" + (_leisureInterests != null ? _leisureInterests!.toString() : "null") + ", ");
    buffer.write("idealFriendDescription=" + "$_idealFriendDescription" + ", ");
    buffer.write("situationalDecisions=" + (_situationalDecisions != null ? _situationalDecisions!.toString() : "null") + ", ");
    buffer.write("academicInterests=" + (_academicInterests != null ? _academicInterests!.toString() : "null") + ", ");
    buffer.write("avatar=" + "$_avatar" + ", ");
    buffer.write("anonymousUsername=" + "$_anonymousUsername" + ", ");
    buffer.write("matches=" + (_matches != null ? _matches!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  User copyWith({String? id, String? email, String? schoolEmail, String? firstName, String? lastName, TemporalDate? dateOfBirth, TemporalDate? graduationMonth, List<String>? major, List<String>? minor, String? college, List<String>? skills, List<String>? careerGoals, List<String>? selfDescription, List<String>? leisureInterests, String? idealFriendDescription, List<int>? situationalDecisions, List<String>? academicInterests, String? avatar, String? anonymousUsername, List<Message>? messages, List<UserRoom>? userRoom, List<String>? matches}) {
    return User._internal(
      id: id ?? this.id,
      email: email ?? this.email,
      schoolEmail: schoolEmail ?? this.schoolEmail,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      graduationMonth: graduationMonth ?? this.graduationMonth,
      major: major ?? this.major,
      minor: minor ?? this.minor,
      college: college ?? this.college,
      skills: skills ?? this.skills,
      careerGoals: careerGoals ?? this.careerGoals,
      selfDescription: selfDescription ?? this.selfDescription,
      leisureInterests: leisureInterests ?? this.leisureInterests,
      idealFriendDescription: idealFriendDescription ?? this.idealFriendDescription,
      situationalDecisions: situationalDecisions ?? this.situationalDecisions,
      academicInterests: academicInterests ?? this.academicInterests,
      avatar: avatar ?? this.avatar,
      anonymousUsername: anonymousUsername ?? this.anonymousUsername,
      messages: messages ?? this.messages,
      userRoom: userRoom ?? this.userRoom,
      matches: matches ?? this.matches);
  }
  
  User.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _email = json['email'],
      _schoolEmail = json['schoolEmail'],
      _firstName = json['firstName'],
      _lastName = json['lastName'],
      _dateOfBirth = json['dateOfBirth'] != null ? TemporalDate.fromString(json['dateOfBirth']) : null,
      _graduationMonth = json['graduationMonth'] != null ? TemporalDate.fromString(json['graduationMonth']) : null,
      _major = json['major']?.cast<String>(),
      _minor = json['minor']?.cast<String>(),
      _college = json['college'],
      _skills = json['skills']?.cast<String>(),
      _careerGoals = json['careerGoals']?.cast<String>(),
      _selfDescription = json['selfDescription']?.cast<String>(),
      _leisureInterests = json['leisureInterests']?.cast<String>(),
      _idealFriendDescription = json['idealFriendDescription'],
      _situationalDecisions = (json['situationalDecisions'] as List?)?.map((e) => (e as num).toInt()).toList(),
      _academicInterests = json['academicInterests']?.cast<String>(),
      _avatar = json['avatar'],
      _anonymousUsername = json['anonymousUsername'],
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
      _matches = json['matches']?.cast<String>(),
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'email': _email, 'schoolEmail': _schoolEmail, 'firstName': _firstName, 'lastName': _lastName, 'dateOfBirth': _dateOfBirth?.format(), 'graduationMonth': _graduationMonth?.format(), 'major': _major, 'minor': _minor, 'college': _college, 'skills': _skills, 'careerGoals': _careerGoals, 'selfDescription': _selfDescription, 'leisureInterests': _leisureInterests, 'idealFriendDescription': _idealFriendDescription, 'situationalDecisions': _situationalDecisions, 'academicInterests': _academicInterests, 'avatar': _avatar, 'anonymousUsername': _anonymousUsername, 'messages': _messages?.map((Message? e) => e?.toJson()).toList(), 'userRoom': _userRoom?.map((UserRoom? e) => e?.toJson()).toList(), 'matches': _matches, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField EMAIL = QueryField(fieldName: "email");
  static final QueryField SCHOOLEMAIL = QueryField(fieldName: "schoolEmail");
  static final QueryField FIRSTNAME = QueryField(fieldName: "firstName");
  static final QueryField LASTNAME = QueryField(fieldName: "lastName");
  static final QueryField DATEOFBIRTH = QueryField(fieldName: "dateOfBirth");
  static final QueryField GRADUATIONMONTH = QueryField(fieldName: "graduationMonth");
  static final QueryField MAJOR = QueryField(fieldName: "major");
  static final QueryField MINOR = QueryField(fieldName: "minor");
  static final QueryField COLLEGE = QueryField(fieldName: "college");
  static final QueryField SKILLS = QueryField(fieldName: "skills");
  static final QueryField CAREERGOALS = QueryField(fieldName: "careerGoals");
  static final QueryField SELFDESCRIPTION = QueryField(fieldName: "selfDescription");
  static final QueryField LEISUREINTERESTS = QueryField(fieldName: "leisureInterests");
  static final QueryField IDEALFRIENDDESCRIPTION = QueryField(fieldName: "idealFriendDescription");
  static final QueryField SITUATIONALDECISIONS = QueryField(fieldName: "situationalDecisions");
  static final QueryField ACADEMICINTERESTS = QueryField(fieldName: "academicInterests");
  static final QueryField AVATAR = QueryField(fieldName: "avatar");
  static final QueryField ANONYMOUSUSERNAME = QueryField(fieldName: "anonymousUsername");
  static final QueryField MESSAGES = QueryField(
    fieldName: "messages",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (Message).toString()));
  static final QueryField USERROOM = QueryField(
    fieldName: "userRoom",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (UserRoom).toString()));
  static final QueryField MATCHES = QueryField(fieldName: "matches");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "User";
    modelSchemaDefinition.pluralName = "Users";
    
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
      key: User.EMAIL,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.SCHOOLEMAIL,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.FIRSTNAME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.LASTNAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.DATEOFBIRTH,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.GRADUATIONMONTH,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.MAJOR,
      isRequired: true,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.string))
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.MINOR,
      isRequired: true,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.string))
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.COLLEGE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.SKILLS,
      isRequired: true,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.string))
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.CAREERGOALS,
      isRequired: true,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.string))
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.SELFDESCRIPTION,
      isRequired: true,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.string))
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.LEISUREINTERESTS,
      isRequired: true,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.string))
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.IDEALFRIENDDESCRIPTION,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.SITUATIONALDECISIONS,
      isRequired: true,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.int))
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.ACADEMICINTERESTS,
      isRequired: true,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.string))
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.AVATAR,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.ANONYMOUSUSERNAME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: User.MESSAGES,
      isRequired: true,
      ofModelName: (Message).toString(),
      associatedKey: Message.AUTHOR
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: User.USERROOM,
      isRequired: false,
      ofModelName: (UserRoom).toString(),
      associatedKey: UserRoom.USER
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: User.MATCHES,
      isRequired: true,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.string))
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

class _UserModelType extends ModelType<User> {
  const _UserModelType();
  
  @override
  User fromJson(Map<String, dynamic> jsonData) {
    return User.fromJson(jsonData);
  }
}