import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/language/language_bloc.dart';
import 'package:rateeat_mobile/src/core/language/language.dart';
import 'package:rateeat_mobile/src/core/language/language_event.dart';
import 'package:rateeat_mobile/src/core/language/language_state.dart';

class LanguagesPage extends StatelessWidget {
  const LanguagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
          onTap: () {
            context.pop();
          },
          title: AppLocalizations.of(context)!.langText),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<LanguageBloc, LanguageState>(
                  builder: (context, state) {
                return ListView.separated(
                  itemCount: Language.values.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        //* Save to local Storage
                        final languageState = Hive.box<String>('language');
                        languageState.put(0, Language.values[index].text);
                        //* Trigger the ChangeLanguage event
                        context.read<LanguageBloc>().add(
                              ChangeLanguage(
                                selectedLanguage: Language.values[index],
                              ),
                            );
                      },
                      title: Text(Language.values[index].text),
                      trailing: Language.values[index] == state.selectedLanguage
                          ? const Icon(Icons.check_circle_rounded,
                              color: AppColors.primaryColor)
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: Language.values[index] == state.selectedLanguage
                            ? const BorderSide(
                                color: AppColors.primaryColor, width: 1.5)
                            : BorderSide(color: Colors.grey[300]!),
                      ),
                      tileColor:
                          Language.values[index] == state.selectedLanguage
                              ? AppColors.primaryColor.withOpacity(0.05)
                              : null,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: screenHeight * 0.02);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
