import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/manage_plan/provider/manage_plan_notifier.dart';
import 'package:navyla_flight_app/feature/manage_plan/widget/billing_history_card.dart';
import 'package:navyla_flight_app/feature/manage_plan/widget/current_plan_card.dart';
import 'package:navyla_flight_app/feature/manage_plan/widget/payment_method_card.dart';
import 'package:navyla_flight_app/feature/manage_plan/widget/plan_options_card.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class ManagePlanScreen extends ConsumerStatefulWidget {
  const ManagePlanScreen({super.key});

  @override
  ConsumerState<ManagePlanScreen> createState() => _ManagePlanScreenState();
}

class _ManagePlanScreenState extends ConsumerState<ManagePlanScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(managePlanNotifierProvider);
    final notifier = ref.read(managePlanNotifierProvider.notifier);

    return Scaffold(
      body: CommonScreen(
        child: Column(
          children: [
            const CustomBackButton(title: "MANAGE PLAN"),
            SizedBox(height: 16.h),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Current Plan Orange Banner Card
                    CurrentPlanCard(
                      planName: state.planName,
                      renewalDate: state.renewalDate,
                      price: state.price,
                    ),
                    SizedBox(height: 16.h),

                    // 2. Subscription Options Card
                    PlanOptionsCard(
                      isAutoRenew: state.isAutoRenew,
                      onAutoRenewChanged: (value) {
                        notifier.setAutoRenew(value);
                      },
                      onSwitchToYearly: () {
                        context.push(AppRouterName.subscriptionScreen);
                      },
                      onCancelSubscription: () {
                        // Handle cancel subscription
                      },
                    ),
                    SizedBox(height: 16.h),

                    // 3. Payment Method Card
                    PaymentMethodCard(
                      cardTitle: state.paymentCard,
                      expiryDate: "Expires ${state.paymentExpiry}",
                      onUpdateTap: () {
                        // Handle payment method update
                      },
                    ),
                    SizedBox(height: 20.h),

                    // 4. Section Title: BILLING HISTORY
                    Padding(
                      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                      child: Text(
                        "BILLING HISTORY",
                        style: StyleManager.interBold10(
                          AppColors.lightGray,
                        ).copyWith(letterSpacing: 0.9),
                      ),
                    ),

                    // 5. Billing History Card
                    const BillingHistoryCard(),
                    SizedBox(height: 28.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
