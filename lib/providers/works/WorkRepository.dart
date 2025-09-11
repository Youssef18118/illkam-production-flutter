import 'package:ilkkam/apis/base.dart';
import 'package:ilkkam/models/workTypes/WorkTypeTotalResDto.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:ilkkam/providers/works/dto/WOrkUpdateRequestDto.dart';
import 'package:ilkkam/providers/works/dto/WorkReviewSaveRequestDto.dart';
import 'package:ilkkam/providers/works/dto/WorksApplyRequestDto.dart';
import 'package:ilkkam/providers/works/dto/WorksSaveRequestDto.dart';
import 'package:ilkkam/providers/works/dto/WorksSummaryDto.dart';
import 'package:intl/intl.dart';

class WorkRepository {
  final BaseAPI baseAPI = BaseAPI();

  Future<Work> getWork(int work_id) async {
    print('일깜 ${work_id} 불러오기');
    final resJson = await baseAPI.basicGet("works/${work_id}");
    return Work.fromJson(resJson);
  }

  Future<List<Work>> getWorkAsEmployer() async {
    print('일깜 고용중 불러오기');
    int? jwt = await baseAPI.getJWT();
    final resJson = await baseAPI.basicGet("works/${jwt}/employer");
    List<Work> works = [];
    resJson.forEach((v) {
      works.add(new Work.fromJson(v));
    });
    return works;
  }

  Future<List<Work>> getWorkAsEmployee() async {
    print('일깜 신청중 불러오기');
    int? jwt = await baseAPI.getJWT();
    final resJson = await baseAPI.basicGet("works/${jwt}/employee");
    List<Work> works = [];
    resJson.forEach((v) {
      works.add(new Work.fromJson(v));
    });
    return works;
  }

  Future<Map<String, dynamic>> getWorksByDate(
    String workDate, {
    int page = 0,
    String? workLocationSi,
    String? workLocationGu,
    String? workLocationDong,
    int? workTypeId,
    int? workTypeDetailId,
  }) async {
    List<Work> works = [];
    final resJson = await baseAPI.basicGet(
        "works/filters?page=$page&workDate=$workDate&page=$page${workLocationSi != null ? "&workLocationSi=$workLocationSi" : ""}${workLocationDong != null ? "&workLocationDong=$workLocationDong" : ""}${workLocationGu != null ? "&workLocationGu=$workLocationGu" : ""}${workTypeId != null ? "&workTypeId=$workTypeId" : ""}${workTypeDetailId != null ? "&workTypeDetailId=$workTypeDetailId" : ""}"
        "");
    resJson['content'].forEach((v) {
      works.add(new Work.fromJson(v));
    });

    return {"works": works, "last": resJson['last']};
  }

  // Future<List<Work>> getRecentWorks({
  //   int page = 0,
  //   String? workLocationSi,
  //   int? workTypeId,
  //   int? workTypeDetailId,
  // }) async {
  //   print('최근 등록된 일깜 불러오기');
  //   List<Work> works = [];
  //   final resJson = await baseAPI.basicGet(
  //       "works/?page=$page${workTypeId != null ? "&workTypeId=$workTypeId" : ""}${workTypeDetailId != null ? "&workTypeDetailId=$workTypeDetailId" : ""}${workLocationSi != null ? "&workLocationSi=$workLocationSi" : ""}");
  //   print(resJson);
  //   resJson.forEach((v) {
  //     works.add(new Work.fromJson(v));
  //   });

  //   return works;
  // }
  
  Future<List<Work>> getRecentWorks({
    int page = 0,
    String? workLocationSi,
    int? workTypeId,
    int? workTypeDetailId,
  }) async {
    print('최근 등록된 일깜 불러오기');
    List<Work> works = [];
    final resJson = await baseAPI.basicGet(
        "works/?page=$page${workTypeId != null ? "&workTypeId=$workTypeId" : ""}${workTypeDetailId != null ? "&workTypeDetailId=$workTypeDetailId" : ""}${workLocationSi != null ? "&workLocationSi=$workLocationSi" : ""}");
    print(resJson);

    // FIX: Add a null check here. If the response is null, return an empty list.
    if (resJson == null) {
      return [];
    }
    
    resJson.forEach((v) {
      works.add(new Work.fromJson(v));
    });

    return works;
  }

  Future<List<Work>> getAllRecent(String workHour) async {
    print('일깜 ${workHour} 불러오기');
    List<Work> works = [];
    final resJson =
        await baseAPI.basicPost("works/date", {"workDate": workHour});

    resJson.forEach((v) {
      works.add(new Work.fromJson(v));
    });

    return works;
  }

  // Future<List<WorksSummaryDto>> getWorkCountBetweenRange({
  //   String? workLocationSi,
  //   int? workTypeId,
  //   int? workTypeDetailId,
  // }) async {
  //   print('workCount 일깜 ${workTypeId} 불러오기');
  //   final resJson = await baseAPI.basicGet(
  //       "works/summary?${workTypeId != null ? "&workTypeId=$workTypeId" : ""}${workTypeDetailId != null ? "&workTypeDetailId=$workTypeDetailId" : ""}${workLocationSi != null ? "&workLocationSi=$workLocationSi" : ""}");
  //   List<WorksSummaryDto> works = [];
  //   print(
  //       "works/summary?${workTypeId != null ? "&workTypeId=$workTypeId" : ""}${workTypeDetailId != null ? "&workTypeDetailId=$workTypeDetailId" : ""}${workLocationSi != null ? "&workLocationSi=$workLocationSi" : ""}");
  //   resJson.forEach((v) {
  //     works.add(new WorksSummaryDto.fromJson(v));
  //   });
  //   works.sort(
  //       (a, b) => DateTime.parse(b.date!).compareTo(DateTime.parse(a.date!)));

  //   return works;
  // }
  Future<List<WorksSummaryDto>> getWorkCountBetweenRange({
    String? workLocationSi,
    int? workTypeId,
    int? workTypeDetailId,
  }) async {
    print('workCount 일깜 ${workTypeId} 불러오기');
    final resJson = await baseAPI.basicGet(
        "works/summary?${workTypeId != null ? "&workTypeId=$workTypeId" : ""}${workTypeDetailId != null ? "&workTypeDetailId=$workTypeDetailId" : ""}${workLocationSi != null ? "&workLocationSi=$workLocationSi" : ""}");
    List<WorksSummaryDto> works = [];
    print(
        "works/summary?${workTypeId != null ? "&workTypeId=$workTypeId" : ""}${workTypeDetailId != null ? "&workTypeDetailId=$workTypeDetailId" : ""}${workLocationSi != null ? "&workLocationSi=$workLocationSi" : ""}");

    // FIX: Add a null check here.
    if (resJson == null) {
      return [];
    }

    resJson.forEach((v) {
      works.add(new WorksSummaryDto.fromJson(v));
    });
    works.sort(
        (a, b) => DateTime.parse(b.date!).compareTo(DateTime.parse(a.date!)));

    return works;
  }

  Future<List<WorksSummaryDto>> getWorkSummaryByMonthly(
      {String? workLocationSi,
      int? workTypeId,
      int? workTypeDetailId,
      required DateTime month}) async {
    print('workCount 일깜 ${workTypeId} 불러오기');
    final resJson = await baseAPI.basicGet(
        "works/summary/monthly?${workTypeId != null ? "&workTypeId=$workTypeId" : ""}${workTypeDetailId != null ? "&workTypeDetailId=$workTypeDetailId" : ""}${workLocationSi != null ? "&workLocationSi=$workLocationSi" : ""}&month=${DateFormat("yyyy-MM-dd").format(month)}");
    List<WorksSummaryDto> works = [];
    resJson.forEach((v) {
      works.add(new WorksSummaryDto.fromJson(v));
    });
    works.sort(
        (a, b) => DateTime.parse(b.date!).compareTo(DateTime.parse(a.date!)));

    return works;
  }

  Future<void> applyWork(int peoleCount, int workId) async {
    print('일깜 ${workId} 지원하기');
    int applier = await baseAPI.getJWT() ?? 1;
    await baseAPI.basicPost(
        "apply/",
        WorkApplyRequestDto(
                peopleCount: peoleCount, workId: workId, applierId: applier)
            .toJson());

    return;
  }

  // Future<List<WorkTypes>> getAllWorkType() async {
  //   print('일깜 유형 불러오기');
  //   List<WorkTypes> workTypes = [];
  //   final resJson = await baseAPI.basicGet("works/type");
  //   // List<WorksSummaryDto> works = [];
  //   resJson.forEach((v) {
  //     workTypes.add(new WorkTypes.fromJson(v));
  //   });
  //   moveItems(0, 6, workTypes);
  //   moveItems(8, 6, workTypes);
  //   moveItems(9, 7, workTypes);

  //   return workTypes;
  // }
  
  Future<List<WorkTypes>> getAllWorkType() async {
    print('일깜 유형 불러오기');
    List<WorkTypes> workTypes = [];
    final resJson = await baseAPI.basicGet("works/type");
    
    // FIX: Add a null check here.
    if (resJson == null) {
      return [];
    }

    resJson.forEach((v) {
      workTypes.add(new WorkTypes.fromJson(v));
    });
    moveItems(0, 6, workTypes);
    moveItems(8, 6, workTypes);
    moveItems(9, 7, workTypes);

    return workTypes;
  }

  void moveItems(int from, int to, List<WorkTypes> workTypes) {
    var item = workTypes.removeAt(from); // 기존 위치에서 제거
    workTypes.insert(to, item); // 새로운 위치에 삽입
  }

  Future<void> saveWork(
      {required String workDate,
      String? workHour,
      required String workLocationSi,
      required String workLocationGu,
      // required String workLocationDong,
      required String workType,
      required String workTypeDetail,
      required List<WorkInfoDetail> workInfoDetail,
      required List<String> workImages,
      required String price,
      required String comment}) async {
    print('일깜 작성하기');
    int employer = await baseAPI.getJWT() ?? 1;
    await baseAPI.basicPost(
        "works/",
        WorksSaveRequestDto(
          workDate: workDate,
          workHour: workHour,
          workLocationSi: workLocationSi,
          workLocationGu: workLocationGu,
          // workLocationDong: workLocationDong,
          workMainType: workType,
          workDetailType: workTypeDetail,
          workInfoDetail: workInfoDetail,
          price: int.parse(price.replaceAll(",", "")),
          workImages: workImages,
          comments: comment,
          employerId: employer,
        ).toJson());

    return;
  }

  Future<void> updateWork({
    required String workDate,
    String? workHour,
    required String price,
    required int workId,
  }) async {
    await baseAPI.basicPut(
        "works/$workId",
        WorksUdateRequestDto(
          workDate: workDate,
          workHour: workHour,
          price: int.parse(price.replaceAll(",", "")),
        ).toJson());
    return;
  }

  Future deleteWork(int workId) async {
    print(workId);
    await baseAPI.basicDelete("works/$workId");
    return;
  }

  // Future reviewWorkByApplier(
  //     Work work, String content, int starCount, String? imageURL) async {
  //   print('일깜 리뷰 남기기 by 지원자 ');
  //   int writer = await baseAPI.getJWT() ?? 1;
  //   final resJson = await baseAPI.basicPost(
  //       "works/${work.id}/review",
  //       WorkReviewSaveRequestDto(
  //           employee: writer,
  //           employer: work.employer?.id,
  //           writer: writer,
  //           contents: content,
  //           starCount: starCount,
  //           image: imageURL));
  //   // List<WorksSummaryDto> works = [];
  //   return;
  // }
  //
  // Future reviewWorkByEmployer(
  //     Work work, String content, int starCount, String? imageURL) async {
  //   print('일깜 리뷰 남기기 by 고용주');
  //   int writer = await baseAPI.getJWT() ?? 1;
  //   final resJson = await baseAPI.basicPost(
  //       "works/${work.id}/review",
  //       WorkReviewSaveRequestDto(
  //           writer: writer,
  //           contents: content,
  //           starCount: starCount,
  //           image: imageURL));
  //   // List<WorksSummaryDto> works = [];
  //   return;
  // }

  Future reviewWork(String content, int starCount, String? imageURL,
      int work_id, int targetId) async {
    print('일깜 리뷰 남기기');
    int writer = await baseAPI.getJWT() ?? 1;
    await baseAPI.basicPost(
        "works/$work_id/review",
        WorkReviewSaveRequestDto(
            writer: writer,
            target: targetId,
            contents: content,
            starCount: starCount,
            image: imageURL));
  }

  Future editWork(String content, int starCount, String? imageURL,
      int reviewId) async {
    print('일깜 리뷰 남기기');
    await baseAPI.basicPut(
        "works/review/$reviewId",
        WorkReviewSaveRequestDto(
            contents: content,
            starCount: starCount,
            image: imageURL));
  }

  Future removeReview(int reviewId) async {
    print('일깜 리뷰 지우기');
    final resJson = await baseAPI.basicDelete("works/$reviewId/review");
    // List<WorksSummaryDto> works = [];
    return;
  }
}
