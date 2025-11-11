import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyProfile extends ConsumerStatefulWidget {
  const MyProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyProfileState();
}

class _MyProfileState extends ConsumerState<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('show avatar created count.'),
          Text(
            'show avatar reach count. these will be total no of chat count from all avatar.',
          ),
          Text('show avatar profile count.'),
        ],
      ),
    );
  }
}
