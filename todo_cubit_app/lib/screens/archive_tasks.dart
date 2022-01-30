import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_cubit_app/models/task.dart';

class ArchiveTasksScreen extends StatelessWidget {
  const ArchiveTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildListView();
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Task>('tasks').listenable(),
        builder: (context, Box<Task> _tasksBox, _) {
          final tasksBox = _tasksBox;
          var filteredTasks = tasksBox.values
              .where((value) => value.status == Status.archive)
              .toList();
          return Card(
            child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (BuildContext context, int index) {
                  //  final task = filteredTasks.getAt(index);
                  print(filteredTasks.length);
                  return ListTile(
                    title: Text(filteredTasks[index].title.toString()),
                    subtitle: Text(filteredTasks[index].time.toString()),
                    //onLongPress: () => _showDialog( context, index, task),
                  );
                }),
          );
        });
  }
}
