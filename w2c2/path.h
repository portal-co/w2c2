#ifndef W2C2_PATH_H
#define W2C2_PATH_H

#ifdef _WIN32
#define PATH_SEPARATOR '\\'
#define PATH_SEPARATOR_STRING "\\"
#else
#define PATH_SEPARATOR '/'
#define PATH_SEPARATOR_STRING "/"
#define HAS_GLOB 1
#endif

#endif /* W2C2_PATH_H */
