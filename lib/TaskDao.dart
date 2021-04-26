// TODO Implement this library.
import 'dart:io';

import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

import 'Task.dart';

@dao
abstract class TaskDao {
  @Query('SELECT * FROM Task')
  Future<List<Task>> findAllTasks();

 /* @Query('SELECT * FROM Task WHERE id = :id')
  Stream<Task?> findTaskById(int id);  */ //?

  @insert
  Future<void> insertTask(Task task);

  @delete
  Future<void> deleteTask (Task task);

  @update
  Future<void> updateTask(Task task);



 /* @Query ('SELECT * FROM Task WHERE statues = :statues AND statues IS NOT NULL')
  Future<List<Task>> findTaskByStatus(String statues);*/

}