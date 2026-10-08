import 'package:flutter/material.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';

class RouteMapView extends StatelessWidget {
  final TransformationController transformationController;
  final VoidCallback? onDoubleTap;

  const RouteMapView({
    super.key,
    required this.transformationController,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: InteractiveViewer(
        transformationController: transformationController,
        minScale: 0.8,
        maxScale: 3.5,
        boundaryMargin: const EdgeInsets.all(120),
        child: SizedBox.expand(
          child: Image.asset(
            isDark ? ImageAssets.darkMap : ImageAssets.routeMap,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
