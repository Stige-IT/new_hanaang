part of "../shift.dart";

final shiftNotifier =
    NotifierProvider<ShiftNotifier, States<ShiftResponse>>(ShiftNotifier.new);

final openShiftNotifier =
    NotifierProvider<OpenShiftNotifier, States>(OpenShiftNotifier.new);

final closeShiftNotifier =
NotifierProvider<CloseShiftNotifier, States>(CloseShiftNotifier.new);
