import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/constants/strings_constants.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/network_utils.dart';
import '../../../../core/utils/ui_helper.dart';
import '../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../../shared/utils/widget/custom_image.dart';
import '../../../../shared/utils/widget/custom_textfield.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../../shared/utils/widget/snackbar/custom_snackbar.dart';
import '../../../router/router_helper.dart';
import '../../../router/routes.dart';
import '../domain/bloc/auth_bloc.dart';
import 'widgets/custom_bottom_sheet.dart';

class SignUpScreen extends StatefulHookWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<OtpPinFieldState> _otpController = GlobalKey();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<Color> _backgroundColor =
      ValueNotifier<Color>(Colors.white);

  @override
  void initState() {
    super.initState();

    // Add listener to detect keyboard visibility changes
    _focusNode.addListener(focusListner);
  }

  void focusListner() {
    if (_focusNode.hasFocus) {
      // Keyboard is opened, change the background color to transparent or any desired color
      _backgroundColor.value = Colors.transparent;
    } else {
      // Keyboard is closed, set the background color to white
      _backgroundColor.value = Colors.white;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(focusListner);
    super.dispose();
    _focusNode.dispose();
    _backgroundColor.dispose();
    _formKey.currentState?.dispose();
    _otpController.currentState?.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSignUpDisabled = useState<bool>(false);
    final isVerifyOtpDisabled = useState<bool>(false);
    final termCondition = useState<bool>(false);
    final isGoogleLoginDisabled = useState<bool>(false);
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
              title: Text(AppStrings.signUp, style: AppTextStyle.pw600),
              backgroundColor: Colors.transparent,
            ),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.all(5.w),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.px),
                        topRight: Radius.circular(20.px))),
                child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (BuildContext context, AuthState state) {
                  logger.d('state: $state');
                  if (state is LoggedInFailure) {
                    isSignUpDisabled.value = false;
                    isVerifyOtpDisabled.value = false;
                    isGoogleLoginDisabled.value = false;
                  }
                  if (state is LoggedInSuccess) {
                    isSignUpDisabled.value = false;
                    isGoogleLoginDisabled.value = false;
                    // _onOtpSent(context, isVerifyOtpDisabled);
                    RouterHelper.push(context, AppRoutes.profile.name);
                  }
                  if (state is OtpSent) {
                    isSignUpDisabled.value = false;
                    _onOtpSent(context, isVerifyOtpDisabled);
                  }
                }, builder: (context, state) {
                  final isLoading = state is ProcessLoading;
                  return Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.welcomeToUs,
                                  style: AppTextStyle.pw600.copyWith(
                                      color: AppColor.appColor, fontSize: 24.px),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Text(
                                  AppStrings.welcomeToUsMessage,
                                  style: AppTextStyle.pw400,
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                Center(
                                  child: CustomImageView(
                                    fit: BoxFit.contain,
                                    imagePath: ImageConstants.signupImage,
                                    height: 160.px,
                                    width: 160.px,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                CustomTextfield(
                                    controller: nameController,
                                    lable: AppStrings.fullNameLabel,
                                    hint: AppStrings.fullNameHint,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return AppStrings.fullNameEmpty;
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: 2.h,
                                ),
                                CustomTextfield(
                                    controller: emailController,
                                    lable: AppStrings.emailLabel,
                                    hint: AppStrings.emailHint,
                                    validator: (value) {
                                      String p =
                                          '[a-zA-Z0-9+._%-+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+';
                                      RegExp regExp = RegExp(p);
                                      if (value!.isEmpty) {
                                        return AppStrings.emailEmpty;
                                      } else {
                                        //If email address matches pattern
                                        if (regExp.hasMatch(value)) {
                                          return null;
                                        } else {
                                          //If it doesn't match
                                          return AppStrings.emailInvalid;
                                        }
                                      }
                                    }),
                                SizedBox(
                                  height: 2.h,
                                ),
                                CustomTextfield(
                                    obsecure: true,
                                    controller: passwordController,
                                    lable: AppStrings.passwordLabel,
                                    hint: AppStrings.passwordHint,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return AppStrings.passwordEmpty;
                                      }
                                      return null;
                                    },
                                    suffixWidget: GestureDetector(
                                      child: const Icon(
                                        Icons.visibility_off_outlined,
                                        color: AppColor.grey,
                                      ),
                                    )),
                                SizedBox(
                                  height: 2.h,
                                ),
                                CustomTextfield(
                                    obsecure: true,
                                    controller: confirmPasswordController,
                                    lable: AppStrings.confPasswordLabel,
                                    hint: AppStrings.confPasswordHint,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return AppStrings.confPasswordEmpty;
                                      }
                                      if (value != passwordController.text) {
                                        return AppStrings.confPasswordDiff;
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Checkbox(
                                      fillColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                              (Set<WidgetState> states) {
                                            if (states.contains(WidgetState.selected)) {
                                              return AppColor.appColor;
                                            }
                                            return Colors.white;
                                          }),
                                      value: termCondition.value,
                                      onChanged: (val) {
                                        termCondition.value = val!;
                                      },
                                    ),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: AppStrings.creatingAccount,
                                              style: AppTextStyle.pw400,
                                            ),
                                            TextSpan(
                                              text: AppStrings.termsConditions,
                                              style: AppTextStyle.pw400.copyWith(
                                                color: AppColor.appColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                CustomElevatedButton(
                                  isDisabled: isSignUpDisabled.value,
                                  onTap: () => _onSendOtpPressed(
                                    termCondition.value,
                                    isSignUpDisabled,
                                  ),
                                  text: AppStrings.sendOtp,
                                  height: 44.px,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppStrings.haveAccount,
                                      style: AppTextStyle.pw400
                                          .copyWith(color: AppColor.black),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          RouterHelper.push(
                                              context, AppRoutes.signIn.name);
                                        },
                                        child: Text(
                                          AppStrings.login,
                                          style: AppTextStyle.pw600.copyWith(
                                              color: AppColor.appColor,
                                              fontSize: 14.px),
                                        )),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Row(
                                    children: [
                                      const Expanded(child: Divider()),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      const Text(AppStrings.orLoginWith),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      const Expanded(child: Divider()),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Center(
                                  child: GestureDetector(
                                    onTap: () =>
                                        _onGooglePressed(isGoogleLoginDisabled),
                                    child: Container(
                                      width: 150.px,
                                      height: 50.px,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10.px),
                                          border: Border.all(
                                              color: Colors.black.withAlpha(100))),
                                      child: isGoogleLoginDisabled.value
                                          ? const CircularProgressIndicator()
                                          : CustomImageView(
                                        imagePath: ImageConstants.googleLogo,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onGooglePressed(
    ValueNotifier<bool> isLoginDisable,
  ) async {
    isLoginDisable.value = true;
    final authBloc = context.read<AuthBloc>();
    authBloc.add(OnSignWithGoogle());
  }

  Future<void> _onSendOtpPressed(
    bool termCondition,
    ValueNotifier<bool> isSignUpDisabled,
  ) async {

    final isConnected = await NetworkUtils.isConnected();
    if (!isConnected) {
      showErrorSnackBar(context: context, message:  'No internet connection. Please check your network.');
      return;
    }

    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      logger.d('formState validation failed');
      return;
    }
    if (!termCondition) {
      showErrorSnackBar(context: context, message: AppStrings.checkTermsConditions);
      return;
    }
    isSignUpDisabled.value = true;
    final authBloc = context.read<AuthBloc>();
    String email = emailController.text.trim();
    logger.d('_onSendOtpPressed email: $email');
    authBloc.add(OnSignup(
      email: email,
      fullName: nameController.text.trim(),
      password: passwordController.text.trim(),
    ));
  }

  void _onOtpSent(
    BuildContext context,
    ValueNotifier<bool> isVerifyOtpDisabled,
  ) {
    CustomBottomSheet.showOtpBottomSheet(
      onResend: () => _onVerifyOtpClicked(
        context,
        isVerifyOtpDisabled,
      ),
      buttonText: AppStrings.verifyOtp,
      context: context,
      onButtonClicked: () => _onVerifyOtpClicked(
        context,
        isVerifyOtpDisabled,
      ),
      subtitle: AppStrings.otpInstruction,
      isDisabled: isVerifyOtpDisabled.value,
      controller: _otpController,
    );
  }

  Future<void> _onVerifyOtpClicked(
    BuildContext context,
    ValueNotifier<bool> isVerifyOtpDisabled,
  ) async {
    isVerifyOtpDisabled.value = true;

    if (_otpController.currentState == null) {
      logger.d(AppStrings.otpFieldNull);
      showErrorSnackBar(context: context, message: AppStrings.otpFieldNA);

      isVerifyOtpDisabled.value = false;
      return;
    }

    final codeList = _otpController.currentState!.pinsInputed;
    String code = codeList.join();

    if (code.isEmpty || code.length != 4) {
      showErrorSnackBar(context: context, message: AppStrings.otpError);
      isVerifyOtpDisabled.value = false;
      return;
    }

    final email = emailController.text.trim();
    logger.d('_onVerifyOtpClicked email: $email, otp: $code');

    context.read<AuthBloc>().add(
          OnVerifyOtp(
            email: email,
            otp: code,
          ),
        );

    // Optional: Immediate visual feedback

    showSuccessSnackBar(context: context, message:  AppStrings.verifyingOtp);

  }

// Future<void> _onVerifyOtpClicked(
//   BuildContext context,
//   ValueNotifier<bool> isVerifyOtpDisabled,
// ) async
// {
//   isVerifyOtpDisabled.value = true;
//   logger.d('_onSendOtpPressed email:  _onVerifyOtpClicked');
//   final authBloc = context.read<AuthBloc>();
//   String email = emailController.text.trim();
//   authBloc.add(OnVerifyOtp(
//     email: email,
//     otp: code,
//   ));
//
//   // ✅ NEW: Show this snack to verify that the function is called
//   CustomSnackBar.showSnack(
//     context: context,
//     snackBarType: SnackBarType.success,
//     message: 'Verify OTP button pressed!',
//   );
//
//   if (_otpController.currentState == null) {
//     logger.d('OTP field is null');
//     return;
//   }
//
//   final codeList = _otpController.currentState!.pinsInputed;
//   logger.d(codeList);
//   String code = codeList.join(); // shorter
//
//   if (code.isEmpty || code.length != 4) {
//     CustomSnackBar.showSnack(
//       context: context,
//       snackBarType: SnackBarType.error,
//       message: 'Wrong OTP Entered',
//     );
//     return;
//   }
//
//   String email = emailController.text.trim();
//
//   context.read<AuthBloc>().add(
//         OnVerifyOtp(
//           otp: code,
//           email: email,
//         ),
//       );
// }
}
