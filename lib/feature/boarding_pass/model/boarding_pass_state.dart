class BoardingPassState {
  final String gate;
  final int walkTimeMinutes;
  final String boardingStatus;
  final String statusSubtitle;
  final int remainingSeconds;
  final bool isStressFreeModeActive;
  final String stressFreeTitle;
  final String routeUpdateTitle;
  final String routeUpdateMessage;

  const BoardingPassState({
    this.gate = 'B24',
    this.walkTimeMinutes = 12,
    this.boardingStatus = 'Ready Soon',
    this.statusSubtitle = 'Stay prepared',
    this.remainingSeconds = 1122, // 18 minutes 42 seconds (18:42)
    this.isStressFreeModeActive = true,
    this.stressFreeTitle = '60-MINUTE STRESS-FREE MODE ACTIVE',
    this.routeUpdateTitle = 'ROUTE UPDATE',
    this.routeUpdateMessage =
        'Elevator near B20 is out of service. Use stairs at B18.',
  });

  String get formattedCountdown {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  BoardingPassState copyWith({
    String? gate,
    int? walkTimeMinutes,
    String? boardingStatus,
    String? statusSubtitle,
    int? remainingSeconds,
    bool? isStressFreeModeActive,
    String? stressFreeTitle,
    String? routeUpdateTitle,
    String? routeUpdateMessage,
  }) {
    return BoardingPassState(
      gate: gate ?? this.gate,
      walkTimeMinutes: walkTimeMinutes ?? this.walkTimeMinutes,
      boardingStatus: boardingStatus ?? this.boardingStatus,
      statusSubtitle: statusSubtitle ?? this.statusSubtitle,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isStressFreeModeActive:
          isStressFreeModeActive ?? this.isStressFreeModeActive,
      stressFreeTitle: stressFreeTitle ?? this.stressFreeTitle,
      routeUpdateTitle: routeUpdateTitle ?? this.routeUpdateTitle,
      routeUpdateMessage: routeUpdateMessage ?? this.routeUpdateMessage,
    );
  }
}
