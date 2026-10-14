import 'package:flutter/gestures.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/deliveryman_registration_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TramsConditionsCheckBoxWidget extends StatelessWidget {
  final AuthController? authController;
  final bool fromDmRegistration;
  final DeliverymanRegistrationController? deliverymanRegistrationController;
  final bool fromSignUp;
  final bool fromDialog;
  const TramsConditionsCheckBoxWidget({super.key, this.authController,  this.fromSignUp = false, this.fromDialog = false,
    this.fromDmRegistration = false, this.deliverymanRegistrationController});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: /*fromSignUp || fromDmRegistration ?*/ MainAxisAlignment.start /*: MainAxisAlignment.center*/, children: [

      Checkbox(
        activeColor: Theme.of(context).primaryColor,
        value: fromDmRegistration ? deliverymanRegistrationController?.acceptTerms ?? false : authController?.acceptTerms ?? false,
        onChanged: (bool? isChecked) => fromDmRegistration ? deliverymanRegistrationController?.toggleTerms() : authController?.toggleTerms(),
      ),

      Flexible(
        child: InkWell(
          onTap: () => fromDmRegistration ? deliverymanRegistrationController?.toggleTerms() : authController?.toggleTerms(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            child: RichText(
          text: TextSpan(children: [
            TextSpan(text: 'i_agree_with_all_the'.tr, style: robotoRegular.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeExtraSmall : null, color: Theme.of(context).hintColor)),
            const TextSpan(text: ' '),
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(RouteHelper.getTermsAndConditionRoute()),
              text: 'terms_conditions'.tr,
              style: robotoMedium.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeExtraSmall : null, color: Theme.of(context).primaryColor),
            ),
          ]),
            ),
          ),
        ),
      ),

    ]);
  }
}
