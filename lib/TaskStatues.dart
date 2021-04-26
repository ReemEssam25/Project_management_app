import 'Task.dart';

enum TaskStatues
{
  Todo, Doing ,Done
}
extension StatusExtention on TaskStatues {
  String get name {
    switch (this) {
      case TaskStatues.Todo:
        return "Todo";
      case TaskStatues.Doing :
        return "Doing";
      case TaskStatues.Done :
        return "Done";
      default:
        return null;
    }
  }
}
final String title = 'Project Management App';
