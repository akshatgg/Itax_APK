# ✅ Work Done by Rupesh

## 🔄 Routing System Overhaul
- [x] Integrated `GoRouter` with `StatefulShellRoute.indexedStack` to maintain tab state.
- [x] Defined all routes in `AppRoutes` and managed via `AppRouter`.
- [x] Enabled nested routing for scalable, modular navigation.

## 🔐 Authentication Flow Integration
- [x] Integrated login and signup routes into the main navigation flow.
- [x] Implemented auth-aware navigation with redirection for unauthenticated users.
- [ ] Google login error handling – **Assigned to Maulik**.

## 🧱 BLoC Architecture
- [x] Injected domain-specific BLoCs (`UserBloc`, `CompanyBloc`, `InvoiceBloc`, etc.) using `getIt`.
- [x] Used `BlocProvider.value` and `MultiBlocProvider` for scoped state management.

## 📱 Custom Bottom Navigation Bar
- [x] Created `CustomBottomAppBar` with equal spacing via `Expanded`.
- [x] Supported both `Icons` and `Image.asset`.
- [x] Highlighted selected tab.
- [x] Designed rounded top corners and subtle elevation.

## 🚫 Interaction Tweaks
- [x] Disabled splash/ripple effects on bottom nav using `InkWell` and `NoSplash` interaction.

## 🎨 UI/UX Enhancements
- [x] Increased bottom bar height and padding for better touch ergonomics.
- [x] Applied consistent design using `AppTextStyle` and `AppColor`.

## 🧩 Reusable UI Components
- [x] Created multiple modular UI widgets to support forms, layouts, and dynamic sections.

## 🧮 Feature Additions
- [x] Integrated all calculators (GST, Income Tax, etc.).
- [x] Built the complete ITR filing flow (step-by-step interface).
- [x] Developed the View Section UI for document and data review.
- [x] Integrated OCR module for extracting data from PAN, Aadhaar, and invoice images.
