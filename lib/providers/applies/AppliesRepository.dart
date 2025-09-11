import 'package:ilkkam/apis/base.dart';

enum APPLY_STATUS {
  waiting(0),
  confirm(1),
  cancel(9);
  final int value;
  const APPLY_STATUS(this.value);
}

class AppliesRepository {
  final BaseAPI baseAPI = BaseAPI();

  Future<String> updateStatus(int applyId, APPLY_STATUS status) async {
    print('지원자 처리하기');
    final resJson = await baseAPI.basicPost("apply/$applyId/apply",{
      "status" : status.value
    });
    return resJson;
  }
}