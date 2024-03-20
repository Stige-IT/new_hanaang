part of "../shift.dart";

class ShiftNotifier extends Notifier<States<ShiftResponse>> {
  @override
  States<ShiftResponse> build() => States.noState();

  Future<void> get() async {
    state = States.loading();
    try {
      final result = await ref.watch(shiftProvider).getStatusShift();
      state = result.fold(
        (error) => States.error(error),
        (status) => States.finished(status),
      );
    } catch (e) {
      state = States.error(exceptionTomessage(e));
    }
  }
}

// open shift
class OpenShiftNotifier extends Notifier<States> {
  @override
  States build() => States.noState();

  Future<bool> open() async {
    state = States.loading();
    try {
      final result = await ref.watch(shiftProvider).openShift();
      state = result.fold(
        (l) => States.error(l),
        (r) => States.finished(r),
      );
      return result.isRight();
    } catch (e) {
      state = States.error(exceptionTomessage(e));
      return false;
    }
  }
}

// close shift
class CloseShiftNotifier extends Notifier<States> {
  @override
  States build() => States.noState();

  Future<bool> close() async {
    state = States.loading();
    try {
      final result = await ref.watch(shiftProvider).closeShift();
      state = result.fold(
        (l) => States.error(l),
        (r) => States.finished(r),
      );
      return result.isRight();
    } catch (e) {
      state = States.error(exceptionTomessage(e));
      return false;
    }
  }
}
