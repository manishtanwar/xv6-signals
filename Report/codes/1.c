// Set Signal handler for sig_num type where sig_num is b/w 0 to 3
int sig_set(int sig_num, sighandler_t handler);

/* Sends a signal to dest_pid process' sig_num Signal Handler
with argument sig_arg(Pointing to an 8 bytes message) */
int sig_send(int dest_pid, int sig_num, void *sig_arg);

// Block the process until a signal is received
int sig_pause(void);

/* Syscall for returning from signal handling(called by 
wrapping code on stack) */
int sig_ret(void);