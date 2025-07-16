import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/constants/strings_constants.dart';
import '../../../../core/data/repos/shared_prefs/last_login.dart';
import '../../../../core/data/repos/shared_prefs/shared_pref_repo.dart';
import '../../../../core/utils/get_it_instance.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/network_utils.dart';
import '../../../../core/utils/ui_helper.dart';
import '../../../../presentation/router/router_helper.dart';
import '../../../../presentation/router/routes.dart';
import '../../../../shared/utils/widget/check_widget.dart';
import '../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../../shared/utils/widget/custom_image.dart';
import '../../../../shared/utils/widget/custom_textfield.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../../shared/utils/widget/snackbar/custom_snackbar.dart';
import '../../company/domain/company_bloc.dart';
import '../../company/domain/company_bloc.dart' as auth show ProcessLoading;
import '../domain/bloc/auth_bloc.dart';
import 'widgets/custom_bottom_sheet.dart';

class LoginScreen extends StatefulHookWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _forgetPswController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<OtpPinFieldState> _otpController = GlobalKey();
  final GlobalKey<FormState> _forgetPasswordformKey = GlobalKey();
  late final SharedPrefRepository _sharedPrefRepo;

  @override
  void initState() {
    _sharedPrefRepo = getIt.get<SharedPrefRepository>();
    super.initState();
    getLastLogin();
  }

  void getLastLogin() async {
    await _sharedPrefRepo.getLastLoginInfo();
    if (_sharedPrefRepo.lastLogin != null) {
      _emailController.text = _sharedPrefRepo.lastLogin!.email;
      _passwordController.text = _sharedPrefRepo.lastLogin!.password;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _forgetPswController.dispose();
    _otpController.currentState?.dispose();
    _forgetPasswordformKey.currentState?.dispose();
    _formKey.currentState?.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doRemember = useState<bool>(false);
    final isLoginDisabled = useState<bool>(false);
    final isSendOtpDisabled = useState<bool>(false);
    final isVerifyOtpDisabled = useState<bool>(false);
    final isGoogleLoginDisabled = useState<bool>(false);
    final isFacebookLoginDisabled = useState<bool>(false);
    return PopScope(
      canPop: false,
      child: GradientContainer(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(AppStrings.login, style: AppTextStyle.pw600),
              backgroundColor: Colors.transparent,
            ),
            body: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.px),
                  topRight: Radius.circular(40.px),
                ),
              ),
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 5.w,
                        right: 5.w,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is LoggedInSuccess) {
                                context.go(AppRoutes.dashboardView.path);
                              }else if(state is LoggedInFailure){
                                isLoginDisabled.value = false; // Re-enable login button

                                showErrorSnackBar(context: context, message: state.reason);
                              }else if(state is OtpSent){
                                isLoginDisabled.value = false; // Re-enable login button
                                _onOtpSent(context, isVerifyOtpDisabled, false);
                              }
                            },
                            builder: (context, state) {
                              final isLoading = state is ProcessLoading;
                              return Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 2.h),
                                      Text(
                                        'Welcome Back',
                                        style: AppTextStyle.pw600.copyWith(
                                          color: AppColor.appColor,
                                          fontSize: 24.px,
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                      Text(
                                        'Welcome Back! Access Your Dashboard Securely',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.pw400Gray
                                            .copyWith(fontSize: 12.px),
                                      ),
                                      SizedBox(height: 3.h),
                                      Center(
                                        child: CustomImageView(
                                          imagePath: ImageConstants.loginImage,
                                          height: 160.px,
                                          width: 160.px,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            CustomTextfield(
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              lable: 'Email',
                                              hint: 'Email',
                                              controller: _emailController,
                                              focusNode: emailFocusNode,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter your email';
                                                }

                                                // Corrected regex pattern (removed trailing backslash and dollar sign)
                                                final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                                                if (!emailRegex.hasMatch(value)) {
                                                  return 'Email is not valid';
                                                }

                                                return null;
                                              },
                                            ),
                                            SizedBox(height: 2.h),
                                            CustomTextfield(
                                              obsecure: true,
                                              hint: 'Password',
                                              lable: 'Password',
                                              controller: _passwordController,
                                              focusNode: passwordFocusNode,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter your password';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          CheckWidget(
                                            title: 'Remember me',
                                            value: doRemember.value,
                                            onChanged: (val) {
                                              if (val != null) {
                                                doRemember.value = val;
                                              }
                                            },
                                          ),
                                          GestureDetector(
                                            onTap: () => _onForgetPassword(
                                                context, isSendOtpDisabled),
                                            child: Text(
                                              'Forgot Password?',
                                              style: AppTextStyle.pw500.copyWith(
                                                  color: AppColor.appColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2.h),
                                      CustomElevatedButton(
                                        onTap: () => _onLoginPressed(
                                            doRemember.value, isLoginDisabled),
                                        text: 'Login',
                                        height: 44.px,
                                        isDisabled: isLoginDisabled.value,
                                      ),
                                      SizedBox(height: 2.h),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            const Expanded(child: Divider()),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.w),
                                              child: Text(
                                                "Don't have an account? ",
                                                style: AppTextStyle.pw400,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => RouterHelper.push(
                                                  context, AppRoutes.signup.name),
                                              child: Text(
                                                'Sign Up',
                                                style: AppTextStyle.pw600.copyWith(
                                                  color: AppColor.appColor,
                                                  fontSize: 14.px,
                                                ),
                                              ),
                                            ),
                                            const Expanded(child: Divider()),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () => _onGooglePressed(
                                                isGoogleLoginDisabled),
                                            child: Container(
                                              width: 150.px,
                                              height: 50.px,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(10.px),
                                                  border: Border.all(
                                                      color: Colors.black
                                                          .withAlpha(100))),
                                              child: isGoogleLoginDisabled.value
                                                  ? const CircularProgressIndicator()
                                                  : CustomImageView(
                                                imagePath:
                                                ImageConstants.googleLogo,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => {},
                                            child: Container(
                                              width: 150.px,
                                              height: 50.px,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(10.px),
                                                  border: Border.all(
                                                      color: Colors.black
                                                          .withAlpha(100))),
                                              child: isFacebookLoginDisabled.value
                                                  ? const CircularProgressIndicator()
                                                  : CustomImageView(
                                                imagePath: ImageConstants.facebookLogo,
                                                height: 24.px,
                                                width: 24.px,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2.h),
                                    ],
                                  ),
                                  // 🔁 Loader Overlay
                                  if (isLoading)
                                    Positioned.fill(
                                      child: Container(
                                        color: Colors.black.withOpacity(0.0),
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onForgetPassword(
    BuildContext context,
    ValueNotifier<bool> isSendOtpDisabled,
  ) {
    passwordFocusNode.unfocus();
    emailFocusNode.unfocus();
    CustomBottomSheet.showCustomBottomSheet(
      formKey: _forgetPasswordformKey,
      bottomSheetData: [
        BottomSheetData(
          controller: _forgetPswController,
          hint: AppStrings.emailHint,
        ),
      ],
      buttonText: AppStrings.sendEmail,
      context: context,
      onButtonClicked: () {
        if (_forgetPasswordformKey.currentState != null &&
            !_forgetPasswordformKey.currentState!.validate()) {
          logger.d('formState validation failed');
          return;
        }
        final email = _forgetPswController.text.trim();
        if (email.isEmpty) {
          showErrorSnackBar(context: context, message:  AppStrings.emailEmpty);
          return;
        }
        isSendOtpDisabled.value = true;
        final authBloc = context.read<AuthBloc>();
        authBloc.add(OnForgotPassword(email: email));
      },
      title: AppStrings.forgotPasswordTitle,
      subtitle: AppStrings.forgotPasswordSubtitle,
      isDisabled: isSendOtpDisabled.value,
    );
  }

  void _onOtpSent(
    BuildContext context,
    ValueNotifier<bool> isVerifyOtpDisabled,
    bool isForgettingPassword,
  ) {
    CustomBottomSheet.showOtpBottomSheet(
      onResend: () => _onVerifyOtpClicked(
          context, isVerifyOtpDisabled, isForgettingPassword),
      buttonText: AppStrings.verifyOtp,
      context: context,
      onButtonClicked: () => _onVerifyOtpClicked(
          context, isVerifyOtpDisabled, isForgettingPassword),
      subtitle: AppStrings.otpInstruction,
      isDisabled: isVerifyOtpDisabled.value,
      controller: _otpController,
    );
  }

  Future<void> _onVerifyOtpClicked(
    BuildContext context,
    ValueNotifier<bool> isVerifyOtpDisabled,
    bool isForgettingPassword,
  ) async {
    logger.d(' _onVerifyOtpClicked');
    if (_otpController.currentState == null) {
      logger.d('formState validation failed');
      return;
    }
    final codeList = _otpController.currentState!.pinsInputed;
    logger.d(codeList);
    String code = '';
    for (var element in codeList) {
      code += element;
    }
    if (code.isEmpty || code.length != 4) {
      showErrorSnackBar(context: context, message:  AppStrings.otpError);
      return;
    }
    String email = isForgettingPassword
        ? _forgetPswController.text.trim()
        : _emailController.text.trim();

    context.read<AuthBloc>().add(OnVerifyOtp(
          otp: code,
          email: email,
          isForgettingPassword: isForgettingPassword,
        ));

    RouterHelper.push(
        context, AppRoutes.dashboardView.name);

  }

  Future<void> _onLoginPressed(
    bool doRemember,
    ValueNotifier<bool> isLoginDisable,
  ) async {
    FocusScope.of(context).unfocus();

    final isConnected = await NetworkUtils.isConnected();
    if (!isConnected) {
      showErrorSnackBar(context: context, message:  'No internet connection. Please check your network.');
      return;
    }

    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      logger.d('formState validation failed');
      return;
    }
    isLoginDisable.value = true;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final authBloc = context.read<AuthBloc>();
    logger.d('OnLoginPressed $email $password');
    authBloc.add(OnLoginEmailPassword(email: email, password: password));
  }

  Future<void> _onGooglePressed(
    ValueNotifier<bool> isLoginDisable,
  ) async {
    isLoginDisable.value = true;
    final authBloc = context.read<AuthBloc>();
    authBloc.add(OnSignWithGoogle());
  }

  Future<void> _onLoginSuccess(
    bool doRemember,
  ) async {
    logger.d('otp success');
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (doRemember) {
      _sharedPrefRepo.saveLastLogin(
        LastLogin(
          email: email,
          password: password,
        ),
      );
    }

    final company = context.read<CompanyBloc>().currentCompany;
    logger.d(company);
    if (company == null) {
      RouterHelper.push(context, AppRoutes.profile.name);
    } else {
      RouterHelper.push(context, AppRoutes.dashboardView.name);
    }

    _emailController.clear();
    _passwordController.clear();
  }
}
