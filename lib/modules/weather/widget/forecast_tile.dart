import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/common/mixin/conversion_mixin.dart';
import 'package:weather_app/common/widget/weather_icon.dart';
import 'package:weather_app/modules/setting/provider/setting_provider.dart';
import 'package:weather_app/resources/color.dart';

import '../../../common/model/forecast.dart';

class ForecastDayTile extends ConsumerWidget with ConversionMixin {
  final Forecast forecast;

  const ForecastDayTile({super.key, required this.forecast});

  @override
  Widget build(BuildContext context, ref) {
    final degreeType =
        ref.watch(settingProvider.select((value) => value.degreeType));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(getDateText(
            forecast.parsedDate,
          )),
        ),
        Expanded(child: WeatherIcon(url: forecast.day.condition.iconUrl)),
        Expanded(
          child: Text(getDegree(
              degreeType, forecast.day.mintempC, forecast.day.mintempF),
            textAlign: TextAlign.end,

          ),
        ),
        Expanded(
          child: Text(
            getDegree(degreeType, forecast.day.maxtempC, forecast.day.maxtempF),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  //showing as today or day of week
  String getDateText(DateTime date) {
    if (date.day == DateTime.now().day) return 'Today';

    return DateFormat('EEEE').format(date);
  }
}

class ForecastHourTile extends ConsumerWidget with ConversionMixin {
  final HourForecast hour;

  const ForecastHourTile({super.key, required this.hour});

  @override
  Widget build(BuildContext context, ref) {
    final degreeType =
        ref.watch(settingProvider.select((value) => value.degreeType));

    final measureType =
        ref.watch(settingProvider.select((value) => value.measureType));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(
            getHourText(hour.parsedTime),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          WeatherIcon(
            url: hour.condition.iconUrl,
            size: 20,
          ),
          Text(
            getDegree(degreeType, hour.tempC, hour.tempF),
            style: TextStyle(fontSize: 13),
          ),
          SizedBox(
            height: 5,
          ),
          Icon(
            CupertinoIcons.wind,
            size: 20,
          ),
          Text(
            getMeasure(measureType, hour.windKph, hour.windMph,true),
            style: TextStyle(fontSize: 13),
          ),
          SizedBox(
            height: 5,
          ),
          Icon(
            CupertinoIcons.umbrella_fill,
            size: 20,
            color: kBlueColor,
          ),
          Text(
            '${hour.willItRain}%',
            style: TextStyle(fontSize: 16, color: kBlueColor),
          ),
        ],
      ),
    );
  }

  String getHourText(DateTime time) {
    if (time.hour == DateTime.now().hour) return 'Now';

    return DateFormat('hh:mm').format(time);
  }
}
