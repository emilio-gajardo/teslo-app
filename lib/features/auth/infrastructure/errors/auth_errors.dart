class WrongCredentials implements Exception {}
class InvalidToken implements Exception {}
class ConnectionTimeout implements Exception {}

class CustomError implements Exception {
  final String message;
  // final int errorCode;
  // final bool loggedRequired; /// bandera para optar a guardar el registro en el log persistente

  CustomError(
    this.message,
    /*this.errorCode*/
    // [this.loggedRequired = false]
  );
}