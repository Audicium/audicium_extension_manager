import 'package:flutter/cupertino.dart';

mixin PageStatusMixin {
  final pageState = ValueNotifier(PageState.loading);

  bool get isPageLoading => pageState.value == PageState.loading;

  bool get isPageComplete => pageState.value == PageState.complete;

  bool get isPageError => pageState.value == PageState.error;

  bool get isPageEmpty => pageState.value == PageState.empty;

  bool get isPageIdle => pageState.value == PageState.idle;

  set updatePageState(PageState value) => pageState.value = value;

  void pageLoading() => updatePageState = PageState.loading;

  void pageComplete() => updatePageState = PageState.complete;

  void pageError() => updatePageState = PageState.error;

  void pageEmpty() => updatePageState = PageState.empty;

  void pageIdle() => updatePageState = PageState.idle;
}

/// defines the state of the page,
///
/// loading: loading data
///
/// complete: no more data to load
///
/// error: error loading data
///
/// empty: no data loaded
///
/// idle: no action requested
enum PageState {
  loading,
  error,
  empty,
  complete,
  idle,
}
