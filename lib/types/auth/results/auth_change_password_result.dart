enum AuthChangePasswordResult {
  success,
  unknownError,
  invalidPassword,
  userNotFound,
  timeout,
  notAuthorized,
  tooManyRequests,
}
