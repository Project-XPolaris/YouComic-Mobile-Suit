import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/page.dart';
import 'package:youcomic/pages/read/status_provider.dart';

class ImagePage extends StatelessWidget {
  final PageEntity page;
  final bool displayImage;
  final double height;
  final double? width;

  ImagePage({required this.page, this.displayImage = false, required this.height, this.width});

  @override
  Widget build(BuildContext context) {
    final pagePlacement = Container(
        height: height,
        width: width,
        child: Center(
          child: Text("loading..."),
        ));
    return Consumer<ReadStatusProvider>(
        builder: (context, readStatusProvider, builder) {
      return (readStatusProvider.currentDisplayPage - page.order!).abs() < 3?CachedNetworkImage(
        imageUrl: page.path!,
        width: width,
        height: height,
        httpHeaders: {"Authorization": ApiClient().token},
        placeholder: (context, url) => pagePlacement,
      ):pagePlacement;
    });
  }
}
