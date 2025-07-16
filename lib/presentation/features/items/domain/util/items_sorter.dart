import '../../../../../core/data/apis/models/items/item_model.dart';

/* 
'Amount (High-Low)',
'Amount (Low-High)',
'Most recent',
'By Name (A-Z)',
'By Name (Z-A)'
 */
List<ItemModel> sortItems(List<ItemModel> parties, int selectedType) {
  var partiesCopy = List<ItemModel>.from(parties);
  switch (selectedType) {
    case 0:
      partiesCopy.sort((a, b) => a.closingStock > b.closingStock ? -1 : 1);
      break;
    case 1:
      partiesCopy.sort((a, b) => a.closingStock < b.closingStock ? -1 : 1);
      break;
    case 2:
      partiesCopy.sort((a, b) => a.createdAt.isAfter(b.createdAt) ? -1 : 1);
      break;
    case 3:
      partiesCopy.sort((a, b) =>
          a.itemName.toLowerCase().compareTo(b.itemName.toLowerCase()));
      break;
    case 4:
      partiesCopy.sort((a, b) =>
          b.itemName.toLowerCase().compareTo(a.itemName.toLowerCase()));
      break;
  }

  return partiesCopy;
}
