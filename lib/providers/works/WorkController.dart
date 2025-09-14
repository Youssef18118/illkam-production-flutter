import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ilkkam/apis/base.dart';
import 'package:ilkkam/models/workTypes/WorkTypeDetails.dart';
import 'package:ilkkam/models/workTypes/WorkTypeTotalResDto.dart';
import 'package:ilkkam/pages/main/WorkDetailpage.dart';
import 'package:ilkkam/providers/works/WorkRepository.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:ilkkam/providers/works/dto/WorksSummaryDto.dart';
import 'package:intl/intl.dart';

// Removed global landingRefreshKey - now using local keys in each page

class WorkController with ChangeNotifier {
  WorkRepository workRepository = WorkRepository();
  Work? selectedWork;

  // workDetailPage
  bool canApply = true;
  BaseAPI baseAPI = BaseAPI();

  bool isMainLoading = false;

  List<Work> myEmployerWork = [];
  List<Work> myEmployeeWork = [];
  List<Work> myWorks = [];
  // 일깜 날짜 위젯
  final ScrollController? dayListWidgetScrollController = ScrollController();

  // 일깜 메인 화면 페이지
  List<Work> recentWorks = [];
  ScrollController landingPageScrollC = ScrollController();
  // Changed to a getter method that returns a new ScrollController each time it's accessed
  // This prevents the same controller from being attached to multiple scroll views
  ScrollController get workListPageScrollC => ScrollController();

  Future<void> scrollUpLandingPage() async {
    if (landingPageScrollC.hasClients) {
      await landingPageScrollC.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  // 일깜 더보기 페이지
  List<Work> workListWorks = [];
  int page = 0;
  bool isLoading = false;
  bool hasMore = true;

  List<WorksSummaryDto> workSummary = [];

  // workListPage에서 보여주는 변수들
  List<WorksSummaryDto> workListWorkSummary = [];

  // 필터 기능 구현
  // 필터 선택지 불러오기

  List<WorkTypes> workTypes = [
    WorkTypes(id: 0, name: "1차 카테고리"),
  ];
  List<WorkTypeDetails> workTypeDetails = [
    WorkTypeDetails(id: 0, name: "2차 카테고리"),
  ];

  // 지역 시,도 선택
  String? selectedProvince;

  // 일깜 유형 선택
  WorkTypes? selectedWorkType;
  WorkTypeDetails? selectedWorkDetailType;

  DateTime? selectedMonth;

  // 선택 날짜
  DateTime selectedDate = DateTime.now();

  initializeFilters() async {
    workTypes = [WorkTypes(name: "전체 보기")];
    workTypes.addAll(await workRepository.getAllWorkType());
    reload();
  }

  fetchWorkSummary() async {
    workSummary = (await workRepository.getWorkCountBetweenRange(
            workTypeId: selectedWorkType?.id,
            workTypeDetailId: selectedWorkDetailType?.id,
            workLocationSi: selectedProvince))
        .reversed
        .toList();
    notifyListeners();
  }

  fetchWorkSummaryByMonth() async {
    workListWorkSummary = (await workRepository.getWorkSummaryByMonthly(
            workTypeId: selectedWorkType?.id,
            workTypeDetailId: selectedWorkDetailType?.id,
            workLocationSi: selectedProvince,
            month: selectedMonth?? DateTime.now()))
        .reversed
        .toList();
    notifyListeners();
  }

  reload() async {
    await fetchWorkSummary();
    await fetchRecents();

    notifyListeners();
  }

  reloadWorkListPage() {
    fetchWorkSummaryByMonth();
    reloadWorkList();

    notifyListeners();
  }

  // work filter 구현 부분
  ////////////////////////////
  ////////////////////////////
  ////////////////////////////
  changeMonth(DateTime newValue, {bool fromDayCount = false}) {
    selectedMonth = newValue;
    // fromDayCount
    //     ? selectedDate = newValue
    //     : selectedDate = DateTime(newValue.year, newValue.month, 1);
    selectedDate =newValue;
    page = 0;
    reloadWorkList();
    fetchWorkSummaryByMonth();
  }

  changeProvince(String? newValue, {bool isLandingPage = true}) {
    selectedProvince = newValue;
    page= 0;
    if(isLandingPage){
      reload();
    }else{
      reloadWorkListPage();
    }

  }

  changeWorkMainType(WorkTypes? typeId, {bool isLandingPage = true}) {
    page= 0;
    selectedWorkDetailType = null;
    selectedWorkType = typeId;
    workTypeDetails = [
      WorkTypeDetails(id: 0, name: "2차 카테고리"),
    ];
    workTypeDetails.addAll(typeId?.workTypeDetails ?? []);
    if(isLandingPage){
      reload();
    }else{
      reloadWorkListPage();
    }
  }

  changeWorkDetailType(WorkTypeDetails? typeId, {bool isLandingPage = true}) {
    page= 0;
    selectedWorkDetailType = typeId;


    if(isLandingPage){
      reload();
    }else{
      reloadWorkListPage();
    }
  }

  ////////////////////////////
  ////////////////////////////
  ////////////////////////////

  // workListPage 에서 날짜별로 가져오기
  selectWorkDate(DateTime time) {
    selectedDate = time;
    page = 0;
    reloadWorkList();
    notifyListeners();
  }

  onClickBtmIllkam() async {
    isMainLoading = true;
    notifyListeners();
    try {
      await Future.wait([
        scrollUpLandingPage(),
        _resetFiltersAndScroll(),
      ]);
    } catch (e) {
      log("Error on onClickBtmIllkam $e");
    } finally {
      isMainLoading = false;
      notifyListeners();
    }
  }

  Future<void> _resetFiltersAndScroll() async {
    if (dayListWidgetScrollController?.hasClients ?? false) {
      await dayListWidgetScrollController?.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
    selectedProvince = null;
    selectedWorkDetailType = null;
    selectedWorkType = null;
    await reload();
  }

  Future reloadWorkList({int? reqPage}) async {
    log('reloadWorkListOccurred; page is $page');
    isLoading = true;
    notifyListeners();
    try{
      print(selectedDate);
      Map<String,dynamic> result  = await workRepository.getWorksByDate(
          page: page,
          DateFormat("yyyy-MM-dd").format(selectedDate),
          workLocationSi: selectedProvince,
          workTypeId: selectedWorkType?.id,
          workTypeDetailId: selectedWorkDetailType?.id);
      if(page != 0){
        workListWorks.addAll(result["works"]);
      }else{
        workListWorks = result['works'];
      }
      hasMore = !result['last'];
      if(hasMore){
        page++;
      }
      isLoading = false;
      notifyListeners();

    }catch(error){
      isLoading = false;

      notifyListeners();
    }
  }

  void listner(ScrollUpdateNotification notification) {
    if (notification.metrics.maxScrollExtent * 0.85 <
        notification.metrics.pixels && hasMore) {
      print('listner happend');
      if(isLoading){
        return;
      }
      print('listner actions');
      isLoading = true;
      reloadWorkList(reqPage: page);
    }
  }

  //
  fetchRecents() async {
    recentWorks = await workRepository.getRecentWorks(
        workLocationSi: selectedProvince,
        workTypeId: selectedWorkType?.id,
        workTypeDetailId: selectedWorkDetailType?.id);
    notifyListeners();
  }

  setWork(Work work) {
    selectedWork = work;
    notifyListeners();
  }

  fetchMyEmployerWork() async {
    myEmployerWork = await workRepository.getWorkAsEmployer();
    myWorks = myEmployerWork;
    notifyListeners();
  }

  fetchMyEmployeeWork() async {
    myEmployeeWork = await workRepository.getWorkAsEmployee();
    myWorks = myEmployeeWork;
    notifyListeners();
  }

  bool isDetailPageLoading = false;

  routeToWorkDetailpage(BuildContext context, int workId) async {
    isDetailPageLoading = true;
    notifyListeners();

    bool success = await fetchWorkDetailInfoAndGetCanApply(workId);
    isDetailPageLoading = false;
    notifyListeners();

    if (success) {
      Navigator.of(context).pushNamed(WorkDetailPage.routeName);
    } else {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('오류'),
          content: const Text('일감 정보를 가져오는 데 실패했습니다.'),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        ),
      );
    }
  }

  Future<bool> fetchWorkDetailInfoAndGetCanApply(int workId) async {
    canApply = true;
    initCanApply();
    Work? cwork = await workRepository.getWork(workId);
    if (cwork == null) {
      return false;
    }
    int? userid = await baseAPI.getJWT();
    selectedWork = cwork;
    // 날짜가 지난 경우
    DateTime now = DateTime.now();
    if(DateTime.parse(selectedWork?.workDate ?? '2024-12-23').add(Duration(days: 1)).compareTo(now) < 0){
      canApply =false;
    }
    if(selectedWork?.appliesList?.any((elem)=> elem.applier?.id == userid) ?? false){
      canApply = false;
    }


    if (selectedWork?.employee != null) {
      canApply = false;
    }

    if (selectedWork?.employer?.id == userid) {
      canApply = false;
    }

    notifyListeners();
    return true;
  }

  initCanApply() {
    canApply = true;
  }

  reviewWork(String content, int starCount, String? imageURL, int? work_id,
      int? targetId) async {
    await workRepository.reviewWork(
        content, starCount, imageURL, work_id ?? -1, targetId ?? -1);
    fetchWorkDetailInfoAndGetCanApply(work_id ?? selectedWork?.id ?? -1);
    initCanApply();
  }
  editReview(String content, int starCount, String? imageURL, int? reviewID,
      ) async {
    await workRepository.editWork(
        content, starCount, imageURL, reviewID ?? -1);
    fetchWorkDetailInfoAndGetCanApply(selectedWork?.id ?? -1);
    initCanApply();
  }

  removeReview(int reviewId) async {
    await workRepository.removeReview(reviewId);
    fetchWorkDetailInfoAndGetCanApply(selectedWork?.id ?? -1);
  }
}
