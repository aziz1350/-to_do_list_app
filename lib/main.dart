import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      home: ToDoHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ToDoHomePage extends StatefulWidget {
  @override
  _ToDoHomePageState createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<ToDoHomePage> {
  List<String> _taskList = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load saved tasks on startup
  }

  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _taskList = prefs.getStringList('tasks') ?? [];
    });
  }

  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks', _taskList);
  }

  void _addTask(String task) {
    if (task.trim().isEmpty) return;

    setState(() {
      _taskList.add(task);
      _controller.clear();
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter task...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _addTask(_controller.text),
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _taskList.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_taskList[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
