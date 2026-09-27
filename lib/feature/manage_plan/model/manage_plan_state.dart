class ManagePlanState {
  final bool isAutoRenew;
  final String planName;
  final String renewalDate;
  final String price;
  final String paymentCard;
  final String paymentExpiry;

  ManagePlanState({
    this.isAutoRenew = true,
    this.planName = "NAVYLA PLUS · Monthly",
    this.renewalDate = "May 14, 2026",
    this.price = "\$9.99",
    this.paymentCard = "Visa •• 4821",
    this.paymentExpiry = "09/28",
  });

  ManagePlanState copyWith({
    bool? isAutoRenew,
    String? planName,
    String? renewalDate,
    String? price,
    String? paymentCard,
    String? paymentExpiry,
  }) {
    return ManagePlanState(
      isAutoRenew: isAutoRenew ?? this.isAutoRenew,
      planName: planName ?? this.planName,
      renewalDate: renewalDate ?? this.renewalDate,
      price: price ?? this.price,
      paymentCard: paymentCard ?? this.paymentCard,
      paymentExpiry: paymentExpiry ?? this.paymentExpiry,
    );
  }
}
