import 'package:meta/meta.dart';

@sealed
abstract class StateController<T> {
  StateController();

  @override
  String toString() =>
      'Resource of '
      'status: $status, '
      'data: $inferredData, '
      'error message: $inferredErrorMessage';

  factory StateController.idle({T? data}) {
    return Idle(data);
  }

  factory StateController.loading({T? data}) {
    return Loading(data);
  }

  factory StateController.success(T data) {
    return Success(data);
  }

  factory StateController.error({
    T? data,
    required String errorMessage,
    int? code,
  }) {
    return Error(errorMessage, code, data);
  }

  factory StateController.of({T? data, String? errorMessage}) {
    if (errorMessage != null) {
      return StateController.error(errorMessage: errorMessage, data: data);
    } else if (data != null) {
      return StateController.success(data);
    } else {
      return StateController.loading(data: data);
    }
  }

  StateController<U> transform<U>({
    required final U Function(T data) transformer,
  }) {
    final resource = this;

    if (resource is Success<T>) {
      return StateController.success(transformer.call(resource.data));
    }
    final data = resource.inferredData;

    if (resource is Error<T>) {
      return StateController.error(
        errorMessage: resource.errorMessage,
        data: data == null ? null : transformer.call(data),
      );
    }

    if (resource is Loading<T>) {
      return StateController.loading(
        data: data == null ? null : transformer.call(data),
      );
    }

    return StateController.idle();
  }

  String? get inferredErrorMessage {
    final resource = this;

    if (resource is Error<T>) {
      return resource.errorMessage;
    }

    return null;
  }

  T? get inferredData {
    final resource = this;

    if (resource is Success<T>) {
      return resource.data;
    } else if (resource is Error<T>) {
      return resource.data;
    } else if (resource is Loading<T>) {
      return resource.data;
    }

    return null;
  }

  String get status {
    final resource = this;

    if (resource is Success<T>) {
      return StateController.statusSuccess;
    } else if (resource is Error<T>) {
      return StateController.statusError;
    } else if (resource is Loading<T>) {
      return StateController.statusLoading;
    }

    return StateController.statusIdle;
  }

  get isLoading => status == statusLoading;

  get isError => status == statusError;

  get isSuccess => status == statusSuccess;

  U compose<U>({
    required final U Function(Success<T>) onSuccess,
    final U Function(Error<T>)? onError,
    final U Function(Loading<T>)? onLoading,
    final U Function()? onIdle,
    required final U orElse,
  }) {
    final resource = this;

    if (resource is Success<T>) {
      return onSuccess(resource);
    } else if (resource is Error<T>) {
      return onError?.call(resource) ?? orElse;
    } else if (resource is Loading<T>) {
      return onLoading?.call(resource) ?? orElse;
    } else if (resource is Idle<T>) {
      return onIdle?.call() ?? orElse;
    }

    return orElse;
  }

  U? onSuccess<U>(U Function(Success<T> success) successCallback) {
    final resource = this;

    return resource is Success<T> ? successCallback(resource) : null;
  }

  U? onError<U>(U Function(Error<T> error) errorCallback) {
    final resource = this;

    return resource is Error<T> ? errorCallback(resource) : null;
  }

  U? onLoading<U>(U Function(Loading<T> loading) loadingCallback) {
    final resource = this;

    return resource is Loading<T> ? loadingCallback(resource) : null;
  }

  static const statusSuccess = "success";
  static const statusError = "error";
  static const statusLoading = "loading";
  static const statusIdle = "idle";
}

class Loading<T> extends StateController<T> {
  Loading(this.data);

  final T? data;
}

class Idle<T> extends StateController<T> {
  Idle(this.data);

  final T? data;
}

class Success<T> extends StateController<T> {
  Success(this.data);

  final T data;
}

class Error<T> extends StateController<T> {
  Error(this.errorMessage, this.code, this.data);

  final String errorMessage;
  final int? code;
  final T? data;

  @override
  String toString() => "$code: $errorMessage";
}
