import '../../utils/api.dart';

class Company {
  String? type;
  String? data;
  // String? compName;
  // String? compEmail;
  // String? compWebsite;
  // String? compAdrs;
  // String? compTel1;
  // String? compTel2;

  Company({
    this.type,
    this.data,
    // this.compName,
    // this.compEmail,
    // this.compWebsite,
    // this.compAdrs,
    // this.compTel1,
    // this.compTel2
  });

  Company.fromJson(Map<String, dynamic> json) {
    type = json[Api.type].toString();
    data = json[Api.data];
    // compTel1 = (type == ApiParams.tele1) ? json[ApiParams.data] : 9876543210;
    // compTel2 = (type == ApiParams.tele2) ? json[ApiParams.data] : 9876543210;
  }
}

/*
{
            "type": "company_name",
            "data": "KR Tech"
        },
        {
            "type": "company_website",
            "data": "krtech.in"
        },
        {
            "type": "company_email",
            "data": "knath@krtech.in"
        },
        {
            "type": "company_address",
            "data": "Tripura, India"
        },
        {
            "type": "company_tel1",
            "data": "1234567890"
        },
        {
            "type": "company_tel2",
            "data": "1234567890"
        }
*/