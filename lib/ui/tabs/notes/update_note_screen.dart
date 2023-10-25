import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Provider/auth_provider.dart';
import 'package:todo/database/models/task.dart';
import 'package:todo/database/task_dao.dart';
import 'package:todo/ui/re_use_widgets/dialogs.dart';

import '../../re_use_widgets/cusom_text_field.dart';

class UpdateNoteScreen extends StatefulWidget {
  static const String route = "updateNote";

  UpdateNoteScreen({super.key});

  @override
  State<UpdateNoteScreen> createState() => _UpdateNoteScreenState();
}

class _UpdateNoteScreenState extends State<UpdateNoteScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  Task? task;

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      task = ModalRoute.of(context)?.settings.arguments as Task;
      title.text = task!.title!;
      content.text = task!.content!;
      selectedDate = DateTime.fromMillisecondsSinceEpoch(
          task!.date?.millisecondsSinceEpoch ?? 0);
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewInsets.top + 100,
              left: 45,
              right: 45,
              bottom: MediaQuery.of(context).viewInsets.bottom + 50),
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.onBackground),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Update Task',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  hint: 'enter your task title',
                  control: title,
                  maxline: 2,
                  minline: 1,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(height: 2),
                  textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 20,
                        height: 2,
                      ),
                  withBoarder: true,
                  check: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Please enter task title';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  hint: 'enter your task details',
                  control: content,
                  maxline: 10,
                  minline: 1,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontSize: 15, height: 2),
                  textStyle: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(height: 2),
                  withBoarder: true,
                  check: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Please enter task content';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () {
                    showTaskDate();
                  },
                  child: Text(
                    'Select date',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                SizedBox(
                  height: showDateError ? 0 : 15,
                ),
                Visibility(
                  visible: showDateError,
                  child: Text(
                    'please enter date',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      fontFamily: '',
                    ),
                  ),
                ),
                Text(
                  selectedDate == null
                      ? ''
                      : '${selectedDate?.day} / ${selectedDate?.month} / ${selectedDate?.year}',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: TextButton(
                    onPressed: () async {
                      var authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      var finalDate = Timestamp.fromMillisecondsSinceEpoch(
                          selectedDate?.millisecondsSinceEpoch ?? 0);
                      if (content.text == task!.content &&
                          title.text == task!.title &&
                          finalDate == task!.date) {
                        print('no changes');
                        return;
                      }
                      task!.title = title.text;
                      task!.content = content.text;
                      task!.date = finalDate;
                      try {
                        Dialogs.showLoadingDialog(context, 'Add Task...',
                            isCanceled: false);
                        await TasksDao.updateTask(authProvider.user?.id,
                            task!.id, task!.toFireStore());
                        Dialogs.closeMessageDialog(context);
                        Dialogs.showMessageDialog(
                          context,
                          'Task added successfully',
                          isClosed: false,
                          positiveActionText: 'Ok',
                          positiveAction: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.check_circle_sharp,
                            color: Colors.green,
                            size: 30,
                          ),
                        );
                      } catch (e) {
                        Dialogs.closeMessageDialog(context);
                        Dialogs.showMessageDialog(
                            context, 'some thing went wrong',
                            icon: Icon(
                              Icons.error,
                              color: Colors.red,
                            ));
                      }
                    },
                    child: Text(
                      'Ubdate Task',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime? selectedDate;

  bool showDateError = false;

  void showTaskDate() async {
    var date = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(
          Duration(days: 365),
        ));
    selectedDate = date;
    setState(() {
      selectedDate = date;
      if (selectedDate != null) {
        showDateError = false;
      }
    });
  }

  bool validation() {
    if (formKey.currentState!.validate() && selectedDate != null) {
      return true;
    }
    setState(() {
      if (selectedDate == null) {
        showDateError = true;
      }
    });
    return false;
  }
}
