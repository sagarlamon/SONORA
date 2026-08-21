#include <limits.h>

#ifndef SONORA_PATH_MAX

#ifdef _WIN32

// Windows APIs can support longer paths with Unicode APIs.
// This is an internal buffer size, not the MAX_PATH limit.
#define SONORA_PATH_MAX 32768

#else

#ifdef PATH_MAX

#define SONORA_PATH_MAX PATH_MAX

#else

// Fallback internal buffer size when PATH_MAX is unavailable.
#if defined(__APPLE__)
#define SONORA_PATH_MAX 1024
#else
#define SONORA_PATH_MAX 4096
#endif

#endif /* PATH_MAX */

#endif /* _WIN32 */

#endif /* SONORA_PATH_MAX */


