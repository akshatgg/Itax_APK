import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../shared/utils/widget/custom_floating_button.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../../shared/utils/widget/no_data_widget.dart';
import '../../../../shared/utils/widget/search_field.dart';
import '../../../../shared/utils/widget/sort_by_bottom_model_sheet.dart';
import '../../../router/router_helper.dart';
import '../../../router/routes.dart';
import '../domain/item/item_bloc.dart';
import '../domain/util/items_sorter.dart';
import 'widgets/item_app_bar.dart';
import 'widgets/item_detail.dart';

class ItemView extends StatefulHookWidget {
  const ItemView({super.key});

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  final ValueNotifier<int> _selectedListTypeIndex = ValueNotifier(0);

  @override
  void initState() {
    context.read<ItemBloc>().add(const OnGetItem());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final searchTextNotifier = useState('');
    final sortingTypeNotifier = useState(0);

    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.px),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ItemAppBar(),
              ValueListenableBuilder(
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSegmentButton(text: 'Show All', index: 0),
                      _buildSegmentButton(text: 'In Stock', index: 1),
                      _buildSegmentButton(text: 'Out of Stock', index: 2),
                    ],
                  );
                },
                valueListenable: _selectedListTypeIndex,
              ),
            ],
          ),
        ),
        floatingActionButton: CustomFloatingButton(
          tag: 'item-tag',
          title: 'Add Item',
          imagePath: ImageConstants.createInvoiceIcon,
          onTap: () => RouterHelper.push(context, AppRoutes.addEditItem.name),
        ),
        body: Container(
          color: AppColor.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: SearchField(
                  hint: 'Search',
                  onSearchChanged: (p0) => searchTextNotifier.value = p0,
                  onSort: () => showModalBottomSheet<void>(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return SortByBottomSheet(
                        onClickItem: (index) =>
                            sortingTypeNotifier.value = index,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              const Divider(color: AppColor.greyContainer),
              SizedBox(height: 1.h),
              ValueListenableBuilder(
                valueListenable: _selectedListTypeIndex,
                builder: (context, value, child) {
                  return BlocBuilder<ItemBloc, ItemState>(
                    builder: (context, state) {
                      var items = state.items;
                      if (value == 1) {
                        items = items
                            .where((test) => test.closingStock > 0)
                            .toList();
                      } else if (value == 2) {
                        items = items
                            .where((test) => test.closingStock <= 0)
                            .toList();
                      }
                      items = items
                          .where(
                            (test) => test.itemName.toLowerCase().contains(
                                  searchTextNotifier.value.toLowerCase(),
                                ),
                          )
                          .toList();
                      items = sortItems(items, sortingTypeNotifier.value);
                      return items.isEmpty
                          ? const Center(child: NoDataWidget())
                          : Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return ItemDetail(
                                    item: items[index],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    color: AppColor.greyContainer,
                                    thickness: 3,
                                  );
                                },
                                itemCount: items.length,
                              ),
                            );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentButton({
    required String text,
    required int index,
  }) {
    return GestureDetector(
      onTap: () => _selectedListTypeIndex.value = index,
      child: Container(
        height: 40.px,
        width: 110.px,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _selectedListTypeIndex.value == index
              ? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30.px),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: _selectedListTypeIndex.value == index
                ? const Color(0xFF3578E5)
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
