
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../features/banner/data/banner_api.dart';
import '../../../../../features/banner/provider/banner_provider.dart';
import '../../../../../features/image_picker/image_picker.dart';
import '../../../../../models/banner_data.dart';
import '../../../../../utils/constant/base_url.dart';
import '../../../../components/form_input.dart';
import '../../../../components/snackbar.dart';

class DialogFormBanner extends ConsumerStatefulWidget {
  final BannerData? banner;

  const DialogFormBanner({super.key, this.banner});

  @override
  ConsumerState createState() => _DialogFormBannerState();
}

class _DialogFormBannerState extends ConsumerState<DialogFormBanner> {
  final _globalKey = GlobalKey<FormState>();
  late TextEditingController _descriptionCtrl;
  File? image;

  @override
  void initState() {
    _descriptionCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: EdgeInsets.all(25.h),
          padding: EdgeInsets.all(25.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Form(
            key: _globalKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Banner",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(widget.banner != null)
                          IconButton(
                              onPressed: () {
                                ref
                                    .watch(bannerProvider)
                                    .deleteBannerdata(widget.banner!)
                                    .then((value) {
                                  ref
                                      .watch(bannersNotifierProvider.notifier)
                                      .getBannerData();
                                  Navigator.pop(context);
                                  showSnackbar(context, "Banner dihapus",
                                      isWarning: true);
                                });
                                _descriptionCtrl.clear();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        IconButton(
                          onPressed: Navigator.of(context).pop,
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () async {
                      final File? newImage = await ref
                          .watch(imagePickerProvider.notifier)
                          .getFromGallery();
                      if (newImage != null) {
                        setState(() {
                          image = newImage;
                        });
                      }
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: image == null
                          ? widget.banner == null
                          ? Card(
                          color: Theme.of(context).colorScheme.surface,
                          child: const Center(
                            child: Icon(Icons.image, size: 50),
                          ))
                          : Image.network(
                        "$BASE/${widget.banner?.image}",
                        fit: BoxFit.cover,
                      )
                          : Image.file(image!, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FieldInput(
                    isRounded: true,
                    title: "Deskripsi",
                    hintText: "Masukkan Deskripsi Banner",
                    controller: _descriptionCtrl,
                    textValidator: "",
                    keyboardType: TextInputType.multiline,
                    obsecureText: false,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: Navigator.of(context).pop,
                        child: const Text("Kembali"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          if (_globalKey.currentState!.validate()) {
                            Navigator.of(context).pop();
                            if (widget.banner == null) {
                              ref
                                  .watch(createBannerNotifier.notifier)
                                  .createBanner(
                                detail: _descriptionCtrl.text,
                                image: image!,
                              )
                                  .then((success) {
                                if (!success) {
                                  showSnackbar(context,
                                      ref.watch(createBannerNotifier).error!,
                                      isWarning: true);
                                }
                              });
                            } else {
                              ref
                                  .watch(updateBannerNotifier.notifier)
                                  .updateBanner(
                                widget.banner!,
                                detail: _descriptionCtrl.text,
                                image: image,
                              );
                            }
                          }
                        },
                        child:
                        Text(widget.banner == null ? "Tambah" : "Perbarui"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}