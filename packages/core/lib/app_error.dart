sealed class AppError {
  const AppError(this.message);
  final String message;
}

class NetworkError extends AppError {
  const NetworkError([super.message = 'Network error']);
}

class UnauthorizedError extends AppError {
  const UnauthorizedError([super.message = 'Unauthorized']);
}

class UnknownError extends AppError {
  const UnknownError([super.message = 'Unknown error']);
}
