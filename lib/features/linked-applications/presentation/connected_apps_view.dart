import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landing_page/components/basic_layout.dart';
import 'package:landing_page/features/linked-applications/presentation/connected_apps_page.dart';

class ConnectedAppsView extends ConsumerStatefulWidget {
  const ConnectedAppsView({super.key});

  @override
  ConsumerState createState() => _ConnectedAppsViewState();
}

class _ConnectedAppsViewState extends ConsumerState<ConnectedAppsView> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return CommonLayoutView(title: 'Connected Apps', body: ConnectedAppsPage());
  }
}
