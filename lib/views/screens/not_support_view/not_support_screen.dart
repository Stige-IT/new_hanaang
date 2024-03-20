
import 'package:admin_hanaang/features/auth/provider/auth_provider.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotSupportView extends ConsumerWidget {
  const NotSupportView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(child:

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            const Expanded(
              child: Column(
                children: [
                  Icon(Icons.perm_device_info, size: 70),
                  SizedBox(height: 10),
                  Text("Device tidak mendukung", textAlign: TextAlign.center,),
                ],
              ),
            ),
            ElevatedButton(onPressed: ()async{
              final result = await ref.watch(authNotifier.notifier).logout();
              if(!context.mounted) return ;
              if(result){
                nextPageRemoveAll(context, '/login');
              }
            }, child: const Text("Log out")),
          ],
        ),),
      ),
    );
  }
}
