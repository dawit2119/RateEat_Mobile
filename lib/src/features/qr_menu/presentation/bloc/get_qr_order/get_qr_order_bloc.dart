import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class GetQROrderBloc extends Bloc<GetQROrderEvent, GetQROrderState> {
  final GetQROrderUsecase qrOrderUsecase;

  GetQROrderBloc({required this.qrOrderUsecase}) : super(GetQROrderInitial()) {
    on<GetQROrder>(
      (event, emit) async {
        emit(const GetQROrderLoading());
        final res = await qrOrderUsecase(event.orderId);
        res.fold((l) => emit(GetQROrderFailure(message: l.errorMessage)),
            (data) => emit(GetQROrderSuccess(qrOrder: data)));
      },
    );
  }
}
