enum RequestStatus {
  initial,
  loading,
  loaded,
  error,
  updated,
  warning,
  loadingMore;

  bool isInitial() => this == RequestStatus.initial;

  bool isLoading() => this == RequestStatus.loading;

  bool isLoaded() => this == RequestStatus.loaded;

  bool isUpdated() => this == RequestStatus.updated;

  bool isError() => this == RequestStatus.error;

  bool isWarning() => this == RequestStatus.warning;

  bool isLoadingMore() => this == RequestStatus.loadingMore;
}
