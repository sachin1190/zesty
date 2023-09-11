// ignore_for_file: file_names

import 'dart:developer';

import 'package:zestyrentals/app/routes.dart';
import 'package:zestyrentals/data/Repositories/property_repository.dart';
import 'package:zestyrentals/data/model/data_output.dart';
import 'package:zestyrentals/data/model/property_model.dart';
import 'package:zestyrentals/settings.dart';
import 'package:zestyrentals/utils/constant.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DeepLinkManager {
  static void initDeepLinks(BuildContext context) async {
    ///
    PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    ///
    Future.delayed(Duration.zero, () {
      _handleDeepLinks(context, data);
    });

    ///
    ///
    ///
    FirebaseDynamicLinks.instance.onLink.listen((data) {
      _handleDeepLinks(context, data);
    });

    ///
  }

  static _handleDeepLinks(
      BuildContext context, PendingDynamicLinkData? data) async {
    final Uri? deepLink = data?.link;

    log("dynamic Link $data");
    if (deepLink == null) {
      return;
    }
    String? propertyId = deepLink.queryParameters['property_id'];
    DataOutput<PropertyModel> dataOutput =
        await PropertyRepository().fetchPropertyFromPropertyId(propertyId);
    Navigator.pushNamed(
        Constant.navigatorKey.currentContext!, Routes.propertyDetails,
        arguments: {
          'propertyData': dataOutput.modelList[0],
          'propertiesList': dataOutput.modelList
        });

//
//
  }

  static Future<String> buildDynamicLink(
    int propertyId, {
    SocialMetaTagParameters? metaTags,
  }) async {
    Uri uri =
        Uri.parse("http://${AppSettings.deepLinkName}?property_id=$propertyId");

    DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      link: uri,
      uriPrefix: AppSettings.deepLinkPrefix,
      navigationInfoParameters:
          const NavigationInfoParameters(forcedRedirectEnabled: true),
      androidParameters: const AndroidParameters(
          packageName: AppSettings.andoidPackageName, minimumVersion: 1),
      iosParameters: const IOSParameters(
          bundleId: AppSettings.andoidPackageName, minimumVersion: "1"),
    );

    ///
    ///
    final ShortDynamicLink dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(
      dynamicLinkParameters,
      shortLinkType: ShortDynamicLinkType.short,
    );
    log(dynamicLink.shortUrl.toString(), name: "mYlink");

    ///

    return dynamicLink.shortUrl.toString();
  }
}
