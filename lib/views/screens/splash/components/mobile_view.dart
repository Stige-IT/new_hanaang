part of'../splash.dart';
class MobileView extends ConsumerStatefulWidget {
  const MobileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MobileViewState();
}

class _MobileViewState extends ConsumerState<MobileView> {
  @override
  void initState() {
    Future.microtask(() => progressStream());
    super.initState();
  }

  void progressStream() {
    Timer.periodic(const Duration(milliseconds: 18), (timer) {
      ref.watch(percentProvider.notifier).state = (timer.tick / 100);
      if (timer.tick >= 100) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/cover_android.png"),
          )),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                value: ref.watch(percentProvider),
              ),
            ),
            Text(
              "${ref.watch(percentProvider)} %",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.white,
                  )
            )
          ],
        ),
      ),
    );
  }
}