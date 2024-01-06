#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <chitchat/config.h>
#include <pthread.h>
#include <sys/time.h>
#include <unistd.h>

#define PORT 2000

int createIPv4SocketFD();
struct sockaddr_in *createTCPIPv4Address(char ip_addr[], int port);
char *formattedChat(char *buffer, int size, char *name);