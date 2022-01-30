import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:todo_cubit_app/models/task.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  // 1. create database
  // 2. create tables
  // 2. open database to make operation on it.
  @override
  Widget build(BuildContext context) {
    return _buildListView();
  }



  Widget _buildListView(){
    return ValueListenableBuilder(
        valueListenable: Hive.box<Task>('tasks').listenable(),
        builder: (context, Box<Task> _tasksBox, _) {
          final tasksBox = _tasksBox;
          var filteredTasks = tasksBox.values
              .where((value) => value.status == Status.done)
              .toList();
          final logger = Logger();

          return Card(
            child: ListView.builder(

                itemCount: filteredTasks.length,
                itemBuilder: (BuildContext context, int index) {
                //  final task = filteredTasks.getAt(index);
                  final task = filteredTasks[index];

                  print(filteredTasks.length);
                  return ListTile(
                    title: Text(filteredTasks[index].title.toString()),
                    subtitle: Text(filteredTasks[index].time.toString()) ,
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
                        logger.i("on Selected = ${value}");
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

                    //onLongPress: () => _showDialog( context, index, task),
                  );
                }),
          );
        });

  }
}
