import 'package:extended_wrap/extended_wrap.dart';
import 'package:flutter/material.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';

import 'category_type_buttons.dart';

class ItemCategories extends StatefulWidget {
  const ItemCategories({super.key});

  @override
  State<ItemCategories> createState() => _ItemCategoriesState();
}

class _ItemCategoriesState extends State<ItemCategories> {
  bool isFasting = false;
  int categoryLines = 1;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.categoriesText,
              style: TextStyle(
                  fontSize: screenHeight * 0.026, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.fastingText,
                  style: TextStyle(fontSize: screenHeight * 0.023),
                ),
                Switch(
                    value: isFasting,
                    activeColor: const Color(0xFFFF3008),
                    activeTrackColor: Colors.deepOrange[50],
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey[300],
                    trackOutlineColor:
                        const WidgetStatePropertyAll(Colors.white),
                    onChanged: (bool value) {
                      setState(() {
                        isFasting = value;
                      });
                    })
              ],
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: screenWidth * 0.75,
              child: ExtendedWrap(
                maxLines: categoryLines,
                children: [
                  CategoryTypeButton(
                      itemType: AppLocalizations.of(context)!.westernText),
                  CategoryTypeButton(
                      itemType: AppLocalizations.of(context)!.middleEastText),
                  CategoryTypeButton(
                      itemType: AppLocalizations.of(context)!.habeshanText),
                  CategoryTypeButton(
                      itemType: AppLocalizations.of(context)!.europeanText),
                  CategoryTypeButton(
                      itemType:
                          AppLocalizations.of(context)!.mediterraneanText),
                  CategoryTypeButton(
                    itemType: AppLocalizations.of(context)!.asianText,
                  )
                ],
              ),
            ),
            SizedBox(
              width: screenWidth * 0.05,
              child: IconButton(
                  onPressed: () {
                    if (categoryLines == 1) {
                      setState(() {
                        categoryLines = 3;
                      });
                    } else {
                      setState(() {
                        categoryLines = 1;
                      });
                    }
                  },
                  icon: (categoryLines == 1)
                      ? const Icon(Icons.keyboard_arrow_down)
                      : const Icon(Icons.keyboard_arrow_up)),
            )
          ],
        ),
      ],
    );
  }
}
