import 'package:hive_flutter/hive_flutter.dart';
part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {

  @HiveField(0)
  String? title;
  
  @HiveField(1)
  String? date;
  
  @HiveField(2)
  String? time;
  
  @HiveField(3)
  Status? status;

  Task({
    required this.title,
    required this.date,
    required this.time,
    required this.status
   });

}


@HiveType(typeId: 2)
enum Status  {
  @HiveField(0)
  start,
  @HiveField(1)
  done,
  @HiveField(2)
  archive
}