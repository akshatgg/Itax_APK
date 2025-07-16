import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/strings_constants.dart';
import '../../../core/data/apis/models/company/company_model.dart';
import '../../../core/data/indian_states.dart';
import '../../../core/utils/get_it_instance.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/utils/widget/custom_app_bar.dart';
import '../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../shared/utils/widget/custom_textfield.dart';
import '../../../shared/utils/widget/dropdowns/search_dropdown.dart';
import '../../../shared/utils/widget/gradient_widget.dart';
import '../../../shared/utils/widget/select_image.dart';
import '../../../shared/utils/widget/snackbar/custom_snackbar.dart';
import '../../router/router_helper.dart';
import 'domain/company_bloc.dart';

class MoreAddCompany extends StatefulHookWidget {
  final CompanyModel? companyModel;

  const MoreAddCompany({super.key, this.companyModel});

  @override
  State<MoreAddCompany> createState() => _MoreAddCompanyState();
}

class _MoreAddCompanyState extends State<MoreAddCompany> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyPhoneController = TextEditingController();
  final TextEditingController _companyEmailController = TextEditingController();
  final TextEditingController _companyAddressController =
      TextEditingController();
  final TextEditingController _companyPinCodeController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _companyNameController.text = widget.companyModel?.companyName ?? '';
    _companyPinCodeController.text = widget.companyModel?.companyPincode ?? '';
    _companyAddressController.text = widget.companyModel?.companyAddress ?? '';
    _companyPhoneController.text = widget.companyModel?.companyPhone ?? '';
    _companyEmailController.text = widget.companyModel?.companyEmail ?? '';
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyPhoneController.dispose();
    _companyEmailController.dispose();
    _companyAddressController.dispose();
    _companyPinCodeController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasCompany = context.watch<CompanyBloc>().currentCompany != null;
    final selectState =
        useState<String>(widget.companyModel?.companyState ?? '');
    final selectedImageData = useState<File?>(null);
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: AppStrings.addCompany,
          showBackButton: hasCompany,
        ),
        body: BlocListener<CompanyBloc, CompanyState>(
          listener: (context, state) {
            if (state is CompanyOperationSuccess) {
              CustomSnackBar.showSnack(
                context: context,
                snackBarType: SnackBarType.success,
                message: AppStrings.addCompanySuccess,
              );
              context.read<CompanyBloc>().add(const OnGetCompany());
              RouterHelper.pop<void>(context);
            }
            if (state is CompanyOperationFailed) {
              CustomSnackBar.showSnack(
                context: context,
                snackBarType: SnackBarType.success,
                message: AppStrings.addCompanyFailed,
              );
            }
          },
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: AppColor.white,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      height: 160.px,
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: AppColor.greyContainer,
                          borderRadius: BorderRadius.circular(4.px)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (selectedImageData.value != null)
                            Stack(
                              children: [
                                Container(
                                  height: 160.px,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: AppColor.greyContainer,
                                    borderRadius: BorderRadius.circular(4.px),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4.px),
                                    child: Image.file(
                                      selectedImageData.value!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: AppColor.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        selectedImageData.value = null;
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: AppColor.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Center(
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    height: 85.px,
                                    width: 85.px,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFC6C6C6),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: AppColor.white,
                                      size: 80.px,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      File? selectedImage =
                                          await pickImage(context);
                                      if (selectedImage != null) {
                                        selectedImageData.value = selectedImage;
                                      }
                                    },
                                    child: Container(
                                      height: 25.px,
                                      width: 25.px,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.appColor,
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        color: AppColor.white,
                                        size: 20.px,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        children: [
                          CustomTextfield(
                            keyboardType: TextInputType.name,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return AppStrings.emptyCompanyName;
                              }
                              return null;
                            },
                            controller: _companyNameController,
                            lable: AppStrings.labelCompanyName,
                            hint: AppStrings.hintCompanyName,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          CustomTextfield(
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.emailEmpty; // Error message
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return AppStrings.emailEnterValid;
                              }
                              return null;
                            },
                            controller: _companyEmailController,
                            lable: AppStrings.labelCompanyEmail,
                            hint: AppStrings.hintCompanyEmail,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          CustomTextfield(
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppStrings.enterCompanyPhoneNumber;
                              }
                              return null;
                            },
                            controller: _companyPhoneController,
                            lable: AppStrings.labelCompanyPhoneNumber,
                            hint: AppStrings.hintCompanyPhoneNumber,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          CustomTextfield(
                            keyboardType: TextInputType.streetAddress,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return AppStrings.enterCompanyAddress;
                              }
                              return null;
                            },
                            controller: _companyAddressController,
                            maxLine: 3,
                            lable: AppStrings.labelCompanyAddress,
                            hint: AppStrings.hintCompanyAddress,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          AutoCompleteInput(
                            textInputAction: TextInputAction.next,
                            showAvatar: false,
                            showPrefix: false,
                            direction: OptionsViewOpenDirection.up,
                            items: getIt
                                .get<IndianStatesData>()
                                .state
                                .map((st) => st.name)
                                .toList(),
                            label: AppStrings.labelCompanyState,
                            hint: AppStrings.hintCompanyState,
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
                          CustomTextfield(
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return AppStrings.enterCompanyPincode;
                              }
                              return null;
                            },
                            controller: _companyPinCodeController,
                            lable: AppStrings.labelCompanyPinCode,
                            hint: AppStrings.hintCompanyPinCode,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          CustomElevatedButton(
                            onTap: () => _onSavePressed(
                              selectState.value,
                              selectedImageData.value,
                            ),
                            text: AppStrings.save,
                            height: 45.px,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSavePressed(String state, File? imageBytes) async {
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      logger.d(AppStrings.formStateValidationFailed);
      return;
    }
    final companyBloc = context.read<CompanyBloc>();
    if (widget.companyModel?.id != null) {
      companyBloc.add(
        OnUpdateCompany(
          companyModel: CompanyModel(
            id: widget.companyModel?.id ?? '',
            companyState: state,
            companyName: _companyNameController.text,
            companyPhone: _companyPhoneController.text,
            companyEmail: _companyEmailController.text,
            companyAddress: _companyAddressController.text,
            companyPincode: _companyPinCodeController.text,
          ),
          companyImage: imageBytes,
        ),
      );
    } else {
      companyBloc.add(
        OnAddCompany(
          companyModel: CompanyModel(
            companyState: state,
            companyName: _companyNameController.text,
            companyPhone: _companyPhoneController.text,
            companyEmail: _companyEmailController.text,
            companyAddress: _companyAddressController.text,
            companyPincode: _companyPinCodeController.text,
          ),
          companyImage: imageBytes,
        ),
      );
    }
  }
}
