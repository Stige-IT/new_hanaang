
import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../features/retur/provider/retur_provider.dart';
import '../../../../components/tile_retur.dart';

class ReturScreen extends ConsumerStatefulWidget {
  const ReturScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReturScreenState();
}

class _ReturScreenState extends ConsumerState<ReturScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<ScrollController> scrollController;

  _getData() async {
    ref.watch(returProcessNotifier.notifier).getRetur(makeLoading: true);
    ref.watch(returAcceptNotifier.notifier).getRetur(makeLoading: true);
    ref.watch(returRejectNotifier.notifier).getRetur(makeLoading: true);
    ref.watch(returFinishNotifier.notifier).getRetur(makeLoading: true);
  }

  List<String> typeRetur = ['Diproses', "Disetujui", "Ditolak", "Selesai"];

  @override
  void initState() {
    scrollController = List.generate(4, (index) => ScrollController());
    _tabController = TabController(length: 4, vsync: this);
    Future.microtask(() => _getData());

    List.generate(4, (index) {
      scrollController[index].addListener(() {
        if (scrollController[index].position.pixels ==
            scrollController[index].position.maxScrollExtent) {
          switch (index) {
            case 0:
              ref.watch(returProcessNotifier.notifier).loadMore();
              break;
            case 1:
              ref.watch(returAcceptNotifier.notifier).loadMore();
              break;
            case 2:
              ref.watch(returRejectNotifier.notifier).loadMore();
              break;
            case 4:
              ref.watch(returFinishNotifier.notifier).loadMore();
              break;
            default:
          }
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    List.generate(4, (index) => scrollController[index].dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text("Retur Produk"),
          actions: [
            IconButton(
              onPressed: () =>
                  nextPage(context, "${AppRoutes.sa}/retur/search"),
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () => _getData(),
              icon: const Icon(Icons.refresh),
            )
          ],
          bottom: TabBar(
              padding: const EdgeInsets.all(5.0),
              labelColor: Colors.white,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 0.0),
              controller: _tabController,
              tabs: const [
                Text("Diproses", textAlign: TextAlign.center),
                Text("Disetujui", textAlign: TextAlign.center),
                Text("Ditolak ", textAlign: TextAlign.center),
                Text("Selesai", textAlign: TextAlign.center),
              ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Builder(builder: (_) {
              if (ref.watch(returProcessNotifier).isLoading) {
                return  Center(
                    child: LoadingInButton(color: Theme.of(context).colorScheme.primary));
              }
              return TileRetur(
                title: "Diproses",
                scrollController: scrollController[0],
                returs: ref.watch(returProcessNotifier).data ?? [],
              );
            }),
            Builder(builder: (_) {
              if (ref.watch(returAcceptNotifier).isLoading) {
                return  Center(
                    child: LoadingInButton(color: Theme.of(context).colorScheme.primary));
              }
              return TileRetur(
                  title: "Disetujui",
                  scrollController: scrollController[1],
                  returs: ref.watch(returAcceptNotifier).data ?? []);
            }),
            Builder(builder: (_) {
              if (ref.watch(returRejectNotifier).isLoading) {
                return  Center(
                    child: LoadingInButton(color: Theme.of(context).colorScheme.primary));
              }
              return TileRetur(
                  title: "Ditolak",
                  scrollController: scrollController[2],
                  returs: ref.watch(returRejectNotifier).data ?? []);
            }),
            Builder(builder: (_) {
              if (ref.watch(returFinishNotifier).isLoading) {
                return  Center(
                    child: LoadingInButton(color: Theme.of(context).colorScheme.primary));
              }
              return TileRetur(
                  title: "Selesai",
                  scrollController: scrollController[3],
                  returs: ref.watch(returFinishNotifier).data ?? []);
            }),
          ],
        ));
  }
}
