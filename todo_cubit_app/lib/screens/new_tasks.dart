import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:todo_cubit_app/models/task.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildListView();
    //   Column(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   mainAxisSize:MainAxisSize.max ,
    //   children: [
    //     Container(
    //         child: ),
    //   ],
    // );
  }

  Widget _buildListView() {
    final logger = Logger();

    return ValueListenableBuilder(
        valueListenable: Hive.box<Task>('tasks').listenable(),
        builder: (context, Box<Task> _tasksBox, _) {
          final tasksBox = _tasksBox;
          var filteredTasks = tasksBox.values
              .where((value) => value.status == Status.start)
              .toList();
          return Card(
            child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (BuildContext context, int index) {
                //  final task = tasksBox.getAt(index);
                  final task = filteredTasks[index];
                  return ListTile(
                    title: Text(filteredTasks[index].title.toString()),
                    subtitle: Text(filteredTasks[index].time.toString()),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'archive',
                            child: Row(
                              children: [
                                Icon(Icons.archive),
                                SizedBox(width: 15.0,),
                                Text('Archive'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'done',
                            child:  Row(
                              children: [
                                Icon(Icons.done_all),
                                SizedBox(width: 15.0,),
                                Text('Done'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child:  Row(
                              children: [
                                Icon(Icons.delete),
                                SizedBox(width: 15.0,),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ];
                      },
                      onSelected: (String value){
                        logger.i("on Selected = $value");
                        if(value == "archive"){
                          filteredTasks[index].status = Status.archive;
                          logger.i("Task after update = ${task}");
                          tasksBox.put(index, task);
                        }else if(value == "done"){
                          task.status = Status.done;
                          tasksBox.put(index, task);

                        }else if(value == "delete"){
                          task.delete();
                        }
                      },
                    ),

                    // onLongPress: () => _showDialog( context, index, task),
                  );
                }),
          );
        });
    // return WatchBoxBuilder(
    //   box:Hive.box('tasks') ,
    //   builder:(context, tasks) {
    //     print("test ============== ${tasks.values}=========== ${tasks.length}");
    //     return ListView.builder(
    //       itemCount: tasks.length,
    //       itemBuilder: (context, index){
    //         final task = tasks.getAt(index) as Task;
    //         print("test3 ============== ${task.time} =========== ${task.title}");
    //
    //         return ListTile(
    //           title: Text(task.title.toString()),
    //           subtitle: Text(task.time.toString()),
    //         );
    //       },
    //     );
    //   }
    // );
  }

  // Widget _showDialog(BuildContext context, int index, Task task) {
  //       return SimpleDialog(
  //         title: const Text('Actions on task'),
  //         children: <Widget>[
  //           Container(
  //               padding: const EdgeInsets.all(15.0),
  //               child: ListView(
  //                 children:  <Widget>[
  //                   ListTile(
  //                     leading: Icon(Icons.archive_outlined),
  //                     title: Text('Archive'),
  //                     onTap: updateTask(index, task),
  //                   ),
  //                   ListTile(
  //                     title: Text('Done'),
  //                     leading: Icon(Icons.checklist_outlined),
  //                   ),
  //                   ListTile(
  //                     title: Text('Delete'),
  //                     leading: Icon(Icons.delete),
  //                     onTap: () async => await task.delete(),
  //
  //                   ),
  //                 ],
  //               ),
  //             ),
  //         ],
  //       );
  //
  // }

  updateTask(int index, Task task) {
    final taskBox = Hive.box<Task>('tasks');
    // if (Hive.isBoxOpen('tasks')) {
    task.status = Status.archive;
    taskBox.put(index, task);
    // }
  }
}
