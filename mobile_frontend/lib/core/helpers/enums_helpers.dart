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

enum CategoryType { income, purchase }

extension CategoryTypeX on CategoryType {
  static CategoryType fromString(String value) {
    return CategoryType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => CategoryType.income,
    );
  }

  static CategoryType fromValue(int? value) {
    switch (value) {
      case 1:
        return CategoryType.income;
      case -1:
        return CategoryType.purchase;
      default:
        return CategoryType.income;
    }
  }

  int get value {
    switch (this) {
      case CategoryType.income:
        return 1;
      case CategoryType.purchase:
        return -1;
    }
  }
}
