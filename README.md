# itax_easy

## 🔄 Recent Changes

### 🧭 Routing System Overhaul

- Integrated `GoRouter` with `StatefulShellRoute.indexedStack` to preserve navigation state across
  tabs.
- Defined route paths in `AppRoutes` and structured them via `AppRouter`.
- Enabled nested routing for scalable multi-tab navigation.

### 🧱 BLoC Integration per Route

- Injected domain-specific BLoCs using `getIt` (e.g., `UserBloc`, `CompanyBloc`, `InvoiceBloc`,
  etc.).
- Used `BlocProvider.value` and `MultiBlocProvider` for scoped state management inside route
  builders.

### 📱 Custom Bottom Navigation Bar

- Added `CustomBottomAppBar` widget with:
    - Equal distribution using `Expanded`.
    - Support for both `Icons` and `Image.asset`.
    - State-based selection styling (highlighting selected tab).
    - Rounded top corners and subtle elevation.

### 🚫 Removed Visual Feedback

- Disabled tap feedback (no splash or ripple effect) on bottom navigation items for a cleaner UX.
- Achieved via `InkWell` settings and global theme or `NoSplash` interaction behavior.

### ✨ General UI/UX Improvements

- Increased bottom bar height and padding for better touch targets.
- Consistent style using `AppTextStyle` and `AppColor`.

