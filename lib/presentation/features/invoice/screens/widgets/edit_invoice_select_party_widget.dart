import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/data/apis/models/party/party_model.dart';
import '../../../../../core/utils/input_validations.dart';
import '../../../../../core/utils/list_extenstion.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../shared/utils/widget/dropdowns/search_dropdown.dart';
import '../../../../ui/create_sale_invoice/widget/all_bottom_sheet_widget.dart';

class EditInvoiceSelectPartyWidget extends StatefulHookWidget {
  const EditInvoiceSelectPartyWidget({
    super.key,
    required this.selectedPartyNotifier,
    required this.partyList,
  });

  final ValueNotifier<int> selectedPartyNotifier;
  final List<PartyModel> partyList;

  @override
  State<EditInvoiceSelectPartyWidget> createState() =>
      _EditInvoiceSelectPartyWidgetState();
}

class _EditInvoiceSelectPartyWidgetState
    extends State<EditInvoiceSelectPartyWidget> {
  TextEditingController searchController = TextEditingController();
  TextEditingController businessAddressController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    logger.d(widget.partyList);
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final PartyModel? party = widget.partyList.firstWhereOrNull(
      (element) => element.partyName == searchController.text,
    );
    if (party != null) {
      widget.selectedPartyNotifier.value = widget.partyList.indexOf(party);
      businessAddressController.text = party.businessAddress ?? '';
      pinCodeController.text = party.pinCode ?? '';
    }
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateNotifier = useState<String>('');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Party',
              style: AppTextStyle.pw500.copyWith(
                color: AppColor.darkGrey,
                fontSize: 16.px,
              ),
            ),
            if (widget.selectedPartyNotifier.value != -1)
              GestureDetector(
                onTap: () {
                  final party =
                      widget.partyList[widget.selectedPartyNotifier.value];
                  stateNotifier.value = party.state ?? '';
                  editAddressBottomSheet(
                    context,
                    businessAddressController,
                    pinCodeController,
                    stateNotifier,
                  );
                },
                child: Text(
                  'Edit Address',
                  style: AppTextStyle.pw500.copyWith(
                    color: AppColor.appColor,
                    fontSize: 12.px,
                  ),
                ),
              )
          ],
        ),
        SizedBox(height: 2.h),
        AutoCompleteInput(
          items: widget.partyList.map((e) => e.partyName).toList(),
          label: 'Selected Party',
          initialValue: '',
          onSelected: (val) {
            searchController.text = val;
            FocusScope.of(context).unfocus();
          },
          validator: (val) => InputValidator.hasValue<String>(val),
          type: TextInputType.text,
        )
      ],
    );
  }
}
