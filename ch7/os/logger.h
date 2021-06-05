enum LOG_LEVEL {
    TRACE = 0, INFO, WARN, ERROR, NONE,
};

enum LOG_COLOR {
    BLACK = 30, RED = 31, GREEN = 32, YELLOW = 33, BLUE = 34, PINK = 35, YOUND = 36, WHITE = 37, BRIGHT_YOUND = 96
};

extern int COLOR[];
extern const char* LEVEL[];
extern int debug_level;
extern int curr_pid;

#define logger(level, fmt, ...) {                                                                           \
    if(debug_level <= level)                                                                                \
        printf("\x1b[%dm[%s][%d] "fmt"\x1b[0m", COLOR[level], LEVEL[level], curr_pid, ##__VA_ARGS__);       \
}

#define info(fmt, ...) \
            logger(INFO, fmt, ##__VA_ARGS__)

#define warn(fmt, ...) \
            logger(WARN, fmt, ##__VA_ARGS__)

#define error(fmt, ...) \
            logger(ERROR, fmt, ##__VA_ARGS__)

#define trace(fmt, ...) \
            logger(TRACE, fmt, ##__VA_ARGS__)

