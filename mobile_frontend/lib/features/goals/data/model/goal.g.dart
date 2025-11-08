// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Goal _$GoalFromJson(Map<String, dynamic> json) => Goal(
  id: json['id'] as String,
  name: json['name'] as String,
  targetAmount: (json['target_amount'] as num).toInt(),
  currentAmount: (json['current_amount'] as num).toInt(),
  createdAt: json['created_at'] as String,
  targetDate: json['target_date'] as String?,
  emoji: json['emoji'] as String?,
);

Map<String, dynamic> _$GoalToJson(Goal instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'target_amount': instance.targetAmount,
  'current_amount': instance.currentAmount,
  'target_date': instance.targetDate,
  'created_at': instance.createdAt,
  'emoji': instance.emoji,
};
