import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

typedef ShellExecuteC = ffi.Int32 Function(
    ffi.Pointer hwnd,
    ffi.Pointer lpOperation,
    ffi.Pointer lpFile,
    ffi.Pointer lpParameters,
    ffi.Pointer lpDirectory,
    ffi.Uint32 nShowCmd);
typedef ShellExecuteDart = int Function(
    ffi.Pointer parentWindow,
    ffi.Pointer operation,
    ffi.Pointer file,
    ffi.Pointer parameters,
    ffi.Pointer directory,
    int showCmd);

int ShellExecute(String operation, String file) {
  // Load shell32.
  final dylib = ffi.DynamicLibrary.open('shell32.dll');

  // Look up the `ShellExecuteW` function.
  final ShellExecuteP =
  dylib.lookupFunction<ShellExecuteC, ShellExecuteDart>('ShellExecuteW');

  // Allocate pointers to Utf8 arrays containing the command arguments.
  final operationP = Utf16.toUtf16(operation);
  final fileP = Utf16.toUtf16(file);
  const int SW_SHOWNORMAL = 1;

  // Invoke the command, and free the pointers.
  var result = ShellExecuteP(
      ffi.nullptr, operationP, fileP, ffi.nullptr, ffi.nullptr, SW_SHOWNORMAL);
  operationP.free();
  fileP.free();

  return result;
}