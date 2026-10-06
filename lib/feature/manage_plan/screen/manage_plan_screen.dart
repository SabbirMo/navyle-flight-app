import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/manage_plan/provider/manage_plan_notifier.dart';
import 'package:navyla_flight_app/feature/manage_plan/widget/current_plan_card.dart';
import 'package:navyla_flight_app/feature/manage_plan/widget/plan_options_card.dart';

class ManagePlanScreen extends ConsumerStatefulWidget {
  const ManagePlanScreen({super.key});

  @override
  ConsumerState<ManagePlanScreen> createState() => _ManagePlanScreenState();
}

class _ManagePlanScreenState extends ConsumerState<ManagePlanScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(managePlanNotifierProvider);

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
                    SizedBox(height: 12.h),

                    // 2. Subscription Options, Billing, and Action Cards
                    const PlanOptionsCard(),
                    SizedBox(height: 24.h),
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
