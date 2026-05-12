// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
  userId: json['userId'] as String,
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
  'userId': instance.userId,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
};
