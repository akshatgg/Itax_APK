import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/enums/invoice_type.dart';
import '../../core/data/apis/models/company/company_model.dart';
import '../../core/data/apis/models/invoice/invoice_model.dart';
import '../../core/data/apis/models/invoice/notes_model.dart';
import '../../core/data/apis/models/invoice/receipt_model.dart';
import '../../core/data/apis/models/items/item_model.dart';
import '../../core/data/apis/models/party/party_model.dart';
import '../../core/utils/get_it_instance.dart';
import '../features/auth/domain/bloc/auth_bloc.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/sign_up_screen.dart';
import '../features/company/domain/company_bloc.dart';
import '../features/company/more_add_company.dart';
import '../features/company/more_my_company_detail.dart';
import '../features/company/more_my_company_screen.dart';
import '../features/invoice/domain/invoice/invoice_bloc.dart';
import '../features/invoice/domain/notes/notes_bloc.dart';
import '../features/invoice/domain/receipt/receipt_bloc.dart';
import '../features/invoice/screens/create_invoice_note_screen.dart';
import '../features/invoice/screens/create_receipt_invoice_screen.dart';
import '../features/invoice/screens/create_sale_invoice.dart';
import '../features/invoice/screens/unpaid_invoice_screen.dart';
import '../features/items/domain/item/item_bloc.dart';
import '../features/items/screens/add_item_screen.dart';
import '../features/items/screens/item_detail_screen.dart';
import '../features/parties/domain/parties/parties_bloc.dart';
import '../features/parties/screens/add_party_screen.dart';
import '../features/parties/screens/party_detail_screen.dart';
import '../features/profile/domain/user_bloc.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/reports/domain/day_book/day_book_bloc.dart';
import '../features/reports/sales_screen/sales_customer_detail_screen.dart';
import '../features/reports/sales_screen/sales_customer_screen.dart';
import '../features/reports/sales_screen/sales_month_screen.dart';
import '../features/reports/sales_screen/sales_screen.dart';
import '../features/reports/screens/expenses_category_screen.dart';
import '../features/reports/screens/report_day_book_screen.dart';
import '../features/reports/screens/report_inactive_customer_screen.dart';
import '../features/reports/screens/report_inactive_item_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/splash/splash_screen_next.dart';
import '../ui/dashboard_view/dashboard_view.dart';
import '../ui/more_about_us_screen/more_about_us_screen.dart';
import '../ui/more_gst_set_up_screen/more_gst_set_up_screen.dart';
import '../ui/more_manage_user_screen/more_manage_user_screen.dart';
import '../ui/more_privacy_policy_screen/more_privacy_policy_screen.dart';
import '../ui/report_balance_sheet_screen/report_balance_sheet_screen.dart';
import '../ui/report_capital_account_screen/report_capital_account_screen.dart';
import '../ui/report_expanses_screen/report_expanses_screen.dart';
import '../ui/report_profit_loss_screen/report_profit_loss_screen.dart';
import '../ui/report_trial_balance_screen/report_trial_balance_screen.dart';
import 'routes.dart';

class AppScreens {
  /* static final temp = GoRoute(
    path: AppRoutes.temp.path,
    name: AppRoutes.temp.name,
    builder: (context, state) => const InputExample(),
  ); */

  static final splash = GoRoute(
    path: AppRoutes.splash.path,
    name: AppRoutes.splash.name,
    builder: (context, state) => BlocProvider.value(
      value: getIt.get<CompanyBloc>(),
      child: const SplashScreen(),
    ),
  );
  static final splashNext = GoRoute(
    path: AppRoutes.splashNext.path,
    name: AppRoutes.splashNext.name,
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: getIt.get<CompanyBloc>(),
        ),
        BlocProvider.value(
          value: getIt.get<ItemBloc>(),
        ),
        BlocProvider.value(
          value: getIt.get<PartiesBloc>(),
        ),
        BlocProvider.value(
          value: getIt.get<ReceiptBloc>(),
        ),
        BlocProvider.value(
          value: getIt.get<InvoiceBloc>(),
        ),
        BlocProvider.value(
          value: getIt.get<DayBookBloc>(),
        ),
        BlocProvider.value(
          value: getIt.get<NotesBloc>(),
        ),
      ],
      child: const SplashScreenNext(),
    ),
  );

  static final dashboardView = GoRoute(
    path: AppRoutes.dashboardView.path,
    name: AppRoutes.dashboardView.name,
    builder: (context, state) => BlocProvider.value(
      value: getIt.get<UserBloc>(),
      child: const DashboardView(),
    ),
  );
  static final signIn = GoRoute(
    path: AppRoutes.signIn.path,
    name: AppRoutes.signIn.name,
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: getIt.get<AuthBloc>(),
        ),
        BlocProvider.value(
          value: getIt.get<UserBloc>(),
        ),
        BlocProvider.value(
          value: getIt.get<CompanyBloc>(),
        ),
      ],
      child: const LoginScreen(),
    ),
  );

  static final signup = GoRoute(
    path: AppRoutes.signup.path,
    name: AppRoutes.signup.name,
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: getIt.get<AuthBloc>(),
        ),
        BlocProvider.value(
          value: getIt.get<UserBloc>(),
        ),
      ],
      child: const SignUpScreen(),
    ),
  );

  static final profileRoute = GoRoute(
    path: AppRoutes.profile.path,
    name: AppRoutes.profile.name,
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: getIt.get<UserBloc>(),
        ),
        BlocProvider.value(
          value: getIt.get<CompanyBloc>(),
        )
      ],
      child: const ProfileScreen(),
    ),
    routes: [],
  );

  static final reportTrialBalance = GoRoute(
    path: AppRoutes.reportTrialBalance.path,
    name: AppRoutes.reportTrialBalance.name,
    builder: (context, state) => BlocProvider.value(
      value: getIt.get<DayBookBloc>(),
      child: const ReportTrialBalanceScreen(),
    ),
    routes: [],
  );
  static final reportDay = GoRoute(
    path: AppRoutes.reportDay.path,
    name: AppRoutes.reportDay.name,
    builder: (context, state) => BlocProvider.value(
        value: getIt.get<DayBookBloc>(), child: const ReportDayBookScreen()),
    routes: [],
  );

  static final addCategory = GoRoute(
    path: AppRoutes.addCategory.path,
    name: AppRoutes.addCategory.name,
    builder: (context, state) => BlocProvider.value(
        value: getIt.get<DayBookBloc>(), child: const ExpansesCategoryScreen()),
    routes: [],
  );
  static final reportExpanse = GoRoute(
    path: AppRoutes.reportExpanse.path,
    name: AppRoutes.reportExpanse.name,
    builder: (context, state) => const ReportExpansesScreen(),
    routes: [],
  );
  static final reportInactiveCustomer = GoRoute(
    path: AppRoutes.reportInactiveCustomer.path,
    name: AppRoutes.reportInactiveCustomer.name,
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: getIt.get<InvoiceBloc>(),
        ),
        BlocProvider.value(
          value: getIt.get<PartiesBloc>(),
        ),
      ],
      child: const ReportInactiveCustomerScreen(),
    ),
    routes: [],
  );
  static final reportInactiveItem = GoRoute(
    path: AppRoutes.reportInactiveItem.path,
    name: AppRoutes.reportInactiveItem.name,
    builder: (context, state) => MultiBlocProvider(providers: [
      BlocProvider.value(
        value: getIt.get<InvoiceBloc>(),
      ),
      BlocProvider.value(
        value: getIt.get<ItemBloc>(),
      ),
    ], child: const ReportInactiveItemScreen()),
    routes: [],
  );
  static final reportProfitLoss = GoRoute(
    path: AppRoutes.reportProfitLoss.path,
    name: AppRoutes.reportProfitLoss.name,
    builder: (context, state) => const ReportProfitLossScreen(),
    routes: [],
  );
  static final reportCapitalAccount = GoRoute(
    path: AppRoutes.reportCapitalAccount.path,
    name: AppRoutes.reportCapitalAccount.name,
    builder: (context, state) => const ReportCapitalAccountScreen(),
    routes: [],
  );
  static final reportBalanceSheet = GoRoute(
    path: AppRoutes.reportBalanceSheet.path,
    name: AppRoutes.reportBalanceSheet.name,
    builder: (context, state) => const ReportBalanceSheetScreen(),
    routes: [],
  );
  static final partyDetail = GoRoute(
    path: AppRoutes.partyDetail.path,
    name: AppRoutes.partyDetail.name,
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      final PartyModel partyModel =
          PartyModel.fromJson(data['party'] as Map<String, dynamic>);
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: getIt.get<InvoiceBloc>(),
          ),
          BlocProvider.value(
            value: getIt.get<PartiesBloc>(),
          ),
          BlocProvider.value(
            value: getIt.get<NotesBloc>(),
          ),
          BlocProvider.value(
            value: getIt.get<ReceiptBloc>(),
          ),
        ],
        child: PartyDetailScreen(partyModel: partyModel),
      );
    },
    routes: [],
  );

  static final addEditItem = GoRoute(
    path: AppRoutes.addEditItem.path,
    name: AppRoutes.addEditItem.name,
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>?;
      final ItemModel? editingItem = data != null
          ? ItemModel.fromJson(data['editingItem'] as Map<String, dynamic>)
          : null;
      return BlocProvider.value(
        value: getIt.get<ItemBloc>(),
        child: AddItemScreen(editingItem: editingItem),
      );
    },
    routes: [],
  );

  static final addParty = GoRoute(
    path: AppRoutes.addParty.path,
    name: AppRoutes.addParty.name,
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>? ?? {};
      final partyJson = data['party'] as Map<String, dynamic>?;
      PartyModel? partyModel;
      if (partyJson != null) {
        partyModel = PartyModel.fromJson(partyJson);
      }
      return BlocProvider.value(
        value: getIt.get<PartiesBloc>(),
        child: AddPartyScreen(
          partyModel: partyModel,
        ),
      );
    },
    routes: [],
  );
  static final itemDetail = GoRoute(
    path: AppRoutes.itemDetail.path,
    name: AppRoutes.itemDetail.name,
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      final ItemModel editingItem =
          ItemModel.fromJson(data['editItem'] as Map<String, dynamic>);
      return BlocProvider.value(
        value: getIt.get<ItemBloc>(),
        child: ItemDetailScreen(item: editingItem),
      );
    },
    routes: [],
  );
  static final moreMyCompany = GoRoute(
    path: AppRoutes.moreMyCompany.path,
    name: AppRoutes.moreMyCompany.name,
    builder: (context, state) => BlocProvider.value(
      value: getIt.get<CompanyBloc>(),
      child: const MoreMyCompany(),
    ),
    routes: [],
  );

  static final moreManageUser = GoRoute(
    path: AppRoutes.moreManageUser.path,
    name: AppRoutes.moreManageUser.name,
    builder: (context, state) => const MoreManageUserScreen(),
    routes: [],
  );
  static final moreGstSetUp = GoRoute(
    path: AppRoutes.moreGstSetUp.path,
    name: AppRoutes.moreGstSetUp.name,
    builder: (context, state) => const MoreGstSetUpScreen(),
    routes: [],
  );
  static final moreMyCompanyDetail = GoRoute(
    path: AppRoutes.moreMyCompanyDetail.path,
    name: AppRoutes.moreMyCompanyDetail.name,
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>;

      final companyJson = data['company'] as Map<String, dynamic>?;
      CompanyModel? companyModel;
      if (companyJson != null) {
        companyModel = CompanyModel.fromJson(companyJson);
      }
      return BlocProvider.value(
        value: getIt.get<CompanyBloc>(),
        child: MoreMyCompanyDetail(companyModel: companyModel),
      );
    },
    routes: [],
  );
  static final morePrivacyPolicy = GoRoute(
    path: AppRoutes.morePrivacyPolicy.path,
    name: AppRoutes.morePrivacyPolicy.name,
    builder: (context, state) => const MorePrivacyPolicyScreen(),
    routes: [],
  );
  static final moreAboutUs = GoRoute(
    path: AppRoutes.moreAboutUs.path,
    name: AppRoutes.moreAboutUs.name,
    builder: (context, state) => const MoreAboutUsScreen(),
    routes: [],
  );
  static final createSalesInvoice = GoRoute(
    path: AppRoutes.createSalesInvoice.path,
    name: AppRoutes.createSalesInvoice.name,
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>;

      final invoiceType = data['type'] as InvoiceType;
      final invoiceJson = data['invoice'] as Map<String, dynamic>?;
      InvoiceModel? invoice =
          invoiceJson != null ? InvoiceModel.fromJson(invoiceJson) : null;
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: getIt.get<InvoiceBloc>(),
          ),
          BlocProvider.value(
            value: getIt.get<PartiesBloc>(),
          ),
          BlocProvider.value(
            value: getIt.get<ItemBloc>(),
          ),
          BlocProvider.value(
            value: getIt.get<CompanyBloc>(),
          ),
        ],
        child: CreateSaleInvoice(invoiceType: invoiceType, invoice: invoice),
      );
    },
    routes: [],
  );
  static final createReceiptInvoice = GoRoute(
    path: AppRoutes.createReceiptInvoice.path,
    name: AppRoutes.createReceiptInvoice.name,
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      final invoiceType = data['type'] as InvoiceType;
      final invoiceJson = data['receipt'] as Map<String, dynamic>?;
      ReceiptModel? receipt =
          invoiceJson != null ? ReceiptModel.fromJson(invoiceJson) : null;
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: getIt.get<InvoiceBloc>(),
          ),
          BlocProvider.value(
            value: getIt.get<PartiesBloc>(),
          ),
          BlocProvider.value(
            value: getIt.get<ItemBloc>(),
          ),
          BlocProvider.value(
            value: getIt.get<ReceiptBloc>(),
          ),
        ],
        child: CreateReceiptInvoice(
          invoiceType: invoiceType,
          receipt: receipt,
        ),
      );
    },
    routes: [],
  );
  static final createNoteInvoice = GoRoute(
    path: AppRoutes.createNoteInvoice.path,
    name: AppRoutes.createNoteInvoice.name,
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      final invoiceType = data['type'] as InvoiceType;
      final noteJson = data['note'] as Map<String, dynamic>?;
      NotesModel? note =
          noteJson != null ? NotesModel.fromJson(noteJson) : null;
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: getIt.get<InvoiceBloc>(),
          ),
          BlocProvider.value(
            value: getIt.get<PartiesBloc>(),
          ),
          BlocProvider.value(
            value: getIt.get<NotesBloc>(),
          ),
        ],
        child: CreateNoteInvoice(invoiceType: invoiceType, note: note),
      );
    },
    routes: [],
  );
  static final unPaidInvoice = GoRoute(
    path: AppRoutes.unPaidInvoice.path,
    name: AppRoutes.unPaidInvoice.name,
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>;
      final PartyModel partyModel =
          PartyModel.fromJson(data['party'] as Map<String, dynamic>);
      final List<String> invoices = data['invoices'] as List<String>;
      final bool selectOnlyOne = data['selectOnlyOne'] as bool? ?? false;
      return BlocProvider.value(
        value: getIt.get<InvoiceBloc>(),
        child: UnpaidInvoiceScreen(
          partyModel: partyModel,
          invoices: invoices,
          selectOnlyOne: selectOnlyOne,
        ),
      );
    },
    routes: [],
  );
  static final salesScreen = GoRoute(
    path: AppRoutes.salesScreen.path,
    name: AppRoutes.salesScreen.name,
    builder: (context, state) => MultiBlocProvider(providers: [
      BlocProvider.value(value: getIt.get<InvoiceBloc>()),
      BlocProvider.value(value: getIt.get<PartiesBloc>()),
    ], child: const SalesScreen()),
    routes: [],
  );
  static final salesCustomerDetailScreen = GoRoute(
    path: AppRoutes.salesCustomerDetailScreen.path,
    name: AppRoutes.salesCustomerDetailScreen.name,
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>;

      final partyJson = data['party'] as Map<String, dynamic>?;
      PartyModel? partyModel;
      if (partyJson != null) {
        partyModel = PartyModel.fromJson(partyJson);
      }
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: getIt.get<InvoiceBloc>(),
          ),
          BlocProvider.value(
            value: getIt.get<PartiesBloc>(),
          ),
        ],
        child: SalesCustomerDetailScreen(partyModel: partyModel),
      );
    },
    routes: [],
  );
  static final salesMonthScreen = GoRoute(
    path: AppRoutes.salesMonthScreen.path,
    name: AppRoutes.salesMonthScreen.name,
    builder: (context, state) => BlocProvider.value(
      value: getIt.get<InvoiceBloc>(),
      child: const SalesMonthScreen(),
    ),
    routes: [],
  );
  static final salesCustomerScreen = GoRoute(
    path: AppRoutes.salesCustomerScreen.path,
    name: AppRoutes.salesCustomerScreen.name,
    builder: (context, state) => BlocProvider.value(
      value: getIt.get<PartiesBloc>(),
      child: const SalesCustomerScreen(),
    ),
    routes: [],
  );
  static final addCompany = GoRoute(
    path: AppRoutes.addCompany.path,
    name: AppRoutes.addCompany.name,
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>?;

      final companyJson = data?['company'] as Map<String, dynamic>?;
      CompanyModel? companyModel;
      if (companyJson != null) {
        companyModel = CompanyModel.fromJson(companyJson);
      }
      return BlocProvider.value(
          value: getIt.get<CompanyBloc>(),
          child: MoreAddCompany(companyModel: companyModel));
    },
    routes: [],
  );
}
