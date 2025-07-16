import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/image_constants.dart';
import '../../router/router_helper.dart';
import '../../router/routes.dart';

class HomeScreen extends StatefulHookWidget {
  const HomeScreen({super.key, this.navigationShell});

  final StatefulNavigationShell? navigationShell;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _screens = [
    AppRoutes.homeView.name,
    AppRoutes.partyView.name,
    AppRoutes.itemView.name,
    AppRoutes.reportView.name,
    AppRoutes.moreView.name,
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState<int>(0);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: widget.navigationShell,
        backgroundColor: const Color(0xFFFFFCFC), //white ivory
        bottomNavigationBar: Container(
          height: 65.px,
          padding: EdgeInsets.only(top: 10.px),
          decoration: BoxDecoration(
            color: AppColor.white,
            boxShadow: [
              const BoxShadow(
                color: Colors.black54,
                spreadRadius: 0.1, // Spread of shadow
                blurRadius: 2, // Softness of shadow
                offset: Offset(0, -1),
              )
            ],
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.px),
              topLeft: Radius.circular(20.px),
            ),
          ),
          child: BottomAppBar(
            color: AppColor.white,
            padding: EdgeInsets.zero,
            shadowColor: Colors.black54,
            height: 40.px,
            // shape:const CircularNotchedRectangle(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                navItem(
                  icon: Icons.home_outlined,
                  label: 'Home',
                  selected: currentIndex.value == 0,
                  onTap: () {
                    currentIndex.value = 0;
                    RouterHelper.go(context, _screens[0], extra: false);
                  },
                ),
                navItem(
                  icon: Icons.group,
                  label: 'Parties',
                  selected: currentIndex.value == 1,
                  onTap: () {
                    currentIndex.value = 1;
                    RouterHelper.go(context, _screens[1], extra: false);
                  },
                ),
                navItem(
                  image: ImageConstants.itemIcon,
                  label: 'Items',
                  selected: currentIndex.value == 2,
                  onTap: () {
                    currentIndex.value = 2;
                    RouterHelper.go(context, _screens[2], extra: false);
                  },
                ),
                navItem(
                  image: ImageConstants.reportIcon,
                  // icon: CupertinoIcons.chart_bar_alt_fill,
                  label: 'Report',
                  selected: currentIndex.value == 3,
                  onTap: () {
                    currentIndex.value = 3;
                    RouterHelper.go(context, _screens[3], extra: false);
                  },
                ),
                navItem(
                  image: ImageConstants.moreIcon,
                  label: 'More',
                  selected: currentIndex.value == 4,
                  onTap: () {
                    currentIndex.value = 4;
                    RouterHelper.go(context, _screens[4], extra: false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navItem(
      {IconData? icon,
      String? image,
      required String label,
      required bool selected,
      VoidCallback? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            image == null
                ? Icon(
                    icon,
                    color: selected
                        ? AppColor.appColor
                        : Colors.black.withAlpha(100),
                  )
                : Image.asset(
                    image,
                    color: selected
                        ? AppColor.appColor
                        : Colors.black.withAlpha(100),
                  ),
            Text(
              label,
              style: AppTextStyle.pw500.copyWith(
                  color: selected
                      ? AppColor.appColor
                      : Colors.black.withAlpha(100)),
            )
          ],
        ),
      ),
    );
  }
}
