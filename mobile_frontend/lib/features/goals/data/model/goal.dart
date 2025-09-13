import 'package:json_annotation/json_annotation.dart';

part 'goal.g.dart';

@JsonSerializable()
class Goal {
  final String id;
  final String name;
  @JsonKey(name: 'target_amount')
  final int targetAmount;
  @JsonKey(name: 'current_amount')
  final int currentAmount;
  @JsonKey(name: 'target_date')
  final String? targetDate; // ISO date
  @JsonKey(name: 'created_at')
  final String createdAt; // ISO datetime

  const Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.createdAt,
    this.targetDate,
  });

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
  Map<String, dynamic> toJson() => _$GoalToJson(this);
}

