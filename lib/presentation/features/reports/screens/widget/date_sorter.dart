import '../../../../../core/data/apis/models/invoice/invoice_model.dart';
import '../../../../../core/data/apis/models/items/item_model.dart';
import '../../../../../core/data/apis/models/party/party_model.dart';
import '../../../../../core/utils/logger.dart';

List<PartyModel> sortDate(List<PartyModel> parties, int selectedType) {
  var partiesCopy = List<PartyModel>.from(parties);
  DateTime today = DateTime.now();

  if (selectedType == 0) {
    return partiesCopy; // Show all parties
  }

  partiesCopy = partiesCopy.where((party) {
    if (party.invoices.isEmpty) return false;

    // Filter valid dates
    var validInvoices = party.invoices
        .map((invoice) => DateTime.parse(invoice.invoiceDate.toString()))
        .toList();

    if (validInvoices.isEmpty) return false; // No valid dates

    // Find latest invoice date
    DateTime lastSaleDate =
        validInvoices.reduce((a, b) => a.isAfter(b) ? a : b);

    switch (selectedType) {
      case 1: // Inactive between 30 to 60 days
        return lastSaleDate.isAfter(today.subtract(const Duration(days: 60))) &&
            lastSaleDate.isBefore(today.subtract(const Duration(days: 30)));
      case 2: // Inactive between 60 to 120 days
        return lastSaleDate
                .isAfter(today.subtract(const Duration(days: 120))) &&
            lastSaleDate.isBefore(today.subtract(const Duration(days: 60)));
      case 3: // Inactive between 120 to 180 days
        return lastSaleDate
                .isAfter(today.subtract(const Duration(days: 180))) &&
            lastSaleDate.isBefore(today.subtract(const Duration(days: 120)));
      case 4: // Inactive between 180 to 365 days
        return lastSaleDate
                .isAfter(today.subtract(const Duration(days: 365))) &&
            lastSaleDate.isBefore(today.subtract(const Duration(days: 180)));
      case 5: // Inactive for 365+ days
        return lastSaleDate.isBefore(today.subtract(const Duration(days: 365)));
      default:
        return false;
    }
  }).toList();

  return partiesCopy;
}

List<ItemModel> sortItemByInvoiceDate(
    List<ItemModel> items, List<InvoiceModel> invoices, int selectedType) {
  DateTime today = DateTime.now();

  // Step 1: Map each item's latest invoice date
  Map<String, DateTime> latestInvoiceDates = {};

  for (var invoice in invoices) {
    for (var invoiceItem in invoice.invoiceItems) {
      String itemId = invoiceItem.itemId.toString();
      DateTime invoiceDate = invoice.invoiceDate;

      if (!latestInvoiceDates.containsKey(itemId) ||
          invoiceDate.isAfter(latestInvoiceDates[itemId]!)) {
        latestInvoiceDates[itemId] = invoiceDate;
      }
    }
  }

  // Step 2: Filter items based on the last invoice date
  List<ItemModel> sortedItems = items.where((item) {
    String itemId = item.id;
    DateTime? lastSaleDate = latestInvoiceDates[itemId];

    if (selectedType == 0) {
      // Show items that haven't been invoiced in the last 30 days
      return lastSaleDate == null ||
          lastSaleDate.isBefore(today.subtract(const Duration(days: 0)));
    }

    if (lastSaleDate == null) {
      return false; // Skip items never sold for other cases
    }

    switch (selectedType) {
      case 1: // Inactive between 30 to 60 days
        return lastSaleDate.isAfter(today.subtract(const Duration(days: 60))) &&
            lastSaleDate.isBefore(today.subtract(const Duration(days: 30)));
      case 2: // Inactive between 60 to 120 days
        return lastSaleDate
                .isAfter(today.subtract(const Duration(days: 120))) &&
            lastSaleDate.isBefore(today.subtract(const Duration(days: 60)));
      case 3: // Inactive between 120 to 180 days
        return lastSaleDate
                .isAfter(today.subtract(const Duration(days: 180))) &&
            lastSaleDate.isBefore(today.subtract(const Duration(days: 120)));
      case 4: // Inactive between 180 to 365 days
        return lastSaleDate
                .isAfter(today.subtract(const Duration(days: 365))) &&
            lastSaleDate.isBefore(today.subtract(const Duration(days: 180)));
      case 5: // Inactive for 365+ days
        return lastSaleDate.isBefore(today.subtract(const Duration(days: 365)));
      default:
        return false;
    }
  }).toList();
  logger.d(sortedItems);
  return sortedItems;
}
