
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_management_app/AddEditScreen.dart';
import 'package:project_management_app/SignIn.dart';
import 'package:project_management_app/SignUp.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'Auth.dart';
import 'SignUp.dart';
import 'Task.dart';
import 'TaskStatues.dart';
import 'database.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var user = prefs.getString('user');
  runApp(MyApp(myHome:user == null ? SignIn() : MyHomePage(),));
  //runApp(MyApp(myHome: SignUp(),));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application
  final Widget myHome;

  const MyApp({Key key, this.myHome}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor:Colors.purpleAccent,
        accentColor: Colors.purpleAccent,
        // primarySwatch: Colors.blue,
      ),
      home: myHome,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }


  List<String> _dropdownItems = ["All",TaskStatues.Todo.name, TaskStatues.Doing.name, TaskStatues.Done.name];
  int listLength= 0 ;

  List<DropdownMenuItem<String>> _dropdownMenuItems;
  List<Task> allitems = [] ;
  List<Task> listViewItems = [] ;
  String _itemSelected;
  AuthService _auth = AuthService();

  getData () async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final taskDao = database.taskDao;
    final list = await taskDao.findAllTasks();
    setState(() {
      listViewItems.clear();
      allitems.clear();
      allitems.addAll(list);
      listViewItems.addAll(list);
    });
  }

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _itemSelected = _dropdownMenuItems[0].value;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getData();
    });

  }



  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    // ignore: deprecated_member_use
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text (listItem),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(IconData(0xe848, fontFamily: 'MaterialIcons'), color: Colors.white),
          onPressed: () async {
            _auth.signOut();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('user');
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext ctx) => SignIn()));
          },
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  padding: const EdgeInsets.all(5.0),
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  items: _dropdownMenuItems,
                  value: _itemSelected,
                  onChanged: (value) {
                      setState(() {
                        _itemSelected = value;
                        listViewItems.clear();
                        //listViewItems.addAll(allListViewItems);
                       if (_itemSelected ==_dropdownItems[0])
                          {
                            for (int i=0 ; i < allitems.length; i++)
                              listViewItems.add(allitems[i]);
                          }
                        else
                          {
                            for (int i=0 ; i < allitems.length; i++)
                              if (allitems[i].statues.trim() == _itemSelected.trim())
                                listViewItems.add(allitems[i]);
                          }
                      });
                  },
                ),
              )
              ),
            ),
            Expanded(child: ListView.builder(
              itemCount: listViewItems.length,
              itemBuilder: (context, index) {
                return  Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purpleAccent, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(listViewItems[index].title,
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                                Text("Status : " + listViewItems[index].statues,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Update',
                      color: Colors.blue,
                      icon: Icons.archive,
                      onTap: () async {

                        dynamic newTask = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SecondScreen(myTask: listViewItems[index],)),
                        );
                        if (newTask != null) {
                          setState(() {
                            listViewItems[index] = newTask;
                          });
                        }

                      },
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () async {
                        final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
                        final taskDao = database.taskDao;
                        await taskDao.deleteTask(listViewItems[index]);
                        setState(() {
                          listViewItems.remove(listViewItems[index]);
                          allitems.remove(allitems[index]);
                        });
                      },
                    ),
                  ],
                );
              },
            ),  )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          List<Task> result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondScreen()),
          );
          if(result.length!=0) {
            setState(() {
              //listViewItems.clear();
              allitems.addAll(result);
              if (_itemSelected.trim() == _dropdownItems[0])
                listViewItems.addAll(result);
              else {
                for (int i = 0; i < result.length; i++)
                  if (result[i].statues.trim() == _itemSelected.trim())
                    listViewItems.add(result[i]);
                //listViewItems.addAll(result);
              }
            });
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
