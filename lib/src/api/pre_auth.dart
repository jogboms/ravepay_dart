import 'package:meta/meta.dart';
import 'package:ravepay/src/api/api.dart';
import 'package:ravepay/src/api/charge.dart';
import 'package:ravepay/src/constants/countries.dart';
import 'package:ravepay/src/constants/currencies.dart';
import 'package:ravepay/src/constants/endpoints.dart';
import 'package:ravepay/src/models/metadata.dart';
import 'package:ravepay/src/models/result.dart';
import 'package:ravepay/src/utils/log.dart';
import 'package:ravepay/src/utils/response.dart';

class PreAuth extends Api {
  Future<Response<Result>> preauth({
    @required String cardno,
    @required String cvv,
    @required String amount,
    @required String expiryyear,
    @required String expirymonth,
    @required String email,
    String redirectUrl,
    String country = Countries.NIGERIA,
    String currency = Currencies.NAIRA,
    String suggestedAuth,
    String chargeType,
    String txRef,
    String iP,
    String settlementToken,
    String phonenumber,
    String billingzip,
    String firstname,
    String lastname,
    String narration,
    List<Metadata> meta,
    String pin,
    String bvn,
    String deviceFingerprint,
    String recurringStop,
    bool includeIntegrityHash,
  }) {
    assert(cardno != null);
    assert(cvv != null);
    assert(amount != null);
    assert(expiryyear != null);
    assert(expirymonth != null);
    assert(email != null);
    return Charge.preauth(
      cardno: cardno,
      currency: currency,
      suggestedAuth: suggestedAuth,
      country: country,
      settlementToken: settlementToken,
      cvv: cvv,
      amount: amount,
      phonenumber: phonenumber,
      billingzip: billingzip,
      expiryyear: expiryyear,
      expirymonth: expirymonth,
      email: email,
      firstname: firstname,
      lastname: lastname,
      iP: iP,
      narration: narration,
      txRef: txRef,
      meta: meta,
      pin: pin,
      bvn: bvn,
      chargeType: chargeType,
      deviceFingerprint: deviceFingerprint,
      recurringStop: recurringStop,
      includeIntegrityHash: includeIntegrityHash,
      redirectUrl: redirectUrl,
    ).charge();
  }

  Future<Response> _refundOrVoidCard({
    @required String flwRef,
    @required String action,
  }) async {
    final payload = {'SECKEY': keys.secret, 'ref': flwRef, 'action': action};

    Log().debug('$runtimeType.refundOrVoidCard()', payload);

    final _response = Response<Result>(
      await http.post(Endpoints.refundOrVoidPreauthorization, payload),
      onTransform: (dynamic data, _) => data,
    );

    Log().debug('$runtimeType.refundOrVoidCard($action) -> Response', _response);

    return _response;
  }

  Future<Response> voidCard(String flwRef) {
    return _refundOrVoidCard(flwRef: flwRef, action: 'void');
  }

  Future<Response> refundCard(String flwRef) {
    return _refundOrVoidCard(flwRef: flwRef, action: 'refund');
  }

  Future<Response> captureCard(String flwRef, String amount) async {
    final payload = {'SECKEY': keys.secret, 'flwRef': flwRef, 'amount': amount};

    Log().debug('$runtimeType.captureCard()', payload);

    final _response = Response<Result>(
      await http.post(Endpoints.capturePreauthorizeCard, payload),
      onTransform: (dynamic data, _) => data,
    );

    Log().debug('$runtimeType.captureCard() -> Response', _response);

    return _response;
  }
}
