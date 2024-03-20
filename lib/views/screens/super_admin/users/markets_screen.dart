import 'dart:developer';

import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/features/market/provider/market_provider.dart';
import 'package:admin_hanaang/models/market.dart';
import 'package:admin_hanaang/views/components/circle_avatar_network.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:admin_hanaang/views/components/profile_with_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/constant/base_url.dart';

final showSearchProvider = StateProvider.autoDispose<bool>((ref) => false);

class MarketsScreen extends ConsumerStatefulWidget {
  final String? userId;
  const MarketsScreen({super.key, this.userId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends ConsumerState<MarketsScreen> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  @override
  void initState() {
    Future.microtask(() => ref
        .read(marketsNotifier.notifier)
        .getData(makeLoading: true, idUser: widget.userId));
    _scrollController = ScrollController();
    _searchController = TextEditingController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (ref.watch(marketsNotifier).page !=
            ref.watch(marketsNotifier).lastPage) {
          log("Get Data more");
          ref.read(marketsNotifier.notifier).getDataMore(idUser: widget.userId);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isShowSearch = ref.watch(showSearchProvider);
    final state = ref.watch(marketsNotifier);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: isShowSearch
            ? TextField(
                autofocus: true,
                controller: _searchController,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  ref
                      .read(marketsNotifier.notifier)
                      .searchByQuery(value, idUser: widget.userId);
                },
              )
            : const Text("Daftar Warung"),
        actions: [
          IconButton(
            onPressed: () {
              if (isShowSearch) {
                _searchController.clear();
                ref
                    .read(marketsNotifier.notifier)
                    .refresh(userId: widget.userId);
              }
              ref.read(showSearchProvider.notifier).state = !isShowSearch;
            },
            icon: isShowSearch
                ? const Icon(Icons.close)
                : const Icon(Icons.search),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            ref.read(marketsNotifier.notifier).refresh();
          });
        },
        child: Builder(builder: (_) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_outlined, size: 50),
                  Text(state.error!),
                ],
              ),
            );
          } else if (state.data == null || state.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.house_outlined, size: 50),
                  Text("Data tidak ditemuka"),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(10.0),
            itemBuilder: (_, i) {
              Market market = state.data![i];
              if (state.isLoadingMore && i == state.data!.length) {
                return const LoadingInButton();
              }
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListTile(
                    onTap: () => nextPage(
                        context, "${AppRoutes.sa}/markets/detail",
                        argument: market.id),
                    dense: true,
                    leading: market.image != null
                        ? CircleAvatarNetwork("$BASE/${market.image}")
                        : ProfileWithName(market.name!),
                    title: const Text("Nama Warung"),
                    subtitle: Text(market.name ?? "-",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                  ),
                ),
              );
            },
            separatorBuilder: (_, i) => const SizedBox(height: 5),
            itemCount: state.isLoadingMore
                ? state.data!.length + 1
                : state.data!.length,
          );
        }),
      ),
    );
  }
}
