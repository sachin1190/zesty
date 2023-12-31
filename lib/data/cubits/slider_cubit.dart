// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:zestyrentals/utils/api.dart';
import 'package:zestyrentals/utils/hive_utils.dart';

import '../helper/custom_exception.dart';
import '../model/home_slider.dart';

abstract class SliderState {}

class SliderInitial extends SliderState {}

class SliderFetchInProgress extends SliderState {}

class SliderFetchInInternalProgress extends SliderState {}

class SliderFetchSuccess extends SliderState {
  List<HomeSlider> sliderlist = [];

  SliderFetchSuccess(this.sliderlist);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sliderlist': sliderlist.map((x) => x.toMap()).toList(),
    };
  }

  factory SliderFetchSuccess.fromMap(Map<String, dynamic> map) {
    return SliderFetchSuccess(
      List<HomeSlider>.from(
        (map['sliderlist']).map<HomeSlider>(
          (x) => HomeSlider.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SliderFetchSuccess.fromJson(String source) =>
      SliderFetchSuccess.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SliderFetchFailure extends SliderState {
  final String errorMessage;
  final bool isUserDeactivated;
  SliderFetchFailure(
      this.errorMessage, this.isUserDeactivated); //, this.isUserDeactivated
}

class SliderCubit extends Cubit<SliderState> with HydratedMixin {
  SliderCubit() : super(SliderInitial());

  void fetchSlider(BuildContext context, {bool? forceRefresh}) async {
    // if (state is SliderFetchSuccess) {
    //   return;
    // }

    if (forceRefresh != true) {
      if (state is SliderFetchSuccess) {
        await Future.delayed(const Duration(seconds: 5));
        log("##waited");
        // });
      } else {
        emit(SliderFetchInProgress());
      }
    } else {
      emit(SliderFetchInProgress());
    }

    Future.delayed(
      Duration.zero,
      () {
        fetchSliderFromDb(context, sendCityName: true)
            .then((value) => emit(SliderFetchSuccess(value)))
            .catchError((e) {
          if (isClosed) return;
          bool isUserActive = true;
          if (e.toString() ==
              "your account has been deactive! please contact admin") {
            //message from API
            isUserActive = false;
          } else {
            isUserActive = true;
          }
          emit(SliderFetchFailure(e.toString(), isUserActive)); //, isUserActive
        });
      },
    );
  }

  Future<List<HomeSlider>> fetchSliderFromDb(BuildContext context,
      {required bool sendCityName}) async {
    List<HomeSlider> sliderlist = [];
    Map<String, String> body = {};

    if (sendCityName) {
      if (HiveUtils.getCityName() != null) {
        body['city'] = HiveUtils.getCityName();
      }
    }

    var response = await Api.post(url: Api.apiGetSlider, parameter: body);
    log(response.toString(), name: "slider response");

    if (!response[Api.error]) {
      List list = response['data'];

      sliderlist = list.map((model) => HomeSlider.fromJson(model)).toList();
    } else {
      throw CustomException(response[Api.message]);
    }

    return sliderlist;
  }

  @override
  SliderState? fromJson(Map<String, dynamic> json) {
    try {
      var state = json['cubit_state'];

      if (state == "SliderFetchSuccess") {
        return SliderFetchSuccess.fromMap(json);
      }
    } catch (e) {
      log("slider error $e");
    }

    return null;
  }

  @override
  Map<String, dynamic>? toJson(SliderState state) {
    if (state is SliderFetchSuccess) {
      Map<String, dynamic> map = state.toMap();
      map['cubit_state'] = "SliderFetchSuccess";
      return map;
    }
    return null;
  }
}
