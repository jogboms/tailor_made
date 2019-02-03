import 'dart:async';

import 'package:rxdart/rxdart.dart' show BehaviorSubject, Observable, Subject;

typedef Future<T> MkStreamBlocBuilder<T>();
typedef Future<T> MkStreamPageBlocBuilder<T>(int limit);

// NOTE: hack-like in-memory storage of the last list bloc
// since we don't have sockets, i need a means to refresh the list after updating a job
class MkStreamableLatest {
  static MkStreamable _bloc;

  static set setBloc(MkStreamable bloc) => _bloc = bloc;
  static MkStreamable get getBloc => _bloc;
}

class StreamState<T> {
  const StreamState({
    this.data,
    this.isLoading,
    this.isLoadMore = false,
    this.hasError = false,
    this.error,
  });

  const StreamState.initialState()
      : data = null,
        isLoading = false,
        isLoadMore = false,
        hasError = false,
        error = null;

  final T data;
  final bool isLoading;
  final bool isLoadMore;
  final bool hasError;
  final dynamic error;
}

abstract class MkStreamable<T> {
  Stream<T> get stream;
  void refresh();
  void dispose();
}

class MkStreamBloc<T> implements MkStreamable<StreamState<T>> {
  MkStreamBloc(this._builder, {this.cachedData, this.skipFirst = false})
      : assert(skipFirst != null),
        _controller = skipFirst
            ? BehaviorSubject<Future<T>>()
            : BehaviorSubject<Future<T>>(seedValue: _builder());

  T cachedData;
  bool skipFirst;
  final MkStreamBlocBuilder<T> _builder;
  final Subject<Future<T>> _controller;
  final _isLoading = BehaviorSubject<bool>(seedValue: true);
  final _error = BehaviorSubject<dynamic>(seedValue: 0);

  @override
  Stream<StreamState<T>> get stream =>
      Observable.combineLatest3<T, bool, dynamic, StreamState<T>>(
        _controller.stream.switchMap(
          (mapper) => Observable.fromFuture(mapper).doOnEach(
                (_) {
                  _isLoading.add(false);
                },
              ).onErrorReturnWith(
                (dynamic error) {
                  _error.add(error);
                  return null;
                },
              ).doOnData((data) => cachedData = data),
        ),
        _isLoading.stream,
        _error.stream,
        _buildState,
      ).distinct();

  @override
  void refresh() {
    _error.add(0);
    _isLoading.add(true);
    _controller.add(_builder());
  }

  @override
  void dispose() {
    _controller.close();
    _error.close();
    _isLoading.close();
  }

  StreamState<T> _buildState(
    T data,
    bool isLoading,
    dynamic error,
  ) {
    return StreamState(
      data: data,
      isLoading: isLoading,
      hasError: data == null,
      error: error == 0 ? null : error,
    );
  }
}
