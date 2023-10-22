import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Provider/auth_provider.dart';
import 'package:todo/database/task_dao.dart';
import 'package:todo/ui/tabs/notes/show_note.dart';

import '../../../database/models/task.dart';
import '../../re_use_widgets/dialogs.dart';
import 'note_container.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: TasksDao.getTasks(authProvider.user?.id ?? ''),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Dialogs.showMessageDialog(
                    context, 'SomeThing went wrong !',
                    icon: Icon(
                      Icons.error,
                      color: Colors.red,
                    ));
              }
              List<Task>? tasks = snapshot.data;
              return ListView.separated(
                itemBuilder: (context, index) {
                  return NoteContainer(
                    task: tasks?[index],
                    show: showNote,
                  );
                },
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: 10,
                ),
                itemCount: tasks?.length ?? 0,
              );
            },
          ))
        ],
      ),
    );
  }

  void showNote(String? title, String? text) {
    showModalBottomSheet(
        context: context,
        builder: (content) => ShowNote(title: title!, content: text!),
        isScrollControlled: true);
  }
}
