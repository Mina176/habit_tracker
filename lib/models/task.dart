import 'dart:async';
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  Task({required this.id, required this.icon, required this.iconName});
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String icon;
  @HiveField(2)
  final String iconName;
}
