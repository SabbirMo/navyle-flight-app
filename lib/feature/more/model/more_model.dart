import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';

class MoreModel {
  final int id;
  final String image;
  final String title;
  final String subtitle;
  final String partnerText;
  final String partnerSubText;

  MoreModel({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.partnerText,
    required this.partnerSubText,
  });
}

final List<MoreModel> moreItem = [
  MoreModel(
    id: 1,
    image: ImageAssets.hotel,
    title: AppString.hotel,
    subtitle: AppString.hotelDesc,
    partnerText: AppString.hotelPartnerText,
    partnerSubText: AppString.hotelPartnerSubText,
  ),
  MoreModel(
    id: 2,
    image: ImageAssets.car,
    title: AppString.parking,
    subtitle: AppString.parkingDesc,
    partnerText: AppString.parkingPartnerText,
    partnerSubText: AppString.parkingPartnerSubText,
  ),
  MoreModel(
    id: 3,
    image: ImageAssets.sofa,
    title: AppString.lounge,
    subtitle: AppString.loungeDesc,
    partnerText: AppString.loungePartnerText,
    partnerSubText: AppString.loungePartnerSubText,
  ),
  MoreModel(
    id: 4,
    image: ImageAssets.wifi,
    title: AppString.wifi,
    subtitle: AppString.wifiDesc,
    partnerText: AppString.eSimPartnerText,
    partnerSubText: AppString.eSimPartnerSubText,
  ),
  MoreModel(
    id: 5,
    image: ImageAssets.bag,
    title: AppString.travelGear,
    subtitle: AppString.travelGearDesc,
    partnerText: AppString.travelGearPartnerText,
    partnerSubText: AppString.travelGearPartnerSubText,
  ),
];
