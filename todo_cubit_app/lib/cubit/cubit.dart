import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit_app/cubit/state.dart';
import 'package:todo_cubit_app/screens/archive_tasks.dart';
import 'package:todo_cubit_app/screens/done_tasks.dart';
import 'package:todo_cubit_app/screens/new_tasks.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppIniState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;
  int currentIndex = 1;
  List<Widget> screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchiveTasksScreen()
  ];

  List<String> titles = ['Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void changeBottomSheetState(bool isShow, IconData iconData) {
    fabIcon = iconData;
    isBottomSheetShow = isShow;
    emit(AppChangeBottomSheetState());
  }
}
