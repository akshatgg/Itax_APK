import 'package:get_it/get_it.dart';

import '../../presentation/features/auth/domain/bloc/auth_bloc.dart';
import '../../presentation/features/company/domain/company_bloc.dart';
import '../../presentation/features/invoice/domain/invoice/invoice_bloc.dart';
import '../../presentation/features/invoice/domain/notes/notes_bloc.dart';
import '../../presentation/features/invoice/domain/receipt/receipt_bloc.dart';
import '../../presentation/features/items/domain/item/item_bloc.dart';
import '../../presentation/features/parties/domain/parties/parties_bloc.dart';
import '../../presentation/features/profile/domain/user_bloc.dart';
import '../../presentation/features/reports/domain/day_book/day_book_bloc.dart';
import '../config/firebase/firebase_api.dart';
import '../data/indian_states.dart';
import '../data/repos/auth_repo.dart';
import '../data/repos/company_repo.dart';
import '../data/repos/dashboard_data_repo.dart';
import '../data/repos/day_book_repo.dart';
import '../data/repos/invoice_repo.dart';
import '../data/repos/items_repo.dart';
import '../data/repos/notes_repo.dart';
import '../data/repos/parties_repo.dart';
import '../data/repos/receipt_repo.dart';
import '../data/repos/services/file_storage_service.dart';
import '../data/repos/services/gst_validation_service.dart';
import '../data/repos/services/otpless_service.dart';
import '../data/repos/shared_prefs/shared_pref_repo.dart';
import '../data/repos/storage/company_storage.dart';
import '../data/repos/storage/dashboard_data_storage.dart';
import '../data/repos/storage/day_book_storage.dart';
import '../data/repos/storage/invoice_storage.dart';
import '../data/repos/storage/item_storage.dart';
import '../data/repos/storage/notes_storage.dart';
import '../data/repos/storage/party_storage.dart';
import '../data/repos/storage/receipt_storage.dart';
import '../data/repos/storage/user_storage.dart';
import '../data/repos/user_repo.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  final indianStatesData = await loadIndianStatesData();
  if (indianStatesData != null) {
    indianStatesData.state.sort((a, b) => a.name.compareTo(b.name));
    for (var element in indianStatesData.state) {
      element.city.sort((a, b) => a.name.compareTo(b.name));
    }
    getIt.registerSingleton(indianStatesData);
  }
  final sharedPrefRepo = SharedPrefRepository();
  getIt.registerSingleton(sharedPrefRepo);

  final fileService = FileStorageService();
  getIt.registerSingleton(fileService);

  final firebaseApiService = FirebaseService();
  final storageService = UserStorage();
  final authRepo =
      AuthRepo(firebaseApi: firebaseApiService, storageService: storageService);
  getIt.registerSingleton(authRepo);
  final otplessService = OtplessService();
  otplessService.init();
  getIt.registerSingleton(otplessService);
  getIt.registerSingleton(AuthBloc(authRepo, otplessService));

  final companyStorageService = CompanyStorage();
  getIt.registerSingleton(companyStorageService);
  final companyRepo = CompanyRepo(
    storageService: companyStorageService,
    sharedPrefRepo: sharedPrefRepo,
  );
  getIt.registerSingleton(companyRepo);

  final itemStorageService = ItemStorage();
  getIt.registerSingleton(itemStorageService);
  final itemsRepo = ItemsRepo(storageService: itemStorageService);
  getIt.registerSingleton(itemsRepo);
  getIt.registerSingleton(ItemBloc(itemsRepo, companyRepo, fileService));

  final gstValidationService = GSTValidationService();
  getIt.registerSingleton(gstValidationService);

  final partyStorageService = PartyStorage();
  getIt.registerSingleton(partyStorageService);
  final partyRepo = PartiesRepo(storageService: partyStorageService);
  getIt.registerSingleton(partyRepo);
  getIt.registerSingleton(
      PartiesBloc(partyRepo, companyRepo, gstValidationService));

  final userStorageService = UserStorage();
  getIt.registerSingleton(userStorageService);
  final userRepo = UserRepo(storageService: userStorageService);
  getIt.registerSingleton(userRepo);
  getIt.registerSingleton(UserBloc(userRepo));

  final dayBookStorageService = DayBookStorage();
  getIt.registerSingleton(dayBookStorageService);
  final dayBookRepo = DayBookRepo(
    storageService: dayBookStorageService,
    companyRepo: companyRepo,
  );
  getIt.registerSingleton(dayBookRepo);
  getIt.registerSingleton(DayBookBloc(
    dayBookRepo: dayBookRepo,
    companyRepo: companyRepo,
  ));

  final dashboardDataStorageService = DashboardDataStorage();
  getIt.registerSingleton(dashboardDataStorageService);
  final dashboardDataRepo = DashboardDataRepo(
    storageService: dashboardDataStorageService,
  );
  getIt.registerSingleton(dashboardDataRepo);

  final invoiceStorageService = InvoiceStorage();
  getIt.registerSingleton(invoiceStorageService);
  final invoiceRepo = InvoiceRepo(storageService: invoiceStorageService);
  getIt.registerSingleton(invoiceRepo);
  getIt.registerSingleton(InvoiceBloc(
    invoiceRepo: invoiceRepo,
    partyRepo: partyRepo,
    itemRepo: itemsRepo,
    dayBookRepo: dayBookRepo,
    companyRepo: companyRepo,
    dashboardDataRepo: dashboardDataRepo,
  ));

  final receiptStorageService = ReceiptStorage();
  getIt.registerSingleton(receiptStorageService);
  final receiptRepo = ReceiptRepo(storageService: receiptStorageService);
  getIt.registerSingleton(receiptRepo);
  getIt.registerSingleton(ReceiptBloc(
    receiptRepo: receiptRepo,
    invoiceRepo: invoiceRepo,
    partyRepo: partyRepo,
    companyRepo: companyRepo,
    dayBookRepo: dayBookRepo,
    dashboardDataRepo: dashboardDataRepo,
  ));

  final notesStorageService = NotesStorage();
  getIt.registerSingleton(notesStorageService);
  final notesRepo = NotesRepo(storageService: notesStorageService);
  getIt.registerSingleton(notesRepo);
  getIt.registerSingleton(NotesBloc(
    notesRepo: notesRepo,
    partyRepo: partyRepo,
    invoiceRepo: invoiceRepo,
    companyRepo: companyRepo,
    dayBookRepo: dayBookRepo,
    dashboardDataRepo: dashboardDataRepo,
  ));

  getIt.registerSingleton(CompanyBloc(
    repo: companyRepo,
    fileService: fileService,
    itemsRepo: itemsRepo,
    partiesRepo: partyRepo,
    receiptRepo: receiptRepo,
    invoiceRepo: invoiceRepo,
    notesRepo: notesRepo,
    dayBookRepo: dayBookRepo,
    dashboardDataRepo: dashboardDataRepo,
  ));
}
