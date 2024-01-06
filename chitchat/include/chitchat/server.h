#include <chitchat/lib.h>

#define MAX_CONNECTIONS 10

struct AcceptedSocket
{
    int acceptedSocketFD; // would contain error code if not acceptedSuccessfully
    struct sockaddr_in address;
    bool acceptedSuccessfully;
    int idx; // idx in the connection array
    char *name;
};

struct AcceptedSocket *acceptIncomingConnectionGetFD(int socketFD);
void *handleRequest(void *socketFD);
int findSmallestIdxInConnectionArray();
void joinThreadsFromThreadsArray();
void sendMessageToOtherChats(struct AcceptedSocket *currSocket, char *header, char *chat);
