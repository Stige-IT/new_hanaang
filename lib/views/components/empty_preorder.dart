import 'package:admin_hanaang/config/theme.dart';
import 'package:flutter/material.dart';

class EmptyPreOrder extends StatelessWidget {
  const EmptyPreOrder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/banner.png"),
          ),
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            const Center(
              child: Text("Belum ada pre-order",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ));
  }
}

class EmptyBanners extends StatelessWidget {
  const EmptyBanners({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported_sharp),
                  SizedBox(height: 10),
                  Text("Belum Ada banner"),
                ],
              ),
            ),
          ],
        ));
  }
}
