#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdarg.h>
#include <time.h>
#include <sys/time.h>
#include <pthread.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netdb.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>
#include <ctype.h>
#include <ifaddrs.h>
#include <string.h>
#include <assert.h>
#include <poll.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <arpa/inet.h>

int main() {
  struct ifaddrs *ifa;
  char addr[50];

  if (getifaddrs(&ifa) == -1) {
    perror("getifaddrs() failed\n");
    exit(0);
  }

  int i = -1;
  while (ifa) {
    i++;
    printf("\n%i:\n%s:\nflags:%i\n", i, ifa->ifa_name, ifa->ifa_flags);

    struct ifreq ifr;
    int sock;
    if ((sock = socket(AF_INET,SOCK_STREAM,0))<0) {
      printf("socket() error\n");
    }
    strcpy(ifr.ifr_name, ifa->ifa_name);
    if (ioctl(sock, SIOCGIFHWADDR, &ifr)<0) {
      printf("ioctl() error\n");
    }
    printf("MAC:%02x:%02x:%02x:%02x:%02x:%02x\n",
                (unsigned char)ifr.ifr_hwaddr.sa_data[0],
                (unsigned char)ifr.ifr_hwaddr.sa_data[1],
                (unsigned char)ifr.ifr_hwaddr.sa_data[2],
                (unsigned char)ifr.ifr_hwaddr.sa_data[3],
                (unsigned char)ifr.ifr_hwaddr.sa_data[4],
                (unsigned char)ifr.ifr_hwaddr.sa_data[5]    );

    if (ifa->ifa_addr) {
      if (ifa->ifa_addr->sa_family == AF_INET) {
        struct sockaddr_in *in;
        in = (struct sockaddr_in*) ifa->ifa_addr;
        inet_ntop(AF_INET, &in->sin_addr, addr, sizeof(addr));
        printf("%s", addr);
        in = (struct sockaddr_in*) ifa->ifa_netmask;
        inet_ntop(AF_INET, &in->sin_addr, addr, sizeof(addr));
        printf("/%s\n", addr);
        if (ifa->ifa_broadaddr) {
          in = (struct sockaddr_in*) ifa->ifa_broadaddr;
          inet_ntop(AF_INET, &in->sin_addr, addr, sizeof(addr));
          printf("broadaddr:%s\n", addr);
        }
        if (ifa->ifa_dstaddr) {
          in = (struct sockaddr_in*) ifa->ifa_dstaddr;
          inet_ntop(AF_INET, &in->sin_addr, addr, sizeof(addr));
          printf("dstaddr:%s\n", addr);
        }
      } else if (ifa->ifa_addr->sa_family == AF_INET6) {
        struct sockaddr_in6 *in6;
        in6 = (struct sockaddr_in6*) ifa->ifa_addr;
        inet_ntop(AF_INET6, &in6->sin6_addr, addr, sizeof(addr));
        printf("%s", addr);
        in6 = (struct sockaddr_in6*) ifa->ifa_netmask;
        inet_ntop(AF_INET6, &in6->sin6_addr, addr, sizeof(addr));
        printf("/%s\n", addr);
        if (ifa->ifa_broadaddr) {
          in6 = (struct sockaddr_in6*) ifa->ifa_broadaddr;
          inet_ntop(AF_INET6, &in6->sin6_addr, addr, sizeof(addr));
          printf("broadaddr:%s\n", addr);
        }
        if (ifa->ifa_dstaddr) {
          in6 = (struct sockaddr_in6*) ifa->ifa_dstaddr;
          inet_ntop(AF_INET6, &in6->sin6_addr, addr, sizeof(addr));
          printf("dstaddr:%s\n", addr);
        }
      } else {
      }
    }
    ifa = ifa->ifa_next;
  }
  freeifaddrs(ifa);
  return 0;
}
