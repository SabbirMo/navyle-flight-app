class VerifyDetailsState {
  final String name;
  final String flightNumber;
  final String from;
  final String to;
  final String date;
  final String seat;
  final String terminal;
  final String gate;
  final bool hasAttemptedSubmit;
  final bool isManual;

  const VerifyDetailsState({
    this.name = '',
    this.flightNumber = '',
    this.from = '',
    this.to = '',
    this.date = '',
    this.seat = '',
    this.terminal = '',
    this.gate = '',
    this.hasAttemptedSubmit = false,
    this.isManual = false,
  });

  bool get isValid =>
      name.trim().isNotEmpty &&
      flightNumber.trim().isNotEmpty &&
      from.trim().isNotEmpty &&
      to.trim().isNotEmpty &&
      date.trim().isNotEmpty &&
      seat.trim().isNotEmpty &&
      terminal.trim().isNotEmpty &&
      gate.trim().isNotEmpty;

  List<String> get emptyFields {
    final list = <String>[];
    if (name.trim().isEmpty) list.add('Name');
    if (flightNumber.trim().isEmpty) list.add('Flight Number');
    if (from.trim().isEmpty) list.add('Origin (From)');
    if (to.trim().isEmpty) list.add('Destination (To)');
    if (date.trim().isEmpty) list.add('Date');
    if (seat.trim().isEmpty) list.add('Seat');
    if (terminal.trim().isEmpty) list.add('Terminal');
    if (gate.trim().isEmpty) list.add('Gate');
    return list;
  }

  VerifyDetailsState copyWith({
    String? name,
    String? flightNumber,
    String? from,
    String? to,
    String? date,
    String? seat,
    String? terminal,
    String? gate,
    bool? hasAttemptedSubmit,
    bool? isManual,
  }) {
    return VerifyDetailsState(
      name: name ?? this.name,
      flightNumber: flightNumber ?? this.flightNumber,
      from: from ?? this.from,
      to: to ?? this.to,
      date: date ?? this.date,
      seat: seat ?? this.seat,
      terminal: terminal ?? this.terminal,
      gate: gate ?? this.gate,
      hasAttemptedSubmit: hasAttemptedSubmit ?? this.hasAttemptedSubmit,
      isManual: isManual ?? this.isManual,
    );
  }
}
