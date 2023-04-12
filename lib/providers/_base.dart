import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ticket_checker/utils/extensions.dart';

import '_mixins.dart';

/// A callback for showing error messages
typedef OnShowError = void Function(String msg, [bool? asToast]);

abstract class BaseProvider extends ChangeNotifier {
  final String? _providerName;

  String? get providerName => _providerName;

  int get deviceType {
    if (Platform.isAndroid) return 1;
    if (Platform.isIOS) return 2;
    return -1;
  }

  // Future<String?> get deviceToken async => FirebaseMessagingHelper().getToken();

  /// The default constructor
  BaseProvider({String? name})
      : _providerName = name,
        super();

  @override
  void notifyListeners() {
    try {
      super.notifyListeners();
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }
}

abstract class BaseSimpleAPIProvider<M> extends BaseProvider
    with MixinAPIProvider, MixinProgressProvider {
  // static String? _uniqueUUID;
  // String? _appVersion;
  BaseSimpleAPIProvider({String? name})
      : super(name: name ?? "BaseSimpleAPIProvider");
  M? _iModel;
  M? get iModel => _iModel;
  set _setIModel(M? value) {
    _iModel = value;
    notifyListeners();
  }

  @protected
  bool get shouldResetParams => false;

  @protected
  void resetParams() {}

  void resetIModel() {
    _iModel = null;
    notifyListeners();
  }

  /// The API service to be called.
  /// This api service is defined in the subclasses
  /// The parameters are need to defined as subclass variables
  ///
  @protected
  Future<M?> apiService();

  Future<M?> fetchFromAPIService({
    required OnShowError onShowError,
    void Function(M? m)? onSuccess,
    VoidCallback? onInvalidSession,
  }) =>
      apiService()
          .then((value) {
        _setIModel = value;
        if (onSuccess != null) {
          onSuccess(value);
        }
        return value;
      })
          .handleAPIException(
        handleAPIException: handleAPIException,
        onShowError: onShowError,
        onInvalidToken: onInvalidSession,
      )
          .then((model) {
        if (shouldResetParams) {
          resetParams();
        }
        return model;
      })
          .coverWithProgress(this);
}

abstract class BaseListLoadMoreProvider<IM> extends BaseProvider
    with MixinAPIProvider, MixinProgressProvider {
  final _list = <IM>[];

  int? _pageCount;

  BaseListLoadMoreProvider({String? name})
      : super(name: name ?? "BaseListLoadMoreProvider");
  int _page = 0;
  bool _isAllCompleted = false;

  List<IM> get list => _list;

  int get page => _page;

  int get nextPage => _page + 1;

  bool get canLoadMore => (!_isAllCompleted) && (!super.isLoading);

  set _addToList(List<IM>? value) {
    if (value?.isNotEmpty ?? false) {
      _list.addAll(value!);
    }
    notifyListeners();
  }

  Future<ListLoadOptionModel<IM>?> apiService();

  // Future<List<IM>> fetchAPIService();
  Future<ListLoadOptionModel<IM>?> fetchListData({
    required OnShowError onShowError,
    ValueChanged<List<IM>?>? onSuccess,
    VoidCallback? onInit,
  }) async {
    if (super.isLoading) return null;
    super.isLoading = true;

    // print("####### after onInit");
    // await Future.delayed(const Duration(seconds: 2));
    if (onInit != null) {
      onInit();
    }
    return apiService()
        .then((model) {
      _isAllCompleted = computeIsCompleted(model);
      _addToList = model?.iList;
      if (onSuccess != null) onSuccess(model?.iList);
      return model;
    })
        .handleAPIException(
      handleAPIException: handleAPIException,
      onShowError: onShowError,
    )
        .whenComplete(() => super.isLoading = false);
    // super.isLoading = false;
    // print("####### after future api");
  }

  void reset() {
    _pageCount = null;
    _page = 0;
    _isAllCompleted = false;
    _list.clear();
  }

  bool computeIsCompleted(ListLoadOptionModel<IM>? model) {
    _pageCount = model?.pageCount;
    _page = model?.currentPage ?? 1;

    return _page >= (_pageCount ?? 0);
  }
}

class ListLoadOptionModel<IM> {
  int? totalCount;
  int? pageCount;
  int? currentPage;
  int? perPage;

  List<IM>? iList;

  ListLoadOptionModel({
    required this.totalCount,
    required this.pageCount,
    required this.currentPage,
    required this.perPage,
    required this.iList,
  });

}