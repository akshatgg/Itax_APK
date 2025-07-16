import '../../../../../core/data/apis/models/party/party_model.dart';

/* 
'Amount (High-Low)',
'Amount (Low-High)',
'Most recent',
'By Name (A-Z)',
'By Name (Z-A)'
 */
List<PartyModel> sortParties(List<PartyModel> parties, int selectedType) {
  var partiesCopy = List<PartyModel>.from(parties);
  switch (selectedType) {
    case 0:
      partiesCopy
          .sort((a, b) => a.outstandingBalance > b.outstandingBalance ? -1 : 1);
      break;
    case 1:
      partiesCopy
          .sort((a, b) => a.outstandingBalance < b.outstandingBalance ? -1 : 1);
      break;
    case 2:
      partiesCopy.sort((a, b) => a.createdAt.isAfter(b.createdAt) ? -1 : 1);
      break;
    case 3:
      partiesCopy.sort((a, b) =>
          a.partyName.toLowerCase().compareTo(b.partyName.toLowerCase()));
      break;
    case 4:
      partiesCopy.sort((a, b) =>
          b.partyName.toLowerCase().compareTo(a.partyName.toLowerCase()));
      break;
  }

  return partiesCopy;
}
