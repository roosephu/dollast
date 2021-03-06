#include <cstdio>
#include <map>
#include <cstring>
#include <cstdlib>
#include <cassert>
#include <ctime>
#include <cctype>
#include <cmath>
#include <unistd.h>
#include <sys/types.h>
#include <sys/ptrace.h>
#include <sys/wait.h>
#include <sys/resource.h>
#include <sys/user.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <set>
#include <string>
#include <fstream>
#include <iostream>
using namespace std;

#define DEBUG
typedef int (*cmp_t)(const void *, const void *);
typedef unsigned uint;
typedef long long int64;
typedef unsigned long long uint64;
#define max(i, j) ({int _ = (i), __ = (j); _ > __ ? _ : __;})
#define min(i, j) ({int _ = (i), __ = (j); _ < __ ? _ : __;})
#define swap(T, i, j) ({T _ = (i); (i) = (j); (j) = _;})
#define oo 0x3F3F3F3F
#ifdef DEBUG
#define cerr(...) fprintf(stderr, __VA_ARGS__)
#else
#define cerr(...) ({})
#define ctime() ({})
#endif
#define CR cerr("\n")

#define max_sys_calls 500
#define max_call_len 50
#define max_file_name 1000
#define max_white_list 100
#define maxcmd 1000

pid_t pid;
char *program, *fn_in, *fn_out;
string syscall_name[max_sys_calls];
map<string, int> syscall_ids;

set<string> white_list;

int maxcnt[max_sys_calls];
double utm_lmt;
long long mem_lmt, stk_lmt, out_lmt;

void setlimit(int resource, int val) {
    struct rlimit L;
    getrlimit(resource, &L);
    L.rlim_cur = val;
    setrlimit(resource, &L);
}

void run_child() {
    // cerr("[runner] change limits\n");
    setlimit(RLIMIT_CPU  , (int)utm_lmt + 1);
    setlimit(RLIMIT_STACK, stk_lmt);
    setlimit(RLIMIT_RSS  , mem_lmt);
    setlimit(RLIMIT_FSIZE, out_lmt);

    // cerr("[runner] redirect stdin/stdout/stderr\n");
    int f = 0;
    ptrace(PT_TRACE_ME, 0, NULL, NULL);
    f = open(fn_in , O_RDONLY); close(0); dup(f); close(f);
    f = open(fn_out, O_WRONLY); close(1); dup(f); close(f);
    // close(2);

    execl(program, program, NULL);
}

void run_parent(pid_t pid) {
    int mx_cnt = 4;
    for ( ; ; ) {
        int stat = 0;
        wait(&stat);
        // cerr("[runner] status = %d\n", stat);
        if (WIFEXITED(stat)) {
            // cerr("[runner] subprocess has stopped, exitcode: %d\n", WEXITSTATUS(stat));
            int exitcode = WEXITSTATUS(stat);

            struct rusage res;
            getrusage(RUSAGE_CHILDREN, &res);
            // cerr("[runner] utime: %ld usec\n", res.ru_utime.tv_usec);
            // cerr("[runner] stime: %ld usec\n", res.ru_stime.tv_usec);
            // cerr("[runner] maxrss: %ld KB\n", res.ru_maxrss);
            double used_time = res.ru_utime.tv_usec / 1000000.0 + res.ru_utime.tv_sec;
            double used_mem  = res.ru_maxrss / 1024.0;

            const char *msg = "OK";
            int score = 0;
            if (exitcode != 0)
                msg = "RE";
            else if (used_time > utm_lmt)
                msg = "XCPU";
            else if (used_mem > mem_lmt / 1048576.0)
                msg = "XMEM";
            else
                score = 1;

            if (exitcode != 0)
                cerr("{\"score\": %d, \"status\": \"%s\", \"time\": %.6f, \"space\": %.6f, \"message\": \"exit with code %d.\"}\n", score, msg, used_time, used_mem, exitcode);
            else
                cerr("{\"score\": %d, \"status\": \"%s\", \"time\": %.6f, \"space\": %.6f}\n", score, msg, used_time, used_mem);
            break;
        }
        if (WSTOPSIG(stat) != SIGTRAP) {
            int sig = WSTOPSIG(stat); const char *msg = "";
            switch (sig) {
            case SIGXCPU: msg = "XCPU"; break; // TLE
            case SIGFPE : msg = "FPE" ; break; // floating-point-exception
            case SIGQUIT: msg = "QUIT"; break; // user quit
            case SIGXFSZ: msg = "XFSZ"; break; // file-size-limit-exceeded
            case SIGSEGV: msg = "SEGV"; break; // segment fault
            default     :
                msg = "UNKW";
                printf("unknown signal %d\n", sig);
                break; // unknown-signal
            }
            // cerr("[runner]%s\n", msg);
            if (sig == SIGXCPU)
                cerr("{\"score\": 0, \"status\": \"%s\", \"time\": %.6f}\n", msg, utm_lmt);
            else
                cerr("{\"score\": 0, \"status\": \"%s\"}\n", msg);


            ptrace(PT_KILL, pid, NULL, NULL);
            break;
        }

        ptrace(PT_CONTINUE, pid, (caddr_t)1, NULL);
    }
}

void load_syscalls(string conf) {
    ifstream fin(conf);
    assert(fin);
    int id;
    for (string name; fin >> name >> id; ) {
        syscall_name[id] = name;
        syscall_ids[name] = id;
    }
}

void load_white_list(string conf) {
    ifstream fin(conf);
    assert(fin);

    white_list.clear();
    for (string file; fin >> file; )
        white_list.insert(file);
}

void load_func_conf(string conf) {
    ifstream fin(conf); assert(fin);

    string name;
    for (int cnt; fin >> name >> cnt; ) {
        int id = syscall_ids[name];
        maxcnt[id] = cnt;
    }
}

void init(int argc, char **args) {
    double x;

    memset(maxcnt, 0, sizeof(maxcnt));
    load_syscalls  ("syscalls.conf" );
    load_func_conf ("func.conf"     );
    load_white_list("whitelist.conf");

    program = args[1];
    sscanf(args[2], "%lf", &utm_lmt), assert(utm_lmt > 0);
    sscanf(args[3], "%lf", &x), mem_lmt = max(x * 1024 * 1024, -1);
    sscanf(args[4], "%lf", &x), stk_lmt = max(x * 1024 * 1024, -1);
    sscanf(args[5], "%lf", &x), out_lmt = max(x * 1024 * 1024, -1);
    fn_in  = args[6];
    fn_out = args[7];

    // cerr("[runner] init finished\n");
}

int main(int argc, char **args) {
    if (argc < 7) {
        printf("usage: %s program TL ML SL OL IN OUT\n", args[0]);
        return 1;
    }
    init(argc, args);

    if ((pid = fork()) == 0) {
        run_child();
    } else {
        run_parent(pid);
    }

    return 0;
}
