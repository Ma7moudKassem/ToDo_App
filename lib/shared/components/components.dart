import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget buildTaskItem(Map model, context) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Dismissible(
        key: Key(model['id'].toString()),
        onDismissed: (direction) {
          AppCubit.get(context).deleteDatabase(id: model['id']);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.deepOrange,
                radius: 40,
                child: Text(
                  '${model['time']} ',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['title']}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${model['date']}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              IconButton(
                  onPressed: () {
                    AppCubit.get(context).updateDatabase(
                      status: 'done',
                      id: model['id'],
                    );
                  },
                  icon: Icon(
                    Icons.done,
                    color: Colors.deepOrange,
                  )),
              IconButton(
                  onPressed: () {
                    AppCubit.get(context).updateDatabase(
                      status: 'archive',
                      id: model['id'],
                    );
                  },
                  icon: Icon(
                    Icons.archive,
                    color: Colors.black45,
                  ))
            ],
          ),
        ),
      ),
    );

Widget defaultTextFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  @required IconData prefix,
  @required String lapelText,
  Function onSubmitted,
  Function onChanged,
  Function onTap,
  @required Function validate,
  bool isPassword = false,
  IconData suffix,
  Function suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
      obscureText: isPassword,
      validator: validate,
      keyboardType: type,
      onTap: onTap,
      decoration: InputDecoration(
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(suffix),
              )
            : null,
        labelText: lapelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

Widget tasksBuilder({
  @required List<Map> tasks,
}) =>
    ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => myDivider(),
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/em.png')),
            Text(
              'No Tasks Yet, Please Add Some Tasks ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            )
          ],
        ),
      ),
    );

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 30),
      child: Container(
        width: double.infinity,
        color: Colors.grey[300],
        height: 1,
      ),
    );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
