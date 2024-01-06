#include <chitchat/client.h>

char ip_addr[16] = "127.0.0.1";
int port = PORT;

int main(int argc, char **argv)
{
    printf("%s version %d.%d\n", argv[0], chitchat_VERSION_MAJOR, chitchat_VERSION_MINOR);

    if (argc == 3)
    {
        strcpy(ip_addr, argv[1]);
        port = atoi(argv[2]);
    }

    int socketFD = createIPv4SocketFD();
    struct sockaddr_in *socketAddr = createTCPIPv4Address(ip_addr, port);
    int connectionSuccess = connect(socketFD,
                                    (struct sockaddr *)socketAddr,
                                    sizeof(*socketAddr));
    if (connectionSuccess == 0)
        printf("connection was successful\n");
    else
    {
        perror("[Err] connection could not be made");
        exit(1);
    }

    printf("Enter your name: ");
    char *name = NULL;
    size_t nameSz = 0;
    ssize_t nameCount = getline(&name, &nameSz, stdin);
    nameCount--;
    name[nameCount] = 0;
    ssize_t bytesSent = send(socketFD,
                             name,
                             nameCount,
                             0);
    if (bytesSent == -1)
    {
        perror("[Err] couldn't send name");
        exit(1);
    }

    pthread_t id;
    pthread_create(&id, NULL, &listenToOtherClients, (void *)&socketFD);

    printf("Type any message (type 'exit' to exit)...\n");
    char *buffer = NULL;
    size_t bufferSz = 0;
    while (true)
    {
        ssize_t charCount = getline(&buffer, &bufferSz, stdin);
        ssize_t bytesSent = send(socketFD,
                                 buffer,
                                 charCount,
                                 0);
        if (bytesSent == -1 || (charCount == 5 && !strcmp(buffer, "exit\n")))
            break;
    }

    free(socketAddr);

    return 0;
}

void *listenToOtherClients(void *socketFDVoid)
{
    int socketFD = *(int *)socketFDVoid;
    char recBuf[1024];
    while (true)
    {
        ssize_t bytesRecv = recv(socketFD,
                                 recBuf,
                                 1024,
                                 0);
        if (bytesRecv == 0 || bytesRecv == -1)
            break;

        recBuf[bytesRecv - 1] = 0;
        printf("%s\n", recBuf);
    }

    return NULL;
}