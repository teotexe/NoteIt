abstract class Resource<T> {
  final T? data;
  final String? message;

  Resource({this.data, this.message});
}

class Success<T> extends Resource<T> {
  Success(T data) : super(data: data);
}

class Error<T> extends Resource<T> {
  Error(String message, {T? data}) : super(data: data, message: message);
}

class Loading<T> extends Resource<T> {
  Loading({T? data}) : super(data: data);
}
