import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/data/apis/models/company/company_model.dart';
import '../../../../core/data/apis/models/shared/user_model.dart';
import '../../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../../shared/utils/widget/custom_app_bar.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../../shared/utils/widget/select_image.dart';
import '../../../router/router_helper.dart';
import '../../../router/routes.dart';
import '../../company/domain/company_bloc.dart';
import '../domain/user_bloc.dart';
import '../domain/user_event.dart';
import '../domain/user_state.dart';
import 'widget/business_detail_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _adharController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _addressFlatController = TextEditingController();
  final TextEditingController _addressBController = TextEditingController();
  final TextEditingController _addressBnController = TextEditingController();
  final TextEditingController _addressStreetController =
      TextEditingController();
  final TextEditingController _addressAController = TextEditingController();
  final TextEditingController _addressCityController = TextEditingController();
  final TextEditingController _addressStateController = TextEditingController();

  UserBloc? userBloc;
  String? userId;

  Uint8List? existingUserImage;
  ValueNotifier<BusinessModel?> business = ValueNotifier<BusinessModel?>(null);

  @override
  void initState() {
    super.initState();
    // Initialize tab controller first
    _tabController = TabController(length: 2, vsync: this);
    context.read<UserBloc>().add(LoadUserEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            title: 'Profile',
            onBackTap: () =>
                GoRouter.of(context).go(AppRoutes.dashboardView.path),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Tab Bar
                Container(
                  color: AppColor.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppColor.appColor,
                    unselectedLabelColor: AppColor.darkGrey,
                    indicatorColor: AppColor.appColor,
                    indicatorWeight: 2.0,
                    tabs: const [
                      Tab(text: 'User Profile'),
                      Tab(text: 'Business Profile'),
                    ],
                  ),
                ),

                // Tab Content
                Expanded(
                  child: Container(
                    color: AppColor.white,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // User Profile Tab
                        _buildUserProfileTab(context),

                        // Business Profile Tab
                        _buildBusinessProfileTab(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileTab(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoadedState) {
          _initializeControllers(state.user);
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoadedState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Container(
                    height: 160.px,
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColor.greyContainer,
                      borderRadius: BorderRadius.circular(4.px),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                child: state.user.userImage != null &&
                                        state.user.userImage!.isNotEmpty
                                    ? ClipOval(
                                        child: Image.memory(
                                          state.user.userImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Icon(
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
                                    Uint8List imageBytes =
                                        await selectedImage.readAsBytes();
                                    _onSavePressed(imageBytes);
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
                        SizedBox(height: 1.h),
                        Text(
                          state.user.firstName,
                          style: AppTextStyle.pw700.copyWith(
                            fontSize: 16.px,
                            color: AppColor.darkGrey,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  headingWidget(title: 'Personal Info'),
                  detailWidget(
                    onTap: () {
                      changeDetailBottomSheet(
                        context,
                        onSave: () => _onSavePressed(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your name';
                          }
                          return null;
                        },
                        controller: _nameController,
                        desc: 'Enter your name',
                        title: 'Change Name',
                        hint: 'Name',
                        lable: 'Name',
                      );
                    },
                    desc: _nameController.text,
                    heading: 'Name',
                  ),
                  dividerWidget(),
                  detailWidget(
                    onTap: () {
                      changeDetailBottomSheet(
                        context,
                        onSave: () => _onSavePressed(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (value.length != 10) {
                            return 'Please enter valid phone number';
                          }
                          return null;
                        },
                        controller: _phoneController,
                        desc:
                            'Enter your Mobile Number To secure your account.',
                        title: 'Change Mobile Number',
                        hint: 'Mobile Number',
                        lable: 'Mobile Number',
                      );
                    },
                    desc: _phoneController.text,
                    heading: 'Mobile Number',
                  ),
                  dividerWidget(),
                  detailWidget(
                    onTap: () {
                      changeDetailBottomSheet(
                        context,
                        onSave: () => _onSavePressed(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        controller: _emailController,
                        desc: 'Enter your email To secure your account.',
                        title: 'Change Email',
                        hint: 'Email',
                        lable: 'Email',
                      );
                    },
                    desc: _emailController.text,
                    heading: 'Email',
                  ),
                  dividerWidget(),
                  detailWidget(
                    onTap: () {
                      changeDetailBottomSheet(
                        context,
                        onSave: () => _onSavePressed(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your pan number';
                          }
                          return null;
                        },
                        controller: _panController,
                        desc: 'Enter your PAN Number',
                        title: 'Add PAN Number',
                        hint: 'PAN Number',
                        lable: 'PAN Number',
                      );
                    },
                    desc: _panController.text.isEmpty
                        ? 'PAN Number'
                        : _panController.text,
                    heading: 'PAN Number',
                  ),
                  dividerWidget(),
                  detailWidget(
                    onTap: () {
                      changeDetailBottomSheet(
                        context,
                        onSave: () => _onSavePressed(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Aadhar number';
                          }
                          return null;
                        },
                        controller: _adharController,
                        desc: 'Enter your Aadhar Number',
                        title: 'Add Aadhar Number',
                        hint: 'Aadhar Number',
                        lable: 'Aadhar Number',
                      );
                    },
                    desc: _adharController.text.isEmpty
                        ? 'Aadhar Number'
                        : _adharController.text,
                    heading: 'Aadhar Number',
                  ),
                  headingWidget(title: 'Address Info'),
                  detailWidget(
                    onTap: () {
                      changeAddressDialog(
                        context,
                        onSave: () => _onSavePressed(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                        controllerF: _addressFlatController,
                        controllerA: _addressAController,
                        controllerB: _addressBController,
                        controllerBn: _addressBnController,
                        controllerC: _addressCityController,
                        controllerS: _addressStreetController,
                        controllerState: _addressStateController,
                        title: 'Add Address',
                      );
                    },
                    desc: 'Address Detail',
                    heading: '',
                  ),
                  headingWidget(title: 'Business Info'),
                  detailWidget(
                    onTap: () {
                      changeDetailBottomSheet(
                        context,
                        onSave: () => _onSavePressed(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your gst number';
                          }
                          return null;
                        },
                        controller: _gstController,
                        desc: 'Enter your GST Number',
                        title: 'Add GST Number',
                        hint: 'GST Number',
                        lable: 'GST Number',
                      );
                    },
                    desc: _gstController.text.isEmpty
                        ? 'GST Number'
                        : _gstController.text,
                    heading: 'GST Number',
                  ),
                  headingWidget(title: 'Business Details'),
                  detailWidget(
                    onTap: () async {
                      await showModalBottomSheet<BusinessModel>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: BusinessDetailSheet(
                            gstValue: _gstController.text,
                            panValue: _panController.text,
                            business: business.value,
                            onSave: (BusinessModel businessDetails) {
                              business.value = businessDetails;
                              _onSavePressed();
                              _onSavePressedCompany();
                            },
                          ),
                        ),
                      );
                    },
                    desc: 'Business Details',
                    heading: '',
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            );
          } else if (state is UserErrorState) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(child: Text('No data found'));
        },
      ),
    );
  }

  Widget _buildBusinessProfileTab() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserLoadedState) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Business Profile Header
                SizedBox(height: 2.h),
                Container(
                  height: 160.px,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColor.greyContainer,
                    borderRadius: BorderRadius.circular(4.px),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                                Icons.business,
                                color: AppColor.white,
                                size: 40.px,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                // Add business logo functionality
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
                      SizedBox(height: 1.h),
                      Text(
                        state.user.businessName.isNotEmpty
                            ? state.user.businessName
                            : 'Business Name',
                        style: AppTextStyle.pw700.copyWith(
                          fontSize: 16.px,
                          color: AppColor.darkGrey,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 2.h),

                // Business Information
                headingWidget(title: 'Business Information'),
                detailWidget(
                  onTap: () {
                    // Edit business name
                  },
                  desc: state.user.businessName.isNotEmpty
                      ? state.user.businessName
                      : 'Not provided',
                  heading: 'Business Name',
                ),
                dividerWidget(),
                detailWidget(
                  onTap: () {
                    // Edit trade name
                  },
                  desc: state.user.tradeName.isNotEmpty
                      ? state.user.tradeName
                      : 'Not provided',
                  heading: 'Trade Name',
                ),
                dividerWidget(),
                detailWidget(
                  onTap: () {
                    changeDetailBottomSheet(
                      context,
                      onSave: () => _onSavePressed(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your gst number';
                        }
                        return null;
                      },
                      controller: _gstController,
                      desc: 'Enter your GST Number',
                      title: 'Add GST Number',
                      hint: 'GST Number',
                      lable: 'GST Number',
                    );
                  },
                  desc: state.user.gst.isNotEmpty
                      ? state.user.gst
                      : 'Not provided',
                  heading: 'GST Number',
                ),
                dividerWidget(),
                detailWidget(
                  onTap: () {
                    changeDetailBottomSheet(
                      context,
                      onSave: () => _onSavePressed(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your pan number';
                        }
                        return null;
                      },
                      controller: _panController,
                      desc: 'Enter your PAN Number',
                      title: 'Add PAN Number',
                      hint: 'PAN Number',
                      lable: 'PAN Number',
                    );
                  },
                  desc: state.user.pan.isNotEmpty
                      ? state.user.pan
                      : 'Not provided',
                  heading: 'PAN Number',
                ),
                dividerWidget(),
                detailWidget(
                  onTap: () {
                    // Edit TAN number
                  },
                  desc: state.user.tan.isNotEmpty
                      ? state.user.tan
                      : 'Not provided',
                  heading: 'TAN Number',
                ),
                dividerWidget(),
                detailWidget(
                  onTap: () {
                    // Edit business status
                  },
                  desc: state.user.bStatus.isNotEmpty
                      ? state.user.bStatus
                      : 'Not provided',
                  heading: 'Status',
                ),

                // Business Address
                headingWidget(title: 'Business Address'),
                detailWidget(
                  onTap: () {
                    // Edit business address
                  },
                  desc: state.user.businessAddress.isNotEmpty
                      ? state.user.businessAddress
                      : 'Not provided',
                  heading: 'Address',
                ),
                dividerWidget(),
                detailWidget(
                  onTap: () {
                    // Edit business state
                  },
                  desc: state.user.businessState.isNotEmpty
                      ? state.user.businessState
                      : 'Not provided',
                  heading: 'State',
                ),

                // Documents Section
                headingWidget(title: 'Documents'),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.px,
                    mainAxisSpacing: 16.px,
                    childAspectRatio: 1.5,
                    children: [
                      _buildDocumentCard('GST Certificate'),
                      _buildDocumentCard('PAN Card'),
                      _buildDocumentCard('Trade License'),
                      _buildDocumentCard('Bank Details'),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),

                // Edit Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: ElevatedButton(
                    onPressed: () async {
                      await showModalBottomSheet<BusinessModel>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: BusinessDetailSheet(
                            gstValue: _gstController.text,
                            panValue: _panController.text,
                            business: business.value,
                            onSave: (BusinessModel businessDetails) {
                              business.value = businessDetails;
                              _onSavePressed();
                              _onSavePressedCompany();
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.appColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.px),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.px,
                        vertical: 12.px,
                      ),
                    ),
                    child: Text(
                      'Edit Business Details',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
              ],
            ),
          );
        } else if (state is UserErrorState) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('No data found'));
      },
    );
  }

  void _initializeControllers(UserModel user) {
    userId = user.id;
    existingUserImage = user.userImage;
    _nameController.text = user.firstName;
    _emailController.text = user.email.isNotEmpty ? user.email : 'N/A';
    _phoneController.text = user.phone.isNotEmpty ? user.phone : 'N/A';
    _panController.text = user.pan.isNotEmpty ? user.pan : 'N/A';
    _adharController.text = user.aadhaar.isNotEmpty ? user.aadhaar : 'N/A';
    _gstController.text = user.gst.isNotEmpty ? user.gst : 'N/A';
    _addressStateController.text = user.state;
    _addressCityController.text = user.city;
    _addressStreetController.text = user.street;
    _addressFlatController.text = user.flatNo;
    _addressBnController.text = user.buildingNo;
    _addressBController.text = user.buildingName;
    _addressAController.text = user.area;

    business.value = BusinessModel(
      gst: user.gst,
      pan: user.pan,
      bStatus: user.bStatus,
      bAddress: user.businessAddress,
      bName: user.businessName,
      tan: user.tan,
      tradeName: user.tradeName,
      bState: user.businessState,
    );
  }

  Widget headingWidget({required String title}) {
    return Container(
      height: 36.px,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      color: AppColor.greyContainer,
      child: Text(
        title,
        style: AppTextStyle.pw400.copyWith(
          color: AppColor.grey,
          fontSize: 16.px,
        ),
      ),
    );
  }

  Widget dividerWidget() {
    return const Column(
      children: [
        Divider(
          color: Color(0XFFF0F0F0),
        ),
      ],
    );
  }

  Widget detailWidget({
    required String heading,
    required String desc,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (heading.isNotEmpty)
                    Text(
                      heading,
                      style: AppTextStyle.pw400.copyWith(color: AppColor.grey),
                    ),
                  if (heading.isNotEmpty) SizedBox(height: 1.h),
                  Text(
                    desc,
                    style:
                        AppTextStyle.pw500.copyWith(color: AppColor.darkGrey),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColor.darkGrey,
              size: 20.px,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(String title) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.px),
        side: BorderSide(color: AppColor.greyContainer, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.px),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description, size: 30.px, color: AppColor.appColor),
            SizedBox(height: 1.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColor.darkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSavePressed([Uint8List? imageBytes]) async {
    UserModel updatedUser = UserModel(
      id: userId.toString(),
      userImage: imageBytes ?? existingUserImage,
      firstName: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      pan: _panController.text,
      city: _addressCityController.text,
      state: _addressStateController.text,
      street: _addressStreetController.text,
      flatNo: _addressFlatController.text,
      buildingNo: _addressBnController.text,
      buildingName: _addressBController.text,
      area: _addressAController.text,
      gst: _gstController.text,
      aadhaar: _adharController.text,
      businessState: business.value?.bState ?? '',
      businessName: business.value?.bName ?? '',
      businessAddress: business.value?.bAddress ?? '',
      tradeName: business.value?.tradeName ?? '',
      tan: business.value?.tan ?? '',
      bStatus: business.value?.bStatus ?? '',
    );

    context.read<UserBloc>().add(UpdateUserEvent(updatedUser));

    if (imageBytes == null) {
      RouterHelper.pop<void>(context);
    }
  }

  Future<void> _onSavePressedCompany() async {
    final company = context.read<CompanyBloc>().currentCompany;
    if (company == null) {
      context.read<CompanyBloc>().add(
            OnAddCompany(
              companyModel: CompanyModel(
                companyState: business.value?.bState ?? '',
                companyName: business.value?.bName ?? '',
                companyPhone: _phoneController.text,
                companyEmail: _emailController.text,
                companyAddress: business.value?.bAddress ?? '',
                companyPincode: '',
              ),
            ),
          );
    }
  }
}
