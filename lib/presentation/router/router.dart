import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/repos/user_repo.dart';
import '../../core/utils/get_it_instance.dart';
import '../features/company/domain/company_bloc.dart';
import '../features/invoice/domain/invoice/invoice_bloc.dart';
import '../features/invoice/domain/notes/notes_bloc.dart';
import '../features/invoice/domain/receipt/receipt_bloc.dart';
import '../features/items/domain/item/item_bloc.dart';
import '../features/items/screens/item_screen.dart';
import '../features/more_screen/more_screen.dart';
import '../features/parties/domain/parties/parties_bloc.dart';
import '../features/parties/screens/parties_screen.dart';
import '../features/profile/domain/user_bloc.dart';
import '../features/reports/screens/report_screen.dart';
import '../ui/dashboard_view/dashboard_screen.dart';
import '../ui/dashboard_view/dashboard_view.dart';
import '../ui/home_screen/home_screen.dart';
import '../ui/home_view/home_view.dart';
import 'app_screens.dart';
import 'routes.dart';

// Add imports for calculator screens

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splashNext.path,
    navigatorKey: _rootNavigatorKey,
    /*redirect: (context, state) async {
      final userBloc = getIt.get<UserBloc>();
      final userRepo = getIt.get<UserRepo>();

      try {
        final user = await userRepo.getUser(); // async check
        final isLoggedIn = user != null;

        // If user is logged in, redirect to dashboard
        if (isLoggedIn && state.matchedLocation == AppRoutes.signIn.path) {
          return AppRoutes.dashboardView.path;
        }

        // If user is not logged in and trying to access a private route
        if (!isLoggedIn &&
            state.matchedLocation != AppRoutes.signIn.path &&
            state.matchedLocation != AppRoutes.signup.path) {
          return AppRoutes.signIn.path;
        }

        return null; // no redirection
      } catch (_) {
        return AppRoutes.signIn.path;
      }
    },*/
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) =>
            BlocProvider.value(
          value: getIt.get<UserBloc>(),
          child: DashboardScreen(navigationShell: navigationShell),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboardView.path,
                name: AppRoutes.dashboardView.name,
                builder: (context, state) => BlocProvider.value(
                  value: getIt.get<UserBloc>(),
                  child: const DashboardView(),
                ),
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) =>
            BlocProvider.value(
          value: getIt.get<CompanyBloc>(),
          child: HomeScreen(navigationShell: navigationShell),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.homeView.path,
                name: AppRoutes.homeView.name,
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: getIt.get<ItemBloc>()),
                    BlocProvider.value(value: getIt.get<PartiesBloc>()),
                  ],
                  child: const HomeView(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.partyView.path,
                name: AppRoutes.partyView.name,
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: getIt.get<PartiesBloc>()),
                    BlocProvider.value(value: getIt.get<InvoiceBloc>()),
                    BlocProvider.value(value: getIt.get<ReceiptBloc>()),
                    BlocProvider.value(value: getIt.get<NotesBloc>()),
                  ],
                  child: const PartiesView(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.itemView.path,
                name: AppRoutes.itemView.name,
                builder: (context, state) => BlocProvider.value(
                  value: getIt.get<ItemBloc>(),
                  child: const ItemView(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.reportView.path,
                name: AppRoutes.reportView.name,
                builder: (context, state) => const ReportView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.moreView.path,
                name: AppRoutes.moreView.name,
                builder: (context, state) => const MoreView(),
              ),
            ],
          ),
        ],
      ),

      // Core app screens
      AppScreens.splash,
      AppScreens.signIn,
      AppScreens.profileRoute,
      AppScreens.signup,
      AppScreens.splashNext,
      AppScreens.partyDetail,
      AppScreens.itemDetail,
      AppScreens.addEditItem,
      AppScreens.addParty,
      AppScreens.reportDay,
      AppScreens.reportBalanceSheet,
      AppScreens.reportCapitalAccount,
      AppScreens.reportProfitLoss,
      AppScreens.reportTrialBalance,
      AppScreens.reportInactiveItem,
      AppScreens.reportInactiveCustomer,
      AppScreens.reportExpanse,
      AppScreens.addCategory,
      AppScreens.moreMyCompany,
      AppScreens.moreGstSetUp,
      AppScreens.moreManageUser,
      AppScreens.moreMyCompanyDetail,
      AppScreens.moreAboutUs,
      AppScreens.morePrivacyPolicy,
      AppScreens.createSalesInvoice,
      AppScreens.createNoteInvoice,
      AppScreens.createReceiptInvoice,
      AppScreens.unPaidInvoice,
      AppScreens.salesScreen,
      AppScreens.salesCustomerDetailScreen,
      AppScreens.salesCustomerScreen,
      AppScreens.salesMonthScreen,
      AppScreens.addCompany,
    ],
  );
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
//
// import '../features/company/domain/company_bloc.dart';
// import '../features/invoice/domain/invoice/invoice_bloc.dart';
// import '../features/invoice/domain/notes/notes_bloc.dart';
// import '../features/invoice/domain/receipt/receipt_bloc.dart';
// import '../features/items/domain/item/item_bloc.dart';
// import '../features/items/screens/item_screen.dart';
// import '../features/more_screen/more_screen.dart';
// import '../features/parties/domain/parties/parties_bloc.dart';
// import '../features/parties/screens/parties_screen.dart';
// import '../features/profile/domain/user_bloc.dart';
// import '../features/reports/screens/report_screen.dart';
// import '../presentation/dashboard_view/dash_board_screen.dart';
// import '../presentation/dashboard_view/dashboard_view.dart';
// import '../presentation/home_screen/home_screen.dart';
// import '../presentation/home_view/home_view.dart';
// import '../utils/get_it_instance.dart';
// import 'app_screens.dart';
// import 'routes.dart';
//
// class AppRouter {
//   static final _rootNavigatorKey = GlobalKey<NavigatorState>();
//   static final GoRouter router = GoRouter(
//     initialLocation: AppRoutes.splash.path,
//     navigatorKey: _rootNavigatorKey,
//     routes: [
//       StatefulShellRoute.indexedStack(
//         builder: (
//           BuildContext context,
//           GoRouterState state,
//           StatefulNavigationShell navigationShell,
//         ) =>
//             BlocProvider.value(
//           value: getIt.get<UserBloc>(),
//           child: DashBoardScreen(navigationShell: navigationShell),
//         ),
//         branches: [
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.dashboardView.path,
//                 name: AppRoutes.dashboardView.name,
//                 builder: (context, state) => BlocProvider.value(
//                   value: getIt.get<UserBloc>(),
//                   child: const DashboardView(),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       StatefulShellRoute.indexedStack(
//         builder: (
//           BuildContext context,
//           GoRouterState state,
//           StatefulNavigationShell navigationShell,
//         ) =>
//             BlocProvider.value(
//           value: getIt.get<CompanyBloc>(),
//           child: HomeScreen(navigationShell: navigationShell),
//         ),
//         branches: [
// // dashboard
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.homeView.path,
//                 name: AppRoutes.homeView.name,
//                 builder: (context, state) => MultiBlocProvider(
//                   providers: [
//                     BlocProvider.value(
//                       value: getIt.get<ItemBloc>(),
//                     ),
//                     BlocProvider.value(
//                       value: getIt.get<PartiesBloc>(),
//                     ),
//                   ],
//                   child: const HomeView(),
//                 ),
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.partyView.path,
//                 name: AppRoutes.partyView.name,
//                 builder: (context, state) => MultiBlocProvider(
//                   providers: [
//                     BlocProvider.value(
//                       value: getIt.get<PartiesBloc>(),
//                     ),
//                     BlocProvider.value(
//                       value: getIt.get<InvoiceBloc>(),
//                     ),
//                     BlocProvider.value(
//                       value: getIt.get<ReceiptBloc>(),
//                     ),
//                     BlocProvider.value(
//                       value: getIt.get<NotesBloc>(),
//                     ),
//                   ],
//                   child: const PartiesView(),
//                 ),
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.itemView.path,
//                 name: AppRoutes.itemView.name,
//                 builder: (context, state) => BlocProvider.value(
//                   value: getIt.get<ItemBloc>(),
//                   child: const ItemView(),
//                 ),
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.reportView.path,
//                 name: AppRoutes.reportView.name,
//                 builder: (context, state) => const ReportView(),
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.moreView.path,
//                 name: AppRoutes.moreView.name,
//                 builder: (context, state) => const MoreView(),
//               ),
//             ],
//           ),
//         ],
//       ),
//       // AppScreens.temp,
//       AppScreens.splash,
//       AppScreens.signIn,
//       AppScreens.profileRoute,
//       AppScreens.signup,
//       AppScreens.splashNext,
//       AppScreens.partyDetail,
//       AppScreens.itemDetail,
//       AppScreens.addEditItem,
//       AppScreens.addParty,
//       AppScreens.reportDay,
//       AppScreens.reportBalanceSheet,
//       AppScreens.reportCapitalAccount,
//       AppScreens.reportProfitLoss,
//       AppScreens.reportTrialBalance,
//       AppScreens.reportInactiveItem,
//       AppScreens.reportInactiveCustomer,
//       AppScreens.reportExpanse,
//       AppScreens.moreMyCompany,
//       AppScreens.moreGstSetUp,
//       AppScreens.moreManageUser,
//       AppScreens.moreMyCompanyDetail,
//       AppScreens.moreAboutUs,
//       AppScreens.morePrivacyPolicy,
//       AppScreens.createSalesInvoice,
//       AppScreens.createNoteInvoice,
//       AppScreens.createReceiptInvoice,
//       AppScreens.unPaidInvoice,
//       AppScreens.salesScreen,
//       AppScreens.salesCustomerDetailScreen,
//       AppScreens.salesCustomerScreen,
//       AppScreens.salesMonthScreen,
//       AppScreens.addCompany,
//     ],
//   );
// }
