import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('خطایی رخ داده است '),
          ElevatedButton(
              onPressed: () {}, child: const Text('دوباره تلاش کنید'))
        ],
      ),
    );
  }
}
