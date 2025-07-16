import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../presentation/features/reports/data/day_book.dart';
import '../../../../presentation/features/reports/data/day_book_invoice.dart';
import '../../../constants/enums/invoice_status.dart';
import '../../../constants/enums/invoice_type.dart';
import '../../../constants/enums/item_type.dart';
import '../../../constants/enums/item_unit.dart';
import '../../../constants/enums/party_type.dart';
import '../../../utils/logger.dart';
import '../../apis/models/company/company_model.dart';
import '../../apis/models/dashboard/dashboard_data_model.dart';
import '../../apis/models/invoice/invoice_item_model.dart';
import '../../apis/models/invoice/invoice_model.dart';
import '../../apis/models/invoice/notes_model.dart';
import '../../apis/models/invoice/receipt_model.dart';
import '../../apis/models/items/item_model.dart';
import '../../apis/models/party/party_model.dart';
import '../../apis/models/shared/file_metadata.dart';
import '../../apis/models/shared/user_model.dart';

class HiveStorageService {
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    logger.d('path = ${dir.path}');
    Hive.init(dir.path);

    Hive.registerAdapter<ItemType>(ItemTypeAdapter());
    Hive.registerAdapter<ItemUnit>(ItemUnitAdapter());
    Hive.registerAdapter<ItemModel>(ItemModelAdapter());
    Hive.registerAdapter<PartyType>(PartyTypeAdapter());
    Hive.registerAdapter<PartyModel>(PartyModelAdapter());
    Hive.registerAdapter<UserModel>(UserModelAdapter());
    Hive.registerAdapter<InvoiceItemModel>(InvoiceItemModelAdapter());
    Hive.registerAdapter<InvoiceModel>(InvoiceModelAdapter());
    Hive.registerAdapter<InvoiceType>(InvoiceTypeAdapter());
    Hive.registerAdapter<InvoiceStatus>(InvoiceStatusAdapter());
    Hive.registerAdapter<DayBook>(DayBookAdapter());
    Hive.registerAdapter<DayBookInvoice>(DayBookInvoiceAdapter());
    Hive.registerAdapter<ReceiptModel>(ReceiptModelAdapter());
    Hive.registerAdapter<NotesModel>(NotesModelAdapter());
    Hive.registerAdapter<CompanyModel>(CompanyModelAdapter());
    Hive.registerAdapter<FileMetadata>(FileMetadataAdapter());
    Hive.registerAdapter<DashboardDataModel>(DashboardDataModelAdapter());

    // await Hive.deleteBoxFromDisk(HiveConstants.invoiceBox);
    // await Hive.deleteBoxFromDisk(HiveConstants.partyBox);
  }
}
