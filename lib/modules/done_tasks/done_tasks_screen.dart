import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/status.dart';

class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
        builder: (context, state) {
          var tasks = AppCubit.get(context).doneTasks;
          return tasksBuilder(tasks: tasks);
        },
        listener: (context, state) {});
  }
}
