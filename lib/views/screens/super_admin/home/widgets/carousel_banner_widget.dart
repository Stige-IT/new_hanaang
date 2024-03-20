import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../features/banner/provider/banner_provider.dart';
import '../../../../../models/banner_data.dart';
import '../../../../../utils/constant/base_url.dart';
import '../../../../components/empty_preorder.dart';
import '../home_screen.dart';
import 'dialog_form_banner.dart';

class CarouselBannerWidget extends ConsumerWidget {
  const CarouselBannerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerState = ref.watch(bannersNotifierProvider);
    final List<BannerData>? bannersData = bannerState.data;
    final carouselIndex = ref.watch(carouselIndexProvider);
    return Column(
      children: [
        ListTile(
          title: Text(
            "Banner",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          trailing: CircleAvatar(
            radius: 15.r,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.black,
            child: Center(child: Text(" ${bannersData?.length ?? 0}")),
          ),
        ),
        if (bannerState.isLoading)
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.2),
            highlightColor: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey,
              ),
            ),
          )
        else if (bannersData != null && bannersData.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CarouselSlider(
                items: bannersData
                    .map((banner) => InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => DialogFormBanner(banner: banner),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: 140.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage("$BASE/${banner.image}"),
                              ),
                            ),
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.5),
                                      ])),
                              width: double.infinity,
                              height: 140.h,
                              child: Text("${banner.detail}",
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      )),
                            ),
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                  viewportFraction: 0.8,
                  autoPlay: true,
                  aspectRatio: 20 / 9,
                  enlargeCenterPage: true,
                  onPageChanged: (index, _) =>
                      ref.read(carouselIndexProvider.notifier).state = index,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  bannersData.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: index == carouselIndex
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          )
        else
          const EmptyBanners(),
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const DialogFormBanner(),
                );
              },
              child: const Text("Tambah Banner"),
            ),
          ),
        ),
      ],
    );
  }
}
