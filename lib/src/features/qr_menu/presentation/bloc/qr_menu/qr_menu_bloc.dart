import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class QRMenuBloc extends Bloc<QRMenuEvent, QRMenuState> {
  final int limit = 6;
  final GetQRMenuUsecase getQrMenuUsecase;
  QRMenuBloc({required this.getQrMenuUsecase})
      : super(QRMenuInitial(
          sortBy: "popularity",
          sortType: "Desc",
          minPrice: null,
          maxPrice: null,
          minRating: null,
        )) {
    on<GetQRMenu>((event, emit) async {
      QRMenuModel? prevMenu =
          (state is QRMenuLoaded) ? (state as QRMenuLoaded).menu : null;

      if (prevMenu == null ||
          event.restaurantId != (state as QRMenuLoaded).menu.restaurantId ||
          event.page == 1) {
        emit(QRMenuLoading(
          menu: prevMenu,
          sortBy: event.sortBy,
          sortType: event.sortType,
          minPrice: event.minPrice,
          maxPrice: event.maxPrice,
          minRating: event.minRating,
        ));
      } else if (event.page != 1) {
        emit(QRMenuNextLoading(
          menu: prevMenu,
          sortBy: event.sortBy,
          sortType: event.sortType,
          minPrice: event.minPrice,
          maxPrice: event.maxPrice,
          minRating: event.minRating,
        ));
      }
      final res = await getQrMenuUsecase(GetQRMenuUseCaseParams(
        //this is set to null to do the category filtering on the frontend
        category: null,
        restaurantid: event.restaurantId,
        page: event.page,
        isFasting: event.isFasting,
        limit: limit,
        query: event.query,
        sortBy: event.sortBy,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        minRating: event.minRating,
        sortType: event.sortType,
      ));
      if (event.page == 1) {
        prevMenu = null;
      }
      res.fold((error) {
        if (event.page == 1 || prevMenu == null) {
          emit(
            QRMenuFailed(
              minPrice: event.minPrice,
              maxPrice: event.maxPrice,
              minRating: event.minRating,
              sortBy: event.sortBy,
              sortType: event.sortType,
            ),
          );
        } else {
          emit(
            QRMenuLoaded(
              menu: prevMenu,
              page: event.page - 1,
              hasReachedMax: false,
              sortBy: event.sortBy,
              sortType: event.sortType,
              minPrice: event.minPrice,
              maxPrice: event.maxPrice,
              minRating: event.minRating,
            ),
          );
        }
      }, (newMenu) {
        if (event.category != null) {
          emit(QRMenuLoaded(
            menu: prevMenu?.copyWith(
                    items: newMenu.items, categories: newMenu.categories) ??
                newMenu as QRMenuModel,
            page: event.page,
            hasReachedMax: newMenu.categories.length != newMenu.totalCategories,
            sortBy: event.sortBy,
            sortType: event.sortType,
            minPrice: event.minPrice,
            maxPrice: event.maxPrice,
            minRating: event.minRating,
          ));
        } else {
          if (event.page == 1) {
            emit(QRMenuLoaded(
              menu: newMenu as QRMenuModel,
              page: event.page,
              hasReachedMax: newMenu.categories.isEmpty,
              sortBy: event.sortBy,
              sortType: event.sortType,
              minPrice: event.minPrice,
              maxPrice: event.maxPrice,
              minRating: event.minRating,
            ));
          } else {
            emit(QRMenuLoaded(
              menu: prevMenu?.copyWith(items: {
                    ...prevMenu.items,
                    ...newMenu.items
                  }, categories: [
                    ...prevMenu.categories,
                    ...newMenu.categories
                  ]) ??
                  newMenu as QRMenuModel,
              page: event.page,
              hasReachedMax: newMenu.categories.isEmpty,
              sortBy: event.sortBy,
              sortType: event.sortType,
              minPrice: event.minPrice,
              maxPrice: event.maxPrice,
              minRating: event.minRating,
            ));
          }
        }
      });
    });
  }
}
