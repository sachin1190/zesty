// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zestyrentals/data/model/property_model.dart';

import '../../Repositories/property_repository.dart';

abstract class CreatePropertyState {}

class CreatePropertyInitial extends CreatePropertyState {}

class CreatePropertyInProgress extends CreatePropertyState {}

class CreatePropertySuccess extends CreatePropertyState {
  final PropertyModel? propertyModel;
  CreatePropertySuccess({
    this.propertyModel,
  });
}

class CreatePropertyFailure extends CreatePropertyState {
  final String errorMessage;

  CreatePropertyFailure(this.errorMessage);
}

class CreatePropertyCubit extends Cubit<CreatePropertyState> {
  final PropertyRepository _propertyRepository = PropertyRepository();

  CreatePropertyCubit() : super(CreatePropertyInitial());

  create({required Map<String, dynamic> parameters}) async {
    try {
      emit(CreatePropertyInProgress());

      var result =
          await _propertyRepository.createProperty(parameters: parameters);

      if (result['data'] != null) {
        emit(CreatePropertySuccess(
            propertyModel: PropertyModel.fromMap(result['data'][0])));
      } else {
        if (result is Map) {
          emit(CreatePropertyFailure(result['message'].toString()));
        } else {
          emit(CreatePropertyFailure("Something went wrong".toString()));
        }
      }
    } catch (e) {
      log("abc $e.toString()");
      emit(CreatePropertyFailure(e.toString()));
    }
  }
}
