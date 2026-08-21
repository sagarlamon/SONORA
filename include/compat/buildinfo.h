#ifndef SONORA_BUILD_CONFIG_H
#define SONORA_BUILD_CONFIG_H

/* Turns an unquoted -D value into a real string literal at compile time,
 * so the Makefile never has to pass literal quote characters through the
 * shell to gcc. Works identically on Linux, macOS, and MSYS2/MinGW. */
#define _SONORA_STR(x) #x
#define _SONORA_XSTR(x) _SONORA_STR(x)

#ifdef SONORA_VERSION_RAW
#define SONORA_VERSION _SONORA_XSTR(SONORA_VERSION_RAW)
#endif

#ifdef SONORA_DATADIR_RAW
#define SONORA_DATADIR _SONORA_XSTR(SONORA_DATADIR_RAW)
#endif

#ifdef PREFIX_RAW
#define PREFIX _SONORA_XSTR(PREFIX_RAW)
#endif

#ifdef LOCALEDIR_RAW
#define LOCALEDIR _SONORA_XSTR(LOCALEDIR_RAW)
#endif

#endif /* SONORA_BUILD_CONFIG_H */

