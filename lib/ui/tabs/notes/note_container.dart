import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/Provider/auth_provider.dart';
import 'package:todo/database/models/task.dart';
import 'package:todo/database/task_dao.dart';
import 'package:todo/ui/tabs/notes/update_note_screen.dart';

import '../../re_use_widgets/dialogs.dart';

typedef showTask = void Function(String? title, String? content);

class NoteContainer extends StatefulWidget {
  Task? task;
  showTask? show;

  NoteContainer({super.key, this.task, this.show});

  @override
  State<NoteContainer> createState() => _NoteContainerState();
}

class _NoteContainerState extends State<NoteContainer> {
  CrossFadeState crossFadeState = CrossFadeState.showFirst;
  Color titleColor = Color(0xFF82B1FF);

  @override
  Widget build(BuildContext context) {
    var dateOfTask = DateTime.fromMillisecondsSinceEpoch(
        widget.task?.date?.millisecondsSinceEpoch ?? 0);
    return InkWell(
      onTap: () {
        widget.show?.call(widget.task?.title, widget.task?.content);
      },
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (sliderContext) {
                var authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                Dialogs.showMessageDialog(
                    context, AppLocalizations.of(context)!.task_delete,
                    icon: Icon(
                      Icons.warning,
                      color: Colors.yellow[800],
                    ),
                    positiveActionText: AppLocalizations.of(context)!.yes,
                    positiveAction: () {
                      TasksDao.deleteTask(
                          authProvider.user?.id, widget.task?.id);
                    },
                    negativeActionText: AppLocalizations.of(context)!.no,
                    negativeAction: () {
                      Navigator.pop(context);
                    });
              },
              icon: Icons.delete,
              backgroundColor: Colors.red,
              label: AppLocalizations.of(context)!.delete,
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              foregroundColor: Colors.white,
              onPressed: (slidableContext) {
                Navigator.pushNamed(context, UpdateNoteScreen.route,
                    arguments: widget.task);
              },
              icon: Icons.edit,
              backgroundColor: Color(0xFF0daec7),
              label: AppLocalizations.of(context)!.edit,
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),
        child: Container(
          width: 352,
          height: 140,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: titleColor, borderRadius: BorderRadius.circular(10)),
                width: 4,
                height: double.infinity,
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.task?.title ?? '',
                      style: TextStyle(color: titleColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      widget.task?.content ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 13),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 20,
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${dateOfTask.day} / ${dateOfTask.month} / ${dateOfTask.year}',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              AnimatedCrossFade(
                  firstChild: widget.task!.isDone!
                      ? Text(
                          AppLocalizations.of(context)!.done,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                        )
                      : InkWell(
                          onTap: () {
                            var authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);
                            Future.delayed(Duration(milliseconds: 200),
                                () async {
                              await TasksDao.updateTask(authProvider.user?.id,
                                  widget.task?.id, {'isdone': true});
                            });
                            setState(() {
                              crossFadeState = CrossFadeState.showSecond;
                              titleColor =
                                  Theme.of(context).colorScheme.onSecondary;
                            });
                          },
                          child: Container(
                            width: 69,
                            height: 34,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).colorScheme.primary),
                            child: Icon(
                              Icons.check,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  secondChild: Text(
                    AppLocalizations.of(context)!.done,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                  crossFadeState: crossFadeState,
                  duration: Duration(milliseconds: 400))
            ],
          ),
        ),
      ),
    );
  }
}
