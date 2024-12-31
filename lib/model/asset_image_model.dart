class AssetImageModel {
  String? message;
  String? apiReqId;
  String? apiReqCols;
  List<ApiDataArray>? apiDataArray;
  String? apiReqOrgnId;

  AssetImageModel(
      {this.message,
      this.apiReqId,
      this.apiReqCols,
      this.apiDataArray,
      this.apiReqOrgnId});

  AssetImageModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    apiReqId = json['apiReqId'];
    apiReqCols = json['apiReqCols'];
    if (json['apiDataArray'] != null) {
      apiDataArray = <ApiDataArray>[];
      json['apiDataArray'].forEach((v) {
        apiDataArray!.add(new ApiDataArray.fromJson(v));
      });
    }
    apiReqOrgnId = json['apiReqOrgnId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['apiReqId'] = this.apiReqId;
    data['apiReqCols'] = this.apiReqCols;
    if (this.apiDataArray != null) {
      data['apiDataArray'] = this.apiDataArray!.map((v) => v.toJson()).toList();
    }
    data['apiReqOrgnId'] = this.apiReqOrgnId;
    return data;
  }
}

class ApiDataArray {
  String? aCTIVEFLAG;
  Null? hIDDENFLAG;
  String? sEQUENCENO;
  String? aUDITID;
  String? fILENAME;
  String? rEGION;
  String? eDITBY;
  String? cREATEDATE;
  String? lOCALE;
  String? dEFAULTFLAG;
  String? aTTACHTYPE;
  String? cREATEBY;
  String? eDITDATE;
  String? cONTENT;
  String? aTTACHEXTENSION;
  String? tYPE;
  String? rECORDNO;

  ApiDataArray(
      {this.aCTIVEFLAG,
      this.hIDDENFLAG,
      this.sEQUENCENO,
      this.aUDITID,
      this.fILENAME,
      this.rEGION,
      this.eDITBY,
      this.cREATEDATE,
      this.lOCALE,
      this.dEFAULTFLAG,
      this.aTTACHTYPE,
      this.cREATEBY,
      this.eDITDATE,
      this.cONTENT,
      this.aTTACHEXTENSION,
      this.tYPE,
      this.rECORDNO});

  ApiDataArray.fromJson(Map<String, dynamic> json) {
    aCTIVEFLAG = json['ACTIVE_FLAG'];
    hIDDENFLAG = json['HIDDEN_FLAG'];
    sEQUENCENO = json['SEQUENCE_NO'];
    aUDITID = json['AUDIT_ID'];
    fILENAME = json['FILE_NAME'];
    rEGION = json['REGION'];
    eDITBY = json['EDIT_BY'];
    cREATEDATE = json['CREATE_DATE'];
    lOCALE = json['LOCALE'];
    dEFAULTFLAG = json['DEFAULT_FLAG'];
    aTTACHTYPE = json['ATTACH_TYPE'];
    cREATEBY = json['CREATE_BY'];
    eDITDATE = json['EDIT_DATE'];
    cONTENT = json['CONTENT'];
    aTTACHEXTENSION = json['ATTACH_EXTENSION'];
    tYPE = json['TYPE'];
    rECORDNO = json['RECORD_NO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ACTIVE_FLAG'] = this.aCTIVEFLAG;
    data['HIDDEN_FLAG'] = this.hIDDENFLAG;
    data['SEQUENCE_NO'] = this.sEQUENCENO;
    data['AUDIT_ID'] = this.aUDITID;
    data['FILE_NAME'] = this.fILENAME;
    data['REGION'] = this.rEGION;
    data['EDIT_BY'] = this.eDITBY;
    data['CREATE_DATE'] = this.cREATEDATE;
    data['LOCALE'] = this.lOCALE;
    data['DEFAULT_FLAG'] = this.dEFAULTFLAG;
    data['ATTACH_TYPE'] = this.aTTACHTYPE;
    data['CREATE_BY'] = this.cREATEBY;
    data['EDIT_DATE'] = this.eDITDATE;
    data['CONTENT'] = this.cONTENT;
    data['ATTACH_EXTENSION'] = this.aTTACHEXTENSION;
    data['TYPE'] = this.tYPE;
    data['RECORD_NO'] = this.rECORDNO;
    return data;
  }
}
