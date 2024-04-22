// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rive/rive.dart';
import 'package:student/core/widgets/firestore_functions.dart';
import 'package:student/core/widgets/password_validations.dart';
import 'package:student/theming/colors.dart';

import '../../../helpers/app_regex.dart';
import '../../../routing/routes.dart';
import '../../../theming/styles.dart';
import '../../helpers/extensions.dart';
import 'app_text_button.dart';
import 'app_text_form_field.dart';

enum Animations {
  idle,
  Hands_up,
  hands_down,
  success,
  fail,
  Look_down_right,
  Look_down_left,
}

// ignore: must_be_immutable
class EmailAndPassword extends StatefulWidget {
  final bool? isSignUpPage;
  final bool? isPasswordPage;
  final bool? isStudent;
  late GoogleSignInAccount? googleUser;
  late OAuthCredential? credential;
  EmailAndPassword({
    super.key,
    this.isSignUpPage,
    this.isPasswordPage,
    this.isStudent,
    this.googleUser,
    this.credential,
  });

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  bool isObscureText = true;
  bool hasLowercase = false;
  late final _auth = FirebaseAuth.instance;

  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  Artboard? riveArtboard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  late RiveAnimationController controllerLookDownRight;
  late RiveAnimationController controllerLookDownLeft;
  final passwordFocuseNode = FocusNode();
  final passwordConfirmationFocuseNode = FocusNode();

  bool isLookingRight = false;
  bool isLookingLeft = false;
  bool isLoading = false;

  @override
  void initState() {
    controllerIdle = SimpleAnimation(Animations.idle.name);
    controllerHandsUp = SimpleAnimation(Animations.Hands_up.name);
    controllerHandsDown = SimpleAnimation(Animations.hands_down.name);
    controllerSuccess = SimpleAnimation(Animations.success.name);
    controllerFail = SimpleAnimation(Animations.fail.name);
    controllerLookDownRight = SimpleAnimation(Animations.Look_down_right.name);
    controllerLookDownLeft = SimpleAnimation(Animations.Look_down_left.name);
    rootBundle.load('assets/login_animation.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      artboard.addController(controllerIdle);
      setState(() {
        riveArtboard = artboard;
      });
    });
    super.initState();
    setupPasswordControllerListener();
    checkForPasswordFocused();
    checkForPasswordConfirmationFocused();
  }

  void removeAllControllers() {
    final listOfControllers = [
      controllerIdle,
      controllerHandsUp,
      controllerHandsDown,
      controllerSuccess,
      controllerFail,
      controllerLookDownRight,
      controllerLookDownLeft,
    ];
    for (RiveAnimationController controller in listOfControllers) {
      riveArtboard!.removeController(controller);
    }
    isLookingLeft = false;
    isLookingRight = false;

    listOfControllers.clear();
  }

  void addIdleController() {
    removeAllControllers();
    riveArtboard!.addController(controllerIdle);
  }

  void addHandsUpController() {
    removeAllControllers();
    riveArtboard!.addController(controllerHandsUp);
  }

  void addHandsDownController() {
    removeAllControllers();
    riveArtboard!.addController(controllerHandsDown);
  }

  void addSuccessController() {
    removeAllControllers();
    riveArtboard!.addController(controllerSuccess);
  }

  void addFailController() {
    removeAllControllers();
    riveArtboard!.addController(controllerFail);
  }

  void addDownRightController() {
    removeAllControllers();
    riveArtboard!.addController(controllerLookDownRight);
    isLookingRight = true;
  }

  void addDownLeftController() {
    removeAllControllers();
    riveArtboard!.addController(controllerLookDownLeft);
    isLookingLeft = true;
  }

  void checkForPasswordFocused() {
    passwordFocuseNode.addListener(() {
      if (passwordFocuseNode.hasFocus && isObscureText) {
        addHandsUpController();
      } else if (!passwordFocuseNode.hasFocus && isObscureText) {
        addHandsDownController();
      }
    });
  }

  void checkForPasswordConfirmationFocused() {
    passwordConfirmationFocuseNode.addListener(() {
      if (passwordConfirmationFocuseNode.hasFocus && isObscureText) {
        addHandsUpController();
      } else if (!passwordConfirmationFocuseNode.hasFocus && isObscureText) {
        addHandsDownController();
      }
    });
  }

  void setupPasswordControllerListener() {
    passwordController.addListener(() {
      setState(() {
        hasLowercase = AppRegex.hasLowerCase(passwordController.text);
        hasSpecialCharacters =
            AppRegex.hasSpecialCharacter(passwordController.text);
        hasNumber = AppRegex.hasNumber(passwordController.text);
        hasMinLength = AppRegex.hasMinLength(passwordController.text);
      });
    });
  }

  Widget forgetPasswordTextButton(BuildContext context) {
    if (widget.isSignUpPage == null &&
        widget.isPasswordPage == null &&
        !isLoading) {
      return TextButton(
        onPressed: () {
          context.pushNamed(Routes.forgetScreen);
        },
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'هل نسيت كلمة السر؟',
            style: TextStyles.font14Blue400Weight,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  loginOrSignUpOrPasswordButton(BuildContext context) {
    if (widget.isSignUpPage == true && !isLoading) {
      return signUpButton(context);
    }
    if (widget.isSignUpPage == null &&
        widget.isPasswordPage == null &&
        !isLoading) {
      return loginButton(context);
    }
    if (widget.isPasswordPage == true && !isLoading) {
      return passwordButton(context);
    }
  }

  passwordsValidations(BuildContext context) {
    if (widget.isSignUpPage == true && !isLoading) {
      return PasswordValidations(
        hasLowerCase: hasLowercase,
        hasSpecialCharacters: hasSpecialCharacters,
        hasNumber: hasNumber,
        hasMinLength: hasMinLength,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  AppTextButton signUpButton(BuildContext context) {
    return AppTextButton(
      buttonText: "إنشاء حساب",
      textStyle: TextStyles.font16White600Weight,
      onPressed: () async {
        passwordFocuseNode.unfocus();
        passwordConfirmationFocuseNode.unfocus();
        if (formKey.currentState!.validate()) {
          try {
            isLoading = true;
            setState(() {});
            await _auth.createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text,
            );
            await _auth.currentUser!.updateDisplayName(
                '${firstNameController.text.trim()} ${lastNameController.text.trim()}');
            await _auth.currentUser!.sendEmailVerification();

            await FireStoreFunctions.addUser(
              widget.isStudent == null ? true: false,
              _auth.currentUser!.uid,
              firstNameController.text.trim(),
              lastNameController.text.trim(),
              '',
              emailController.text.trim(),
              '',
              '',
              _auth.currentUser!.photoURL ?? '',
            );

            await _auth.signOut();
            if (!context.mounted) return;
            await AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.bottomSlide,
              title: 'تم إنشاء الحساب بنجاح',
              desc: 'لا تنسى تفعيل حسابك من خلال البريد الإلكتروني.',
            ).show();

            addSuccessController();
            await Future.delayed(const Duration(seconds: 2));
            removeAllControllers();
            if (!context.mounted) return;

            context.pushNamedAndRemoveUntil(
              Routes.loginScreen,
              predicate: (route) => false,
            );
          } on FirebaseAuthException catch (e) {
            addFailController();

            if (e.code == 'email-already-in-use') {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: 'خطأ',
                desc:
                    'هذا الحساب موجود بالفعل لهذا البريد الإلكتروني اذهب وقم بتسجيل الدخول.',
              ).show();
            } else {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: 'خطأ',
                desc: e.message,
              ).show();
            }
          } catch (e) {
            addFailController();

            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              title: 'خطأ',
              desc: e.toString(),
            ).show();
          }
          isLoading = false;
          setState(() {});
        }
      },
    );
  }

  AppTextButton loginButton(BuildContext context) {
    return AppTextButton(
      buttonText: 'تسجيل الدخول',
      textStyle: TextStyles.font16White600Weight,
      onPressed: () async {
        passwordFocuseNode.unfocus();

        if (formKey.currentState!.validate()) {
          try {
            isLoading = true;
            setState(() {});
            final c = await _auth.signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text,
            );

            if (c.user!.emailVerified) {
              addSuccessController();
              await Future.delayed(const Duration(seconds: 2));
              removeAllControllers();

              final user = await FireStoreFunctions.fetchUser(c.user!.uid);
              if (!context.mounted) return;
              context.pushNamedAndRemoveUntil(
                user.type == 'student'
                    ? Routes.studentScreen
                    : Routes.teacherScreen,
                predicate: (route) => false,
              );
            } else {
              await _auth.signOut();
              addFailController();
              if (!context.mounted) return;

              AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.bottomSlide,
                title: 'الحساب غير مفعل',
                desc: 'من فضلك قم بتفعيل حسابك من خلال البريد الإلكتروني.',
              ).show();
            }
          } on FirebaseAuthException catch (e) {
            addFailController();
            if (e.code == 'invalid-credential') {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: 'خطأ',
                desc: 'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
              ).show();
            } else {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: 'خطأ',
                desc: e.message,
              ).show();
            }
          }
          isLoading = false;
          await Future.delayed(const Duration(seconds: 2));
          setState(() {});
        }
      },
    );
  }

  AppTextButton passwordButton(BuildContext context) {
    return AppTextButton(
      buttonText: 'إنشاء كلمة مرور',
      textStyle: TextStyles.font16White600Weight,
      onPressed: () async {
        passwordFocuseNode.unfocus();
        passwordConfirmationFocuseNode.unfocus();
        if (formKey.currentState!.validate()) {
          try {
            await _auth.createUserWithEmailAndPassword(
              email: widget.googleUser!.email.trim(),
              password: passwordController.text,
            );

            await _auth.currentUser!.linkWithCredential(widget.credential!);
            await _auth.currentUser!
                .updateDisplayName(widget.googleUser!.displayName);
            await _auth.currentUser!
                .updatePhotoURL(widget.googleUser!.photoUrl);

            FireStoreFunctions.addUser(
              widget.isStudent == null ? true: false,
              _auth.currentUser!.uid,
              widget.googleUser!.displayName!.split(' ')[0],
              widget.googleUser!.displayName!.split(' ')[1],
              '',
              widget.googleUser!.email.trim(),
              '',
              '',
              _auth.currentUser!.photoURL ?? '',
            );
            if (!context.mounted) return;
            await AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.rightSlide,
              title: 'اكتمل التسجيل',
              desc: 'تم إنشاء حسابك بنجاح.',
            ).show();

            addSuccessController();
            await Future.delayed(const Duration(seconds: 2));
            removeAllControllers();
            if (!context.mounted) return;

            context.pushNamedAndRemoveUntil(
              Routes.studentScreen,
              predicate: (route) => false,
            );
          } on FirebaseAuthException catch (e) {
            addFailController();

            if (e.code == 'email-already-in-use') {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: 'خطأ',
                desc:
                    'هذا الحساب موجود بالفعل لهذا البريد الإلكتروني اذهب وقم بتسجيل الدخول.',
              ).show();
            } else {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: 'خطأ',
                desc: e.message,
              ).show();
            }
          } catch (e) {
            addFailController();

            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.rightSlide,
              title: 'خطأ',
              desc: e.toString(),
            ).show();
          }
        }
      },
    );
  }

  Widget emailField() {
    if (widget.isPasswordPage == null && !isLoading) {
      return Column(
        children: [
          AppTextFormField(
            hint: 'البريد الإلكتروني',
            onChanged: (value) {
              if (value.isNotEmpty && value.length <= 16 && !isLookingLeft) {
                addDownLeftController();
              } else if (value.isNotEmpty &&
                  value.length > 16 &&
                  !isLookingRight) {
                addDownRightController();
              }
            },
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !AppRegex.isEmailValid(value.trim())) {
                addFailController();
                return 'من فضلك أدخل بريد إلكتروني صحيح';
              }
            },
            controller: emailController,
          ),
          Gap(10.h),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget firstNameField() {
    if (widget.isSignUpPage == true && !isLoading) {
      return Column(
        children: [
          AppTextFormField(
            hint: 'الاسم الأول',
            onChanged: (value) {
              if (value.isNotEmpty && !isLookingRight) {
                addDownRightController();
              } else if (value.isNotEmpty && !isLookingLeft) {
                addDownRightController();
              }
            },
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  value.startsWith(' ') ||
                  !AppRegex.isNameValid(value)) {
                addFailController();
                return 'من فضلك أدخل اسم صحيح';
              }
            },
            controller: firstNameController,
          ),
          Gap(10.h),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget lastNameField() {
    if (widget.isSignUpPage == true && !isLoading) {
      return Column(
        children: [
          AppTextFormField(
            hint: 'الاسم الأخير',
            onChanged: (value) {
              if (value.isNotEmpty && !isLookingLeft) {
                addDownLeftController();
              } else if (value.isNotEmpty && !isLookingRight) {
                addDownLeftController();
              }
            },
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  value.startsWith(' ') ||
                  !AppRegex.isNameValid(value)) {
                addFailController();
                return 'من فضلك أدخل اسم صحيح';
              }
            },
            controller: lastNameController,
          ),
          Gap(10.h),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  AppTextFormField passwordField() {
    return AppTextFormField(
      focusNode: passwordFocuseNode,
      controller: passwordController,
      hint: 'كلمة المرور',
      isObscureText: isObscureText,
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            if (isObscureText) {
              isObscureText = false;
              addHandsDownController();
            } else {
              addHandsUpController();
              isObscureText = true;
            }
          });
        },
        child: Icon(
          isObscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
      ),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            !AppRegex.isPasswordValid(value)) {
          addFailController();
          return 'من فضلك أدخل كلمة مرور صحيحة';
        }
      },
    );
  }

  Widget passwordConfirmationField() {
    if (widget.isSignUpPage == true ||
        widget.isPasswordPage == true && !isLoading) {
      return AppTextFormField(
        focusNode: passwordConfirmationFocuseNode,
        controller: passwordConfirmationController,
        hint: 'تأكيد كلمة المرور',
        isObscureText: isObscureText,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              if (isObscureText) {
                isObscureText = false;
                addHandsDownController();
              } else {
                addHandsUpController();
                isObscureText = true;
              }
            });
          },
          child: Icon(
            isObscureText ? Icons.visibility_off : Icons.visibility,
          ),
        ),
        validator: (value) {
          if (value != passwordController.text) {
            addFailController();

            return 'كلمة المرور غير متطابقة';
          }
          if (value == null ||
              value.isEmpty ||
              !AppRegex.isPasswordValid(value)) {
            addFailController();
            return 'من فضلك أدخل كلمة مرور صحيحة';
          }
        },
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
            height: MediaQuery.of(context).size.height / 1.1,
            child: Center(
              child: LoadingAnimationWidget.stretchedDots(
                color: ColorsManager.mainBlue,
                size: 100,
              ),
            ),
          )
        : Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
                    child: riveArtboard != null
                        ? Rive(
                            fit: BoxFit.cover,
                            artboard: riveArtboard!,
                          )
                        : const SizedBox.shrink(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 145.w,
                        child: lastNameField(),
                      ),
                      SizedBox(
                        width: 145.w,
                        child: firstNameField(),
                      ),
                    ],
                  ),
                  emailField(),
                  passwordField(),
                  Gap(10.h),
                  passwordConfirmationField(),
                  forgetPasswordTextButton(context),
                  Gap(10.h),
                  passwordsValidations(context),
                  Gap(10.h),
                  loginOrSignUpOrPasswordButton(context),
                ],
              ),
            ),
          );
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordConfirmationController.dispose();
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    removeAllControllers();
    controllerIdle.dispose();
    controllerHandsUp.dispose();
    controllerHandsDown.dispose();
    controllerSuccess.dispose();
    controllerFail.dispose();
    controllerLookDownRight.dispose();
    passwordFocuseNode.dispose();
    passwordConfirmationFocuseNode.dispose();
    controllerLookDownLeft.dispose();
    super.dispose();
  }
}
