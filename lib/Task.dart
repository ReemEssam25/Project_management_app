// TODO Implement this library.
import 'package:floor/floor.dart';
/*class Task
{
  String title, description;

  Task(this.title, this.description, this.Statues);

  TaskStatues Statues;

}*/
@Entity (tableName: 'Task')
class Task
{
  @PrimaryKey(autoGenerate: true)
  final int id;
  //static int staticID = 0;
  final String title, description;
  final String statues;
  Task({this.id,this.title, this.description, this.statues});



}

