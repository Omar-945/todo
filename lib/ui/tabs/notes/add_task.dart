import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/Provider/auth_provider.dart';
import 'package:todo/database/models/task.dart';
import 'package:todo/database/task_dao.dart';
import 'package:todo/ui/re_use_widgets/cusom_text_field.dart';

import '../../re_use_widgets/dialogs.dart';

class AddTask extends StatefulWidget {
  AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            top: 25,
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
                AppLocalizations.of(context)!.add_task,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextField(
                hint: AppLocalizations.of(context)!.task_title,
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
                    return AppLocalizations.of(context)!.error_title;
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextField(
                hint: AppLocalizations.of(context)!.task_content,
                control: content,
                maxline: 4,
                minline: 1,
                hintStyle: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontSize: 15, height: 2),
                textStyle:
                    Theme.of(context).textTheme.labelSmall?.copyWith(height: 2),
                withBoarder: true,
                check: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return AppLocalizations.of(context)!.error_details;
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
                  AppLocalizations.of(context)!.selected_date,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              SizedBox(
                height: showDateError ? 0 : 15,
              ),
              Visibility(
                visible: showDateError,
                child: Text(
                  AppLocalizations.of(context)!.error_date,
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
                  onPressed: () {
                    addTask();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.add_task_button,
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

  void addTask() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!validation()) {
      return;
    }
    Task task = Task(
        title: title.text,
        content: content.text,
        date: Timestamp.fromMillisecondsSinceEpoch(
            selectedDate!.millisecondsSinceEpoch));
    try {
      Dialogs.showLoadingDialog(context, 'Add Task...', isCanceled: false);
      await TasksDao.addTask(task, authProvider.user!.id!);
      Dialogs.closeMessageDialog(context);
      Dialogs.showMessageDialog(
        context,
        AppLocalizations.of(context)!.task_success,
        isClosed: false,
        positiveActionText: AppLocalizations.of(context)!.ok,
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
      Dialogs.showMessageDialog(context, 'some thing went wrong',
          icon: Icon(
            Icons.error,
            color: Colors.red,
          ));
    }
  }
}
