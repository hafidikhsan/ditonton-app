// Mocks generated by Mockito 5.1.0 from annotations
// in ditonton/test/presentation/pages/series_detail_page_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i13;
import 'dart:ui' as _i14;

import 'package:ditonton/common/state_enum.dart' as _i10;
import 'package:ditonton/domain/entities/episodes.dart' as _i12;
import 'package:ditonton/domain/entities/series.dart' as _i11;
import 'package:ditonton/domain/entities/series_detail.dart' as _i8;
import 'package:ditonton/domain/usecases/get_series_detail.dart' as _i2;
import 'package:ditonton/domain/usecases/get_series_episodes.dart' as _i4;
import 'package:ditonton/domain/usecases/get_series_recomendation.dart' as _i3;
import 'package:ditonton/domain/usecases/get_watchlist_status_series.dart'
    as _i5;
import 'package:ditonton/domain/usecases/remove_watchlist_series.dart' as _i7;
import 'package:ditonton/domain/usecases/save_watchlist_series.dart' as _i6;
import 'package:ditonton/presentation/provider/series_detail_notifier.dart'
    as _i9;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeGetSeriesDetail_0 extends _i1.Fake implements _i2.GetSeriesDetail {}

class _FakeGetSeriesRecommendations_1 extends _i1.Fake
    implements _i3.GetSeriesRecommendations {}

class _FakeGetSeriesEpisodes_2 extends _i1.Fake
    implements _i4.GetSeriesEpisodes {}

class _FakeGetWatchListStatusSeries_3 extends _i1.Fake
    implements _i5.GetWatchListStatusSeries {}

class _FakeSaveWatchlistSeries_4 extends _i1.Fake
    implements _i6.SaveWatchlistSeries {}

class _FakeRemoveWatchlistSeries_5 extends _i1.Fake
    implements _i7.RemoveWatchlistSeries {}

class _FakeSeriesDetail_6 extends _i1.Fake implements _i8.SeriesDetail {}

/// A class which mocks [SeriesDetailNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockSeriesDetailNotifier extends _i1.Mock
    implements _i9.SeriesDetailNotifier {
  MockSeriesDetailNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetSeriesDetail get getSeriesDetail =>
      (super.noSuchMethod(Invocation.getter(#getSeriesDetail),
          returnValue: _FakeGetSeriesDetail_0()) as _i2.GetSeriesDetail);
  @override
  _i3.GetSeriesRecommendations get getSeriesRecommendations =>
      (super.noSuchMethod(Invocation.getter(#getSeriesRecommendations),
              returnValue: _FakeGetSeriesRecommendations_1())
          as _i3.GetSeriesRecommendations);
  @override
  _i4.GetSeriesEpisodes get getSeriesEpisodes =>
      (super.noSuchMethod(Invocation.getter(#getSeriesEpisodes),
          returnValue: _FakeGetSeriesEpisodes_2()) as _i4.GetSeriesEpisodes);
  @override
  _i5.GetWatchListStatusSeries get getWatchListStatus =>
      (super.noSuchMethod(Invocation.getter(#getWatchListStatus),
              returnValue: _FakeGetWatchListStatusSeries_3())
          as _i5.GetWatchListStatusSeries);
  @override
  _i6.SaveWatchlistSeries get saveWatchlist => (super.noSuchMethod(
      Invocation.getter(#saveWatchlist),
      returnValue: _FakeSaveWatchlistSeries_4()) as _i6.SaveWatchlistSeries);
  @override
  _i7.RemoveWatchlistSeries get removeWatchlist =>
      (super.noSuchMethod(Invocation.getter(#removeWatchlist),
              returnValue: _FakeRemoveWatchlistSeries_5())
          as _i7.RemoveWatchlistSeries);
  @override
  _i8.SeriesDetail get series => (super.noSuchMethod(Invocation.getter(#series),
      returnValue: _FakeSeriesDetail_6()) as _i8.SeriesDetail);
  @override
  List<int> get season =>
      (super.noSuchMethod(Invocation.getter(#season), returnValue: <int>[])
          as List<int>);
  @override
  int get seasonValue =>
      (super.noSuchMethod(Invocation.getter(#seasonValue), returnValue: 0)
          as int);
  @override
  int get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: 0) as int);
  @override
  _i10.RequestState get seriesState =>
      (super.noSuchMethod(Invocation.getter(#seriesState),
          returnValue: _i10.RequestState.Empty) as _i10.RequestState);
  @override
  List<_i11.Series> get seriesRecommendations =>
      (super.noSuchMethod(Invocation.getter(#seriesRecommendations),
          returnValue: <_i11.Series>[]) as List<_i11.Series>);
  @override
  _i10.RequestState get recommendationState =>
      (super.noSuchMethod(Invocation.getter(#recommendationState),
          returnValue: _i10.RequestState.Empty) as _i10.RequestState);
  @override
  List<_i12.Episodes> get seriesEpisodes =>
      (super.noSuchMethod(Invocation.getter(#seriesEpisodes),
          returnValue: <_i12.Episodes>[]) as List<_i12.Episodes>);
  @override
  _i10.RequestState get episodesState =>
      (super.noSuchMethod(Invocation.getter(#episodesState),
          returnValue: _i10.RequestState.Empty) as _i10.RequestState);
  @override
  String get message =>
      (super.noSuchMethod(Invocation.getter(#message), returnValue: '')
          as String);
  @override
  bool get isAddedToWatchlist =>
      (super.noSuchMethod(Invocation.getter(#isAddedToWatchlist),
          returnValue: false) as bool);
  @override
  set selectedSeason(int? value) =>
      super.noSuchMethod(Invocation.setter(#selectedSeason, value),
          returnValueForMissingStub: null);
  @override
  String get watchlistMessage =>
      (super.noSuchMethod(Invocation.getter(#watchlistMessage), returnValue: '')
          as String);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i13.Future<void> fetchSeriesDetail(int? id) => (super.noSuchMethod(
      Invocation.method(#fetchSeriesDetail, [id]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i13.Future<void>);
  @override
  _i13.Future<void> getEpisodes() => (super.noSuchMethod(
      Invocation.method(#getEpisodes, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i13.Future<void>);
  @override
  _i13.Future<void> addWatchlist(_i8.SeriesDetail? movie) =>
      (super.noSuchMethod(Invocation.method(#addWatchlist, [movie]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i13.Future<void>);
  @override
  _i13.Future<void> removeFromWatchlist(_i8.SeriesDetail? movie) =>
      (super.noSuchMethod(Invocation.method(#removeFromWatchlist, [movie]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i13.Future<void>);
  @override
  _i13.Future<void> loadWatchlistStatus(int? id) => (super.noSuchMethod(
      Invocation.method(#loadWatchlistStatus, [id]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i13.Future<void>);
  @override
  void addListener(_i14.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i14.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}