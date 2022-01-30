import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:todo_cubit_app/cubit/cubit.dart';
import 'package:todo_cubit_app/cubit/state.dart';
import 'package:todo_cubit_app/models/task.dart';


class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  String title = "";

  String date = "";

  String time = "";

  final logger = Logger();

  HomeScreen({Key? key}) : super(key: key);

  Widget buildInputFieldTask(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsetsDirectional.all(20.0),
      child: Form(
        key: formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            controller: titleController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                labelText: 'Task title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title)),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'title is required';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 15.0,
          ),
          TextFormField(
            readOnly: true,
            controller: timeController,
            keyboardType: TextInputType.datetime,
            onTap: () {
              showTimePicker(context: context, initialTime: TimeOfDay.now())
                  .then((_value) {
                timeController.text = _value!.format(context).toString();
              });
            },
            decoration: const InputDecoration(
                labelText: 'Task time',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.watch_later_outlined)),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'time is required';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 15.0,
          ),
          TextFormField(
            readOnly: true,
            controller: dateController,
            keyboardType: TextInputType.datetime,
            onTap: () {
              showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.parse('2025-12-12'))
                  .then((_value) {
                dateController.text = DateFormat.yMMMd().format(_value!);
              });
            },
            decoration: const InputDecoration(
                labelText: 'Task date',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today_outlined)),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'date is required';
              }
              return null;
            },
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, AppState state) {},
        builder: (BuildContext context, AppState state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
              // actions: <Widget>[
              //   IconButton(
              //       icon: Icon(Icons.delete),
              //       onPressed: () {
              //         setState(() {
              //
              //         });
              //       }),
              // ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if (formKey.currentState!.validate()) {
                    title = titleController.text.toString();
                    date = dateController.text.toString();
                    time = timeController.text.toString();
                    final task = Task(
                        title: title,
                        date: date,
                        time: time,
                        status: Status.start);
                    logger.i("task = ${task.title}");
                    addTask(task);
                    Navigator.pop(context);
                    cubit.changeBottomSheetState(false, Icons.edit);
                    // cubit.isBottomSheetShow = false;
                    // setState(() {
                    //   fabIcon = Icons.edit;
                    // });
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                          (_context) => buildInputFieldTask(context))
                      .closed
                      .then((value) =>
                      cubit.changeBottomSheetState(false, Icons.add));
                  cubit.changeBottomSheetState(true, Icons.add);
                  // cubit.isBottomSheetShow = true;
                  // setState(() {
                  //
                  // });
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            body: ConditionalBuilder(
              condition: true,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center(
                child: CircularProgressIndicator(
                  value: 0.8,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex, // to selected item init
              onTap: (index) {
                cubit.changeIndex(index);
              },

              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.checklist_outlined,
                    ),
                    label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_outlined,
                    ),
                    label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }

  addTask(Task task) {
    final taskBox = Hive.box<Task>('tasks');
    // if (Hive.isBoxOpen('tasks')) {
    taskBox.add(task);
    // }
  }
}
