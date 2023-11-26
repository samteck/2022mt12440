import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:test_project/task.dart';
import 'package:test_project/taskDetails.dart';
import 'package:test_project/taskForm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = '********'; //ping me for keys: +91-8802952380
  const keyClientKey = '*******'; //ping me for keys: +91-8802952380
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App for BITS Assignment',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TaskList(),
    );
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = [];
  bool isfilter = false;
  void _navigateToAddTask(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const TaskForm()))
        .then((value) => getTodo());
  }

  void _navigateToDetailsTask(BuildContext context, Task task) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => TaskDetailsForm(task)));
  }

  void _checkDialog(
      String title, String message, String action, Task task) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Expanded(
              child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.cancel_outlined)),
              ElevatedButton(
                  onPressed: () {
                    if (action == "delete") {
                      this._deleteTask(task);
                      Navigator.pop(context);
                    } else if (action == "done") {
                      this._doneTask(task);
                      Navigator.pop(context);
                    }
                  },
                  child: Icon(Icons.done_outline))
            ],
          ));
        });
  }

  void _deleteTask(Task task) async {
    var taskObj = ParseObject("Task")..objectId = task.taskId;
    await taskObj.delete().then((value) => getTodo());
  }

  void _doneTask(Task task) {
    var taskObj = ParseObject("Task")..objectId = task.taskId;
    taskObj.set("taskStatus", "done");
    taskObj.update().then((value) => getTodo());
  }

  void _updateTask(Task task) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => TaskForm(isUpdate: true, task: task)))
        .then((value) => getTodo());
  }

  @override
  Widget build(BuildContext context) {
    getTodo();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Task List'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _navigateToAddTask(context),
          child: Icon(Icons.add_circle_outline),
        ),
        body: Scaffold(
            bottomSheet: Flex(
              direction: Axis.horizontal,
              children: [
                Checkbox(
                  value: isfilter,
                  onChanged: (value) {
                    setState(() {
                      isfilter = value!;
                    });
                  },
                ),
                Text("Not Done Filter")
              ],
            ),
            body: Padding(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  if (isfilter == true && tasks[index].taskStatus != "open") {
                    return SizedBox();
                  }
                  return ListTile(
                      title: Text(tasks[index].taskName),
                      subtitle: Row(children: [
                        tasks[index].taskStatus == "open"
                            ? IconButton(
                                onPressed: () {
                                  this._checkDialog(
                                      "Done Task",
                                      "are you really want to done this?",
                                      "done",
                                      tasks[index]);
                                },
                                icon: Icon(Icons.done))
                            : Icon(Icons.done_all_rounded, color: Colors.green),
                        tasks[index].taskStatus == "open"
                            ? IconButton(
                                onPressed: () {
                                  this._checkDialog(
                                      "Delete Task",
                                      "Do you want to delete this task",
                                      "delete",
                                      this.tasks[index]);
                                },
                                icon: Icon(Icons.delete))
                            : Text(""),
                        tasks[index].taskStatus == "open"
                            ? IconButton(
                                onPressed: () {
                                  this._updateTask(this.tasks[index]);
                                },
                                icon: Icon(Icons.edit))
                            : Text("")
                      ], textDirection: TextDirection.rtl),
                      onTap: () {
                        _navigateToDetailsTask(context, tasks[index]);
                      });
                },
              ),
              padding: EdgeInsets.fromLTRB(5, 5, 5, 70),
            )));
  }

  void getTodo() async {
    var taskQuery = QueryBuilder<ParseObject>(ParseObject("Task"))
      ..orderByDescending("taskStatus")
      ..orderByAscending("taskName");
    final taskResponse = await taskQuery.query();
    var taskResults = <Task>[];
    if (taskResponse.success && taskResponse.results != null) {
      taskResults.clear();
      for (var o in taskResponse.results!) {
        var taskMap = o as ParseObject;
        var taskId = taskMap.objectId;
        var taskName = taskMap.get("taskName", defaultValue: "");
        var taskDescription = taskMap.get("taskDescription", defaultValue: "");
        var taskStatus = taskMap.get("taskStatus", defaultValue: "open");
        var taskObj = Task(taskId!, taskName!, taskDescription!, taskStatus!);
        taskResults.add(taskObj);
      }
    }
    setState(() {
      tasks
        ..clear()
        ..addAll(taskResults);
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}
