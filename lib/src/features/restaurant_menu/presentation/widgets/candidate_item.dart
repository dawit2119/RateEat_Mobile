import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../features.dart';
import './add_candidate_item.dart';
import './add_candidate_item_review.dart';

class CandidateItem extends StatefulWidget {
  const CandidateItem({
    super.key,
    required this.restaurant,
    required this.categories,
    required this.menuId,
  });
  final Restaurant restaurant;
  final List<String> categories;
  final String menuId;
  @override
  State<CandidateItem> createState() => _CandidateItemState();
}

class _CandidateItemState extends State<CandidateItem> {
  late PageController candidateItemPageController;

  @override
  void initState() {
    candidateItemPageController = PageController(
      initialPage: context.read<CandidateItemCubit>().state,
    );
    super.initState();
  }

  @override
  void dispose() {
    context.read<CandidateItemCubit>().changeIndex(0);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CandidateItemCubit, int>(
      listener: (context, state) {
        candidateItemPageController.jumpToPage(
          state,
        );
      },
      child: Container(
        color: Colors.white,
        height: 80.h,
        width: 100.w,
        padding: EdgeInsets.only(
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 15,
          right: 15,
        ),
        child: PageView.builder(
          itemCount: 2,
          controller: candidateItemPageController,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => [
            AddCandidateItem(
              restaurant: widget.restaurant,
              categories: widget.categories,
              menuId: widget.menuId,
            ),
            const AddCandidateItemReviewPage(),
          ].elementAt(index),
        ),
      ),
    );
  }
}

class CandidateItemCubit extends Cubit<int> {
  CandidateItemCubit() : super(0);

  changeIndex(int index) => emit(index);
  resetIndex() => emit(0);
}
