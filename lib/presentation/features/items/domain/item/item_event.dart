part of 'item_bloc.dart';

sealed class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object> get props => [];
}

class OnGetItem extends ItemEvent {
  const OnGetItem();
}

class OnItemLoaded extends ItemEvent {}

class OnAddItem extends ItemEvent {
  final ItemModel itemModel;
  final File? image;

  const OnAddItem({
    required this.itemModel,
    this.image,
  });
}

class OnDeleteItem extends ItemEvent {
  final ItemModel itemModel;

  const OnDeleteItem({
    required this.itemModel,
  });
}

class OnUpdateItem extends ItemEvent {
  final ItemModel itemModel;
  final File? image;

  const OnUpdateItem({
    required this.itemModel,
    this.image,
  });
}

class OnStockUpdateItem extends ItemEvent {
  final ItemModel itemModel;

  const OnStockUpdateItem({
    required this.itemModel,
  });
}
