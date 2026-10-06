class ManagePlanState {
  final bool isAutoRenew;
  final String planName;
  final String renewalDate;
  final String price;

  ManagePlanState({
    this.isAutoRenew = true,
    this.planName = "NAVYLA PLUS · Monthly",
    this.renewalDate = "May 14, 2026",
    this.price = "\$9.99",
  });

  ManagePlanState copyWith({
    bool? isAutoRenew,
    String? planName,
    String? renewalDate,
    String? price,
  }) {
    return ManagePlanState(
      isAutoRenew: isAutoRenew ?? this.isAutoRenew,
      planName: planName ?? this.planName,
      renewalDate: renewalDate ?? this.renewalDate,
      price: price ?? this.price,
    );
  }
}
