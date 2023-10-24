import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/Provider/auth_provider.dart';
import 'package:todo/Provider/settings_provider.dart';
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
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          fit: StackFit.passthrough,
          children: [
            Container(
              padding: EdgeInsetsDirectional.only(top: 31, start: 20),
              width: MediaQuery.of(context).size.width,
              height: 215.0,
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.todo,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Expanded(
                        child: SizedBox(
                      width: double.infinity,
                    )),
                    TextButton(
                      onPressed: () {
                        authProvider.signOut(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.sign_out,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 17),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 40,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            EasyDateTimeLine(
              locale: Provider.of<SettingsProvider>(context).local,
              headerProps: EasyHeaderProps(showHeader: false),
              initialDate: DateTime.now(),
              dayProps: EasyDayProps(
                  todayStyle: DayStyle(
                      borderRadius: 0, decoration: BoxDecoration(border: null)),
                  activeDayStyle: DayStyle(
                      dayNumStyle:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                      monthStrStyle: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              fontSize: 11),
                      dayStrStyle: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              fontSize: 11),
                      borderRadius: 0,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onBackground)),
                  inactiveDayStyle: DayStyle(
                      borderRadius: 0,
                      decoration: BoxDecoration(color: Colors.transparent))),
              onDateChange: (date) {
                setState(() {
                  TasksDao.date = date;
                });
              },
            )
          ],
        ),
        Expanded(
          flex: 5,
          child: Container(
            margin: EdgeInsets.only(left: 35, right: 35, top: 45),
            child: Column(
              children: [
                Expanded(
                    child: StreamBuilder(
                  stream: TasksDao.isFirst
                      ? TasksDao.getTasks(authProvider.user?.id ?? "")
                      : TasksDao.getSearchTasks(authProvider.user?.id ?? ""),
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
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        height: 10,
                      ),
                      itemCount: tasks?.length ?? 0,
                    );
                  },
                ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showNote(String? title, String? text) {
    showModalBottomSheet(
        context: context,
        builder: (content) => ShowNote(title: title!, content: text!),
        isScrollControlled: true);
  }
}
