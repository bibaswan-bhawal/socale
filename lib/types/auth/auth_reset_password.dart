enum AuthResetPasswordResult {
  codeDeliverySuccessful,
  codeDeliveryFailure,
  tooManyRequests,
  success,
  unknownError,
  codeMismatch,
  expiredCode,
  userNotFound,
}
