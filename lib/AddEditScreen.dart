
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_management_app/SignUp.dart';
import 'package:project_management_app/Task.dart';
import 'package:project_management_app/database.dart';

import 'CustomButton.dart';
import 'CustomTextField.dart';
import 'TaskStatues.dart';



class SecondScreen extends StatefulWidget
{

  const SecondScreen({Key key, this.myTask}) : super(key: key);
  final Task myTask;

  @override
  State<StatefulWidget> createState() => _SecondScreenState();

}
class _SecondScreenState extends State<SecondScreen>
{


  List<String> _dropdownItems = [TaskStatues.Todo.name, TaskStatues.Doing.name, TaskStatues.Done.name];
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String _itemSelected;
  List<Task> taskList = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool edit = false;
  String btnTitle = "Add";


  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _itemSelected = _dropdownMenuItems[0].value;
    if (widget.myTask != null)
      {
        titleController.text=widget.myTask.title;
        descriptionController.text = widget.myTask.description;
        edit = true;
        btnTitle = "Edit";
        _itemSelected = widget.myTask.statues;
      }

  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    // ignore: deprecated_member_use
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, taskList);
          },
        ),
        title: Text(title),
      ),
      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(linesNum: 1,hint:'Task Title', verNum: 20,controller: titleController,),
                  CustomTextField(linesNum: 3,hint:'Task description', verNum: 20,controller: descriptionController,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        padding: const EdgeInsets.all(5.0),
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.purpleAccent,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: _dropdownMenuItems,
                            value: _itemSelected,
                            onChanged: (value) {
                              setState(() {
                                _itemSelected = value;
                              });
                            },
                            //style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        )
                    ),
                  ),
                  CustomButton(fun:() async {

                    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
                    final taskDao = database.taskDao;

                    if (edit)
                      {
                        final task = Task(title: titleController.text,
                            description: descriptionController.text,
                            statues: _itemSelected, id: widget.myTask.id);
                        await taskDao.updateTask(task);
                        Navigator.pop(context, task);
                      }
                    else {

                      final task = Task(title: titleController.text,
                          description: descriptionController.text,
                          statues: _itemSelected);
                      await taskDao.insertTask(task);
                      taskList.add(task);

                      setState(() {
                        titleController.clear();
                        descriptionController.clear();
                        _itemSelected = _dropdownMenuItems[0].value;
                      });
                    }
                  },
                    title: btnTitle,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



