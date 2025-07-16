import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/enums/party_type.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/data/apis/models/party/party_model.dart';
import '../../../../core/data/indian_states.dart';
import '../../../../core/utils/get_it_instance.dart';
import '../../../../core/utils/input_formatter.dart';
import '../../../../core/utils/input_validations.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/ui_helper.dart';
import '../../../../shared/utils/widget/add_info_widget.dart';
import '../../../../shared/utils/widget/custom_app_bar.dart';
import '../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../../shared/utils/widget/custom_image.dart';
import '../../../../shared/utils/widget/custom_textfield.dart';
import '../../../../shared/utils/widget/dropdowns/search_dropdown.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../../shared/utils/widget/snackbar/custom_snackbar.dart';
import '../../../router/router_helper.dart';
import '../data/business_details.dart';
import '../domain/parties/parties_bloc.dart';

class AddPartyScreen extends StatefulHookWidget {
  final PartyModel? partyModel;

  const AddPartyScreen({super.key, required this.partyModel});

  @override
  State<AddPartyScreen> createState() => _AddPartyScreenState();
}

class _AddPartyScreenState extends State<AddPartyScreen> {
  final TextEditingController _partyNameController = TextEditingController();
  final TextEditingController _partyEmaiController = TextEditingController();
  final TextEditingController _partyMobileController = TextEditingController();
  final TextEditingController _billingAddressController =
      TextEditingController();
  final TextEditingController _billingPinCodeController =
      TextEditingController();
  final TextEditingController _businessGstController = TextEditingController();
  final TextEditingController _businessPanController = TextEditingController();
  final ValueNotifier<BusinessDetails> businessDetailsNotifier =
      ValueNotifier(BusinessDetails.empty());
  final ValueNotifier<bool> billingExpansion = ValueNotifier(false);
  final ValueNotifier<bool> businessExpansion = ValueNotifier(false);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _partyNameController.text = widget.partyModel?.partyName ?? '';
    _partyEmaiController.text = widget.partyModel?.email ?? '';
    _partyMobileController.text = widget.partyModel?.phone ?? '';
    _businessPanController.text = widget.partyModel?.pan ?? '';
    _businessGstController.text = widget.partyModel?.gstin ?? '';
    _billingAddressController.text = widget.partyModel?.businessAddress ?? '';
    _billingPinCodeController.text = widget.partyModel?.pinCode ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _partyNameController.dispose();
    _partyEmaiController.dispose();
    _partyMobileController.dispose();
    _billingAddressController.dispose();
    _billingPinCodeController.dispose();
    _businessGstController.dispose();
    _businessPanController.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final partyType = widget.partyModel?.id != null
        ? useState<PartyType>(widget.partyModel!.type)
        : useState<PartyType>(PartyType.customer);
    final selectState = useState<String>(widget.partyModel?.state ?? '');
    final selectCity = useState<String>(widget.partyModel?.city ?? '');
    final size = MediaQuery.of(context).size;
    final states =
        getIt.get<IndianStatesData>().state.map((st) => st.name).toList();
    final cities = selectState.value.isNotEmpty
        ? getIt
            .get<IndianStatesData>()
            .state
            .firstWhere((st) => st.name == selectState.value)
            .city
            .map((st) => st.name)
            .toList()
        : <String>[];
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: 'Add New Party',
          child: Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: CustomImageView(
                  imagePath: ImageConstants.importIcon,
                  fit: BoxFit.contain,
                  height: 18.px,
                  width: 18.px,
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Text(
                'Import',
                style: AppTextStyle.pw400White.copyWith(fontSize: 14.px),
              ),
              SizedBox(
                width: 5.w,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocListener<PartiesBloc, PartiesState>(
            listener: (context, state) {
              if (state is GSTValidationFailed) {
                showErrorSnackBar(context: context, message: state.reason);
              }
              if (state is GSTValidationSuccess) {
                _businessGstController.text = state.data.data?.gstin ?? '';
                _billingPinCodeController.text =
                    state.data.data?.pradr?.addr?.pncd ?? '';
                var st = state.data.data?.pradr?.addr?.st ?? '';
                final stateExists =
                    states.any((s) => s.toLowerCase() == st.toLowerCase());
                if (stateExists) {
                  selectState.value = st;
                  var city = state.data.data?.pradr?.addr?.city ?? '';
                  var cities = selectState.value.isNotEmpty
                      ? getIt
                          .get<IndianStatesData>()
                          .state
                          .firstWhere((st) => st.name == selectState.value)
                          .city
                          .map((st) => st.name)
                          .toList()
                      : <String>[];
                  final cityExists =
                      cities.any((c) => c.toLowerCase() == city.toLowerCase());
                  if (city.isNotEmpty && cityExists) {
                    selectCity.value = city;
                  }
                }
              }
              if (state is PartyOperationSuccess) {
                showSuccessSnackBar(context: context, message: 'Party Added Successfully');
                RouterHelper.pop<void>(context);
              }
              if (state is PartyUpdateOperationSuccess) {
                showSuccessSnackBar(context: context, message: 'Party Updated Successfully');
                RouterHelper.pop<void>(context);
              }
              if (state is PartyOperationFailed) {
                showErrorSnackBar(context: context, message: state.reason);
                RouterHelper.pop<void>(context);
              }
              if (state is PartyUpdateOperationFailed) {
                showErrorSnackBar(context: context, message: state.reason);
                RouterHelper.pop<void>(context);
              }
            },
            child: Container(
              height: size.height,
              width: size.width,
              color: AppColor.white,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Basic Details',
                              style: AppTextStyle.pw600.copyWith(
                                  color: AppColor.black, fontSize: 16.px),
                            ),
                            SizedBox(height: 2.h),
                            CustomTextfield(
                              hint: 'Party Name',
                              validator: (value) =>
                                  InputValidator.hasValue<String>(value),
                              controller: _partyNameController,
                              lable: 'Party Name',
                              obsecure: false,
                            ),
                            SizedBox(height: 2.h),
                            CustomTextfield(
                              keyboardType: TextInputType.phone,
                              hint: 'Mobile Number',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Input is required';
                                } else if (value.length != 10) {
                                  return 'Mobile Number should be 10 digits';
                                }
                                return null;
                              },
                              controller: _partyMobileController,
                              lable: 'Mobile Number',
                              obsecure: false,
                            ),
                            SizedBox(height: 2.h),
                            CustomTextfield(
                              keyboardType: TextInputType.emailAddress,
                              hint: 'Email',
                              validator: (value) =>
                                  InputValidator.hasValue<String>(value),
                              controller: _partyEmaiController,
                              lable: 'Email',
                              obsecure: false,
                            ),
                            SizedBox(height: 2.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Who are they?',
                                  style: AppTextStyle.pw600.copyWith(
                                    color: AppColor.black,
                                    fontSize: 14.px,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Radio<PartyType>(
                                            value: PartyType.customer,
                                            groupValue: partyType.value,
                                            fillColor: WidgetStateProperty
                                                .resolveWith<Color>((states) {
                                              if (states.contains(
                                                  WidgetState.selected)) {
                                                return Colors.blue;
                                              }
                                              return Colors.grey;
                                            }),
                                            onChanged: (value) {
                                              if (value != null)
                                                partyType.value = value;
                                            },
                                          ),
                                          Text(
                                            'Customer',
                                            style: AppTextStyle.pw600.copyWith(
                                              color: AppColor.black,
                                              fontSize: 14.px,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 16),
                                      Row(
                                        children: [
                                          Radio<PartyType>(
                                            value: PartyType.supplier,
                                            groupValue: partyType.value,
                                            fillColor: WidgetStateProperty
                                                .resolveWith<Color>((states) {
                                              if (states.contains(
                                                  WidgetState.selected)) {
                                                return Colors.blue;
                                              }
                                              return Colors.grey;
                                            }),
                                            onChanged: (value) {
                                              if (value != null)
                                                partyType.value = value;
                                            },
                                          ),
                                          Text(
                                            'Supplier',
                                            style: AppTextStyle.pw600.copyWith(
                                              color: AppColor.black,
                                              fontSize: 14.px,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.h),
                      const Divider(
                        thickness: 2,
                        color: AppColor.greyContainer,
                      ),
                      SizedBox(height: 1.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: ValueListenableBuilder(
                            valueListenable: businessExpansion,
                            builder: (context, value, child) {
                              return Column(
                                children: [
                                  AddInfoWidget(
                                    title: 'Business Info(Optional)',
                                    onTap: () {
                                      businessExpansion.value =
                                          !businessExpansion.value;
                                    },
                                  ),
                                  if (value)
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        CustomTextfield(
                                          inputFormatters: [
                                            UpperCaseTextFormatter(),
                                          ],
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          controller: _businessGstController,
                                          lable: 'GST Number',
                                          hint: 'GST Number',
                                          textInputAction: TextInputAction.next,
                                          onFieldSubmitted: (value) {
                                            if (value.isNotEmpty) {
                                              context.read<PartiesBloc>().add(
                                                    OnValidateGSTNumber(
                                                      gstin: value,
                                                    ),
                                                  );
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        CustomTextfield(
                                          inputFormatters: [
                                            UpperCaseTextFormatter(),
                                          ],
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          controller: _businessPanController,
                                          lable: 'PAN Number',
                                          hint: 'PAN Number',
                                        )
                                      ],
                                    )
                                ],
                              );
                            }),
                      ),
                      SizedBox(height: 1.h),
                      const Divider(
                        thickness: 2,
                        color: AppColor.greyContainer,
                      ),
                      SizedBox(height: 1.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: ValueListenableBuilder(
                          valueListenable: billingExpansion,
                          builder: (context, value, child) {
                            return Column(
                              children: [
                                AddInfoWidget(
                                    title: 'Billing Address',
                                    onTap: () {
                                      billingExpansion.value =
                                          !billingExpansion.value;
                                    }),
                                value
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          CustomTextfield(
                                            controller:
                                                _billingAddressController,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter address';
                                              }
                                              return null;
                                            },
                                            lable: 'Address',
                                            hint: 'Address',
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          CustomTextfield(
                                            keyboardType: TextInputType.number,
                                            controller:
                                                _billingPinCodeController,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter pin code';
                                              } else if (value.length != 6) {
                                                return 'Invalid pin code';
                                              }
                                              return null;
                                            },
                                            lable: 'PinCode',
                                            hint: 'PinCode',
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          AutoCompleteInput(
                                            textInputAction:
                                                TextInputAction.next,
                                            showAvatar: false,
                                            showPrefix: false,
                                            direction:
                                                OptionsViewOpenDirection.up,
                                            items: states,
                                            label: 'State',
                                            hint: 'State',
                                            fillColor: Colors.transparent,
                                            initialValue: '',
                                            onSelected: (p0) {
                                              if (p0.isNotEmpty) {
                                                selectState.value = p0;
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          if (selectState.value.isNotEmpty)
                                            AutoCompleteInput(
                                              textInputAction:
                                                  TextInputAction.done,
                                              showAvatar: false,
                                              showPrefix: false,
                                              items: cities,
                                              direction:
                                                  OptionsViewOpenDirection.up,
                                              fillColor: Colors.transparent,
                                              label: 'City',
                                              hint: 'City',
                                              initialValue: '',
                                              onSelected: (p0) {
                                                if (p0.isNotEmpty) {
                                                  selectCity.value = p0;
                                                }
                                              },
                                            ),
                                        ],
                                      )
                                    : const SizedBox(),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 1.h),
                      const Divider(
                        thickness: 2,
                        color: AppColor.greyContainer,
                      ),
                      SizedBox(height: 1.h),
                      CustomElevatedButton(
                        text: 'Save',
                        height: 44.px,
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        onTap: () => _onSaveParty(partyType.value,
                            selectState.value, selectCity.value),
                      ),
                      SizedBox(height: 5.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSaveParty(
      PartyType partyType, String selectedState, String selectedCity) async {
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      logger.d('formState validation failed');
      return;
    }
    if (selectedState.isEmpty) {
      showErrorSnackBar(context: context, message:  'select billing State');
      return;
    }
    if (selectedCity.isEmpty) {
      showErrorSnackBar(context: context, message:  'select billing city');
      return;
    }

    final partyName = _partyNameController.text;
    final partyMobile = _partyMobileController.text;
    final partyEmail = _partyEmaiController.text;
    if (widget.partyModel?.id != null) {
      context.read<PartiesBloc>().add(
            OnUpdateParty(
              partyModel: PartyModel(
                id: widget.partyModel?.id ?? '',
                partyName: partyName,
                type: partyType,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                phone: partyMobile,
                email: partyEmail,
                gstin: _businessGstController.text,
                pan: _businessPanController.text,
                status: '',
                businessAddress: _billingAddressController.text,
                pinCode: _billingPinCodeController.text,
                state: selectedState,
                city: selectedCity,
              ),
            ),
          );
    } else {
      context.read<PartiesBloc>().add(
            OnAddParty(
              partyModel: PartyModel(
                partyName: partyName,
                type: partyType,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                phone: partyMobile,
                email: partyEmail,
                gstin: _businessGstController.text,
                pan: _businessPanController.text,
                businessAddress: _billingAddressController.text,
                pinCode: _billingPinCodeController.text,
                state: selectedState,
                city: selectedCity,
                status: '',
              ),
            ),
          );
    }
  }
}
