import 'dart:developer';

import '../../utils/api.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/constant.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static int? forceResendingToken;
  Future<Map<String, dynamic>> loginWithApi(
      {required String phone, required String uid, required int userTypeId, int loginType = 1, String email = ""}) async {
    Map<String, String> parameters = {
      Api.mobile: phone.replaceAll(" ", "").replaceAll("+", ""),
      Api.firebaseId: uid,
      Api.type: loginType.toString(),
      Api.email: email,
      Api.userType: userTypeId.toString(),
      "provider_id": DateTime.now().millisecondsSinceEpoch.toString()
    };

    Map<String, dynamic> response = await Api.post(
        url: Api.apiLogin, parameter: parameters, useAuthToken: false);

    print("RES $response");
    return {"token": response['token'], "data": response['data']};
  }

  Future<void> sendOTP(
      {required String phoneNumber,
      required Function(String verificationId) onCodeSent,
      Function(dynamic e)? onError}) async {
    log("CALLING THIS");

    await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: Duration(seconds: Constant.otpTimeOutSecond),
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          log("OH FAILED");

          onError?.call(ApiException(e.code));
        },

        // multiFactorSession: MultiFactorSession(id),
        codeSent: (String verificationId, int? resendToken) {
          log("CODE SENT");
          forceResendingToken = resendToken;
          onCodeSent.call(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log("TIMEOUT");
          // if (mounted) Navigator.of(context).pop();
        },
        forceResendingToken: forceResendingToken);
    log("RESULT THIS");
  }

  Future<UserCredential> verifyOTP({
    required String otpVerificationId,
    required String otp,
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: otpVerificationId, smsCode: otp);
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    return userCredential;
  }
}
