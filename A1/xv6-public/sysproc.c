#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

// added functions:

int toggle_flag = 0;
#define NoSysCalls 27

extern int system_call_count[NoSysCalls];
extern char *system_call_names[NoSysCalls];

int
sys_print_count(void){
  for(int i = 0 ; i < NoSysCalls; i++){
    if(system_call_count[i] > 0)
    cprintf("%s %d\n", system_call_names[i], system_call_count[i]);
  }
  return 1;
}

int 
sys_toggle(void)
{
  if(toggle_flag == 0){
    for(int i = 0; i < NoSysCalls; i++)
      system_call_count[i] = 0;
  }
  toggle_flag ^= 1;
  return 1;
}

int
sys_add(void)
{
  int a,b;
  
  // return error if can't fetch the arguments
  if(argint(0, &a) < 0 || argint(1, &b) < 0)
    return -1;

  return (a+b);
}

int 
sys_ps(void){
  ps_print_list();
  return 1;
}

// IPC unicast:

int 
sys_send(void){
  int sender_pid, rec_pid;
  char* msg;
  char* physical_address_msg;
  // fetch the arguments
  if(argint(0, &sender_pid) < 0 || argint(1, &rec_pid) < 0 || argptr(2, &msg, MSGSIZE) < 0)
    return -1;
  if(fetchstr((uint)msg, &physical_address_msg) < 0)
    return -1;
  return send_msg(sender_pid, rec_pid, physical_address_msg);
}

int 
sys_recv(void){
  char* msg;
  char* physical_address_msg;
  // fetch the arguments
  if(argptr(0, &msg, MSGSIZE) < 0)
    return -1;
  if(fetchstr((uint)msg, &physical_address_msg) < 0)
    return -1;
  return recv_msg(physical_address_msg);
}

// Signals:

int
sys_sig_set(void){
  return 0;
}

int
sys_sig_send(void){
  return 0;
}

int
sys_sig_pause(void){
  return sig_pause();
}

int
sys_sig_ret(void){
  return sig_ret();
}

// IPC multicast:
int
sys_send_multi(void){
  int sender_pid, *rec_pids;
  char* msg;
  char* physical_address_msg;
  // fetch the arguments
  if(argint(0, &sender_pid) < 0 || argptr(1, &rec_pids) < 0 || argptr(2, &msg, MSGSIZE) < 0)
    return -1;
  if(fetchstr((uint)msg, &physical_address_msg) < 0)
    return -1;
  return send_msg(sender_pid, rec_pids, physical_address_msg);
  return 1;
}