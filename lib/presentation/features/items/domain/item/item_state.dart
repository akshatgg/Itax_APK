part of 'item_bloc.dart';

class ItemState extends Equatable {
  final List<ItemModel> items;

  const ItemState({
    this.items = const [],
  });

  @override
  List<Object> get props => [items];
}

final class ItemInitial extends ItemState {}

class ProcessLoading extends ItemState {}

class ItemsList extends ItemState {
  const ItemsList({
    super.items = const [],
  });
}

class ItemOperationFailed extends ItemState {
  final String reason;

  const ItemOperationFailed({
    this.reason = '',
  });

  @override
  List<Object> get props => [super.items, reason];
}

class ItemOperationSuccess extends ItemState {
  final String message;

  const ItemOperationSuccess({this.message = ''});
}

class ItemStockUpdateSuccess extends ItemState {
  final String message;

  const ItemStockUpdateSuccess({this.message = ''});
}

class ItemStockUpdateFailed extends ItemState {
  final String reason;

  const ItemStockUpdateFailed({
    this.reason = '',
  });

  @override
  List<Object> get props => [super.items, reason];
}

class ItemDeleteOperationSuccess extends ItemState {}

class ItemDeleteOperationFailed extends ItemState {
  final String reason;

  const ItemDeleteOperationFailed({
    this.reason = '',
  });

  @override
  List<Object> get props => [super.items, reason];
}
