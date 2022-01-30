import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_cubit_app/models/task.dart';
import 'package:todo_cubit_app/screens/home.dart';

void main() async {
  // to await all init method in main
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(StatusAdapter());
  debugShowCheckedModeBanner : false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks',
      home: FutureBuilder(
          future: Hive.openBox<Task>('tasks'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return HomeScreen();
              }
            } else {
              return const Scaffold();
            }
          }),
    );
  }
}
