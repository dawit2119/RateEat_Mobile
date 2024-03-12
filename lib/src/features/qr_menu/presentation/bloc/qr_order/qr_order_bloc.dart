import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/qr_menu/domain/usecases/create_qr_order_usecase.dart';

class QROrderBloc extends Bloc<QROrderEvent, QROrderState> {
  Map<QRItem, int> items = {};
  final CreateQROrderUsecase createQROrderUsecase;

  QROrderBloc({required this.createQROrderUsecase}) : super(QROrderInitial()) {
    on<AddItemToCart>((event, emit) {
      addItem(event.item);
      emit(QRItemsInCart(items: items));
    });
    on<RemoveItemFromCart>((event, emit) {
      removeItem(event.item);
      emit(QRItemsInCart(items: items));
    });
    on<ClearCart>((event, emit) {
      items.clear();
      emit(QROrderInitial());
    });
    on<GetItemsInCart>((event, emit) {
      emit(QRItemsInCart(items: items));
    });
    on<CreateQROrder>((event, emit) async {
      emit(CreateQROrderLoading(items: items));
      final result = await createQROrderUsecase(
        CreateQROrderParams(
          restaurantId: event.restaurantId,
          items: event.items,
          orderNote: event.orderNote,
          location: event.location,
          orderType: event.orderType,
        ),
      );
      result.fold(
        (failure) => emit(CreateQROrderFailure(
            errorMessage: failure.errorMessage, items: items)),
        (data) => emit(CreateQROrderSuccess(items: items, qrOrder: data)),
      );
    });
  }

  bool isItemInOrder(QRItem item) {
    return items.containsKey(item);
  }

  int getItemCount(QRItem item) {
    return items[item] ?? 0;
  }

  void addItem(QRItem item) {
    if (items.containsKey(item)) {
      items[item] = items[item]! + 1;
    } else {
      items[item] = 1;
    }
  }

  void removeItem(QRItem item) {
    if (items.containsKey(item)) {
      if (items[item]! > 1) {
        items[item] = items[item]! - 1;
      } else {
        items.remove(item);
      }
    }
  }

  double calculateTotalPrice() {
    if (items.isEmpty) return 0.0;
    return items.entries
        .map((entry) => (entry.key.price) * entry.value)
        .reduce(
          (value, element) => value + element,
        )
        .toDouble();
  }
}
