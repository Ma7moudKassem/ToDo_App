import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/status.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
          listener: (BuildContext context, AppState state) {
        if (state is AppInsertDatabaseState) {
          Navigator.pop(context);
        }
      }, builder: (BuildContext context, AppState state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
          ),
          body: ConditionalBuilder(
            condition: state is! AppGetDatabaseLoadingState,
            builder: (context) => cubit.screen[cubit.currentIndex],
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formKey.currentState.validate()) {
                  cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text);
                }
              } else {
                scaffoldKey.currentState
                    .showBottomSheet(
                      (context) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultTextFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  prefix: Icons.title,
                                  lapelText: 'Task Title',
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return ('Title must not be empty ');
                                    }
                                    return null;
                                  }),
                              SizedBox(
                                height: 15,
                              ),
                              defaultTextFormField(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value.format(context).toString();
                                      print(value.format(context));
                                    });
                                  },
                                  prefix: Icons.watch_later_outlined,
                                  lapelText: 'Task Time',
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return ('Time must not be empty ');
                                    }
                                    return null;
                                  }),
                              SizedBox(
                                height: 15,
                              ),
                              defaultTextFormField(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2021-09-01'),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value);
                                    });
                                  },
                                  prefix: Icons.calendar_today,
                                  lapelText: 'Task Date',
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return ('Date must not be empty ');
                                    }
                                    return null;
                                  }),
                            ],
                          ),
                        ),
                      ),
                      elevation: 20,
                    )
                    .closed
                    .then((value) {
                  cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  // isBottomSheetShown = false;
                  // //
                  // // setState(() {
                  // //   fabIcon = Icons.edit;
                  // // });
                });

                cubit.changeBottomSheetState(isShow: true, icon: Icons.add);

                //  isBottomSheetShown = true;
                // setState(() {
                //   fabIcon = Icons.add;
                // });
              }

              //  async
              //  {
              //    try {
              //      throw('some error');
              //    }
              //    catch (error)
              //    {
              //      print('error ${error.toString()}');
              //    }
              //    var name = await getName();
              // print (name);
              // print ('osama');
              //    getName().then((value){
              //      print(value);
              //      print ('osama');
              //
              //      throw('some error!!!');
              //    }).catchError((error) {
              //      print('error ${error.toString()}');
              //    });
            },
            child: Icon(cubit.fabIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            elevation: 15,
            onTap: (index) {
              cubit.changeIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.assignment_outlined,
                ),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline), label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive), label: 'Archived'),
            ],
          ),
        );
      }),
    );
  }
}
