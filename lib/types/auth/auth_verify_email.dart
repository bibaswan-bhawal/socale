enum AuthVerifyEmailResult {
  codeDeliverySuccessful,
  codeDeliveryFailure,
  limitExceeded,
  userAlreadyConfirmed,
  errorTooManyRequests,
  unknownError,
}
