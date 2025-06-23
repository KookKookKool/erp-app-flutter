import 'package:flutter/material.dart';

class ProjectLoadingWidget extends StatelessWidget {
  const ProjectLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
