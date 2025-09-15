#ifndef YRT_EXTERN

#ifdef __cplusplus
#define YRT_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define YRT_EXTERN extern __attribute__((visibility ("default")))
#endif

#endif
