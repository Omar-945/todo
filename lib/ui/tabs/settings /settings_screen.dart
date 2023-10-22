import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/Provider/settings_provider.dart';

class Settings extends StatefulWidget {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    String? selectedLang = Provider.of<SettingsProvider>(context).lang;
    String? selectedTheme = Provider.of<SettingsProvider>(context).theme;
    List<DropdownMenuItem<String>> dropDownItemsLang = [
      DropdownMenuItem(
        value: 'English',
        child: Text(
          AppLocalizations.of(context)!.english,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: 14, color: Theme.of(context).colorScheme.primary),
        ),
      ),
      DropdownMenuItem(
        value: 'Arabic',
        child: Text(
          AppLocalizations.of(context)!.arabic,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: 14, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    ];
    List<DropdownMenuItem<String>> dropDownItemsThemes = [
      DropdownMenuItem(
        value: 'light',
        child: Text(
          AppLocalizations.of(context)!.light,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: 14, color: Theme.of(context).colorScheme.primary),
        ),
      ),
      DropdownMenuItem(
        value: 'dark',
        child: Text(
          AppLocalizations.of(context)!.dark,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: 14, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsetsDirectional.only(top: 60, start: 20),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * .23,
          color: Theme.of(context).colorScheme.primary,
          child: Text(
            AppLocalizations.of(context)!.settings,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontSize: 27),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 37),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.lang,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 14),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsetsDirectional.only(start: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                    border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.primary)),
                child: DropdownButton(
                  items: dropDownItemsLang,
                  underline: Container(),
                  dropdownColor: Theme.of(context).colorScheme.onBackground,
                  iconEnabledColor: Theme.of(context).colorScheme.primary,
                  value: selectedLang,
                  onChanged: (select) {
                    var settingProvider =
                        Provider.of<SettingsProvider>(context, listen: false);
                    settingProvider.changeLang(select);
                  },
                  isExpanded: true,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.theme,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 14),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsetsDirectional.only(start: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                    border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.primary)),
                child: DropdownButton(
                  items: dropDownItemsThemes,
                  underline: Container(),
                  dropdownColor: Theme.of(context).colorScheme.onBackground,
                  iconEnabledColor: Theme.of(context).colorScheme.primary,
                  value: selectedTheme,
                  onChanged: (select) {
                    var settingProvider =
                        Provider.of<SettingsProvider>(context, listen: false);
                    if (select == 'light') {
                      settingProvider.changeThemes(ThemeMode.light);
                    } else {
                      settingProvider.changeThemes(ThemeMode.dark);
                    }
                    ;
                  },
                  isExpanded: true,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
