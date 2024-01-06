#include <chitchat/lib.h>

static struct timeval t1;

int createIPv4SocketFD()
{
    int socketFD = socket(AF_INET, SOCK_STREAM, 0);
    if (socketFD < 0)
    {
        perror("[Err] can't create socket");
        exit(1);
    }
    return socketFD;
}

struct sockaddr_in *createTCPIPv4Address(char ip_addr[], int port)
{
    struct sockaddr_in *socketAddr = (struct sockaddr_in *)malloc(sizeof(struct sockaddr_in));
    socketAddr->sin_family = AF_INET;
    socketAddr->sin_port = htons(port);
    if (strlen(ip_addr) == 0)
        socketAddr->sin_addr.s_addr = INADDR_ANY;
    else
        inet_pton(AF_INET, ip_addr, &(socketAddr->sin_addr.s_addr));
    return socketAddr;
}

char *formattedChat(char *buffer, int size, char *name)
{
    gettimeofday(&t1, NULL);
    snprintf(buffer, size, "[%lds %6s]:", t1.tv_sec, name);
    return buffer;
}