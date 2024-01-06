#include <chitchat/server.h>

struct AcceptedSocket *acceptedSockets[MAX_CONNECTIONS];
pthread_t threads[MAX_CONNECTIONS];
int port = PORT;

int main(int argc, char **argv)
{
    printf("%s version %d.%d\n", argv[0], chitchat_VERSION_MAJOR, chitchat_VERSION_MINOR);

    // prepare global variables
    memset(acceptedSockets, 0, sizeof(struct AcceptedSocket *) * MAX_CONNECTIONS);
    memset(threads, 0, sizeof(pthread_t) * MAX_CONNECTIONS);

    // accept port from argument
    if (argc == 2)
        port = atoi(argv[2]);

    int socketFD = createIPv4SocketFD();
    char acceptAnyIP[] = "";
    struct sockaddr_in *serverAddr = createTCPIPv4Address(acceptAnyIP, port);

    int result = bind(socketFD, (sockaddr *)serverAddr, sizeof(*serverAddr));
    if (result == 0)
        printf("socket bound successfully\n");
    else
    {
        perror("[Err] socket bind failed");
        exit(1);
    }

    int listenResult = listen(socketFD, MAX_CONNECTIONS);
    // NOTE marks that socket as passive
    if (listenResult == -1)
    {
        perror("[Err] listening failed");
        exit(1);
    }

    while (true)
    {
        struct AcceptedSocket *clientSocket = acceptIncomingConnectionGetFD(socketFD);
        if (clientSocket->acceptedSocketFD < 0)
        {
            perror("[Err] couldn't accept incoming connection");
            continue;
        }

        int idx = findSmallestIdxInConnectionArray();
        clientSocket->idx = idx;
        acceptedSockets[idx] = clientSocket;

        pthread_t id;
        pthread_create(&id, NULL, &handleRequest, (void *)clientSocket);
        threads[idx] = id;
    }
    // pthread_join(id, NULL);

    free(serverAddr);
    shutdown(socketFD, SHUT_RDWR);
    return 0;
}

int findSmallestIdxInConnectionArray()
{
    for (int i = 0; i < MAX_CONNECTIONS; i++)
    {
        if (acceptedSockets[i] == NULL)
            return i;
    }
    return -1;
}

struct AcceptedSocket *acceptIncomingConnectionGetFD(int socketFD)
{
    struct AcceptedSocket *clientSocket = (struct AcceptedSocket *)malloc(sizeof(struct AcceptedSocket));
    socklen_t clientAddrSize = sizeof(struct sockaddr_in);
    joinThreadsFromThreadsArray();

    printf("Waiting for connection...\n");
    // NOTE blocked at accept until connection establishes
    int clientFD = accept(socketFD, (struct sockaddr *)&(clientSocket->address), &clientAddrSize);
    printf("Connection established with %d:%d\n", clientSocket->address.sin_addr.s_addr, clientSocket->address.sin_port);

    clientSocket->acceptedSocketFD = clientFD;
    clientSocket->acceptedSuccessfully = clientFD > 0;

    return clientSocket;
}

void joinThreadsFromThreadsArray()
{
    for (int i = 0; i < MAX_CONNECTIONS; i++)
    {
        if (acceptedSockets[i] == NULL && threads[i] != 0)
        {
            pthread_join(threads[i], NULL);
            threads[i] = 0;
        }
    }
}

void *handleRequest(void *clientSocketVoid)
{
    struct AcceptedSocket *clientSocket = (struct AcceptedSocket *)clientSocketVoid;
    printf("ClientFD: %d connected\n", clientSocket->acceptedSocketFD);
    char name[1024];
    ssize_t bytesRecv = recv(clientSocket->acceptedSocketFD,
                             name,
                             1024,
                             0);
    name[bytesRecv] = 0;
    clientSocket->name = name; // using local variable as global pointer because it's relevant only while inside this function

    char recBuf[1024];
    char outputHeader[100];
    while (true)
    {
        ssize_t bytesRecv = recv(clientSocket->acceptedSocketFD,
                                 recBuf,
                                 1024,
                                 0);
        if (bytesRecv == 0 || bytesRecv == -1)
            break;

        recBuf[bytesRecv - 1] = 0;
        formattedChat(outputHeader, 100, name);
        printf("%s %s\n", outputHeader, recBuf);
        sendMessageToOtherChats(clientSocket, outputHeader, recBuf);
    }
    printf("ClientFD: %d disconnected\n", clientSocket->acceptedSocketFD);
    close(clientSocket->acceptedSocketFD);
    acceptedSockets[clientSocket->idx] = NULL;
    free(clientSocket);

    return NULL;
}

void sendMessageToOtherChats(struct AcceptedSocket *currSocket, char *header, char *chat)
{
    char buffer[1024];
    for (int i = 0; i < MAX_CONNECTIONS; i++)
    {
        int sendToThis = acceptedSockets[i] != NULL && acceptedSockets[i]->acceptedSocketFD != currSocket->acceptedSocketFD;
        if (!sendToThis)
            continue;
        int charCount = snprintf(buffer, 1023, "%s %s\n", header, chat);

        send(acceptedSockets[i]->acceptedSocketFD,
             buffer,
             charCount,
             0);
    }
}