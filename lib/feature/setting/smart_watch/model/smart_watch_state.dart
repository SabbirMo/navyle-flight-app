enum SmartWatchSyncState {
  notPaired,
  appNotInstalled,
  ready,
}

enum SmartWatchType {
  appleWatch, // watchOS
  wearOs,     // Wear OS (Samsung Galaxy Watch, Pixel Watch, etc.)
}

enum FeatureStatusType {
  unavailable, // Orange badge: "Unavailable until paired"
  waiting,     // Blue badge: "Waiting for Watch app"
  available,   // Green badge: "Available on Apple Watch" / "Available on Watch" / "Enabled"
}
