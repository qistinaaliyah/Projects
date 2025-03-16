#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <sys/types.h>
#include <pwd.h>
#include <string.h>


#define MAX_QUEUE_SIZE 20
#define DEFAULT_TIMEOUT 30
#define MAX_WAIT_TIME 4


// Compile-time debug flag
#ifndef DEBUG
#define DEBUG 0 // Default: Debugging off
#endif


// Debug macro
#if DEBUG
#define DEBUG_LOG(...) log_with_timestamp("DEBUG   ", __VA_ARGS__)
#else
#define DEBUG_LOG(...) if (verbose) log_with_timestamp("DEBUG   ", __VA_ARGS__)
#endif

int verbose = 0;

typedef struct {
    int data;
    char priority; // Priority: 'L' (low), 'N' (normal), 'H' (high)
} QueueItem;


void log_with_timestamp(const char* prefix, const char* message, int id, int data, const char* priority) {
    char buffer[100];
    time_t now = time(NULL);
    struct tm* t = localtime(&now);
    strftime(buffer, sizeof(buffer), "[%Y-%m-%d %H:%M:%S]", t);
    if (id != -1) {
        if (priority && priority[0] != '\0') {
            printf("%s [%s] %s %d, data: %d, priority: %s\n", buffer, prefix, message, id, data, priority);
        } else if (data != -1) {
            printf("%s [%s] %s %d, data: %d\n", buffer, prefix, message, id, data);
        } else {
            printf("%s [%s] %s %d\n", buffer, prefix, message, id);
        }
    } else {
        printf("%s [%s] %s\n", buffer, prefix, message);
    }
}


const char* getPriorityName(char priority) {
    switch (priority) {
        case 'L': return "Low";
        case 'N': return "Normal";
        case 'H': return "High";
        default: return "Unknown";
    }
}


QueueItem queue[MAX_QUEUE_SIZE];
int front = 0, rear = 0, count = 0;
pthread_mutex_t queueMutex;
sem_t spaceAvailable, itemsAvailable;


void addtoqueue(QueueItem item) {
    if (count == MAX_QUEUE_SIZE) {
        printf("Queue is full, cannot enqueue\n");
        return;
    }
    queue[rear] = item;
    rear = (rear + 1) % MAX_QUEUE_SIZE; // Circular buffer
    count++;
    if (verbose) {
        char debugmessagequeue[50];
        snprintf(debugmessagequeue, sizeof(debugmessagequeue), "Queue size after enqueue: %d", count);
        log_with_timestamp("DEBUG   ", debugmessagequeue, -1, -1, "");
    }
}


QueueItem removefromqueue() {
    if (count == 0) {
        printf("Queue is empty, cannot dequeue\n");
        QueueItem emptyItem = {0, 'L'};
        return emptyItem;
    }


    int highestPriorityIndex = front;
    for (int i = 0; i < count; i++) {
        int index = (front + i) % MAX_QUEUE_SIZE;
        if (queue[index].priority > queue[highestPriorityIndex].priority) {
            highestPriorityIndex = index;
        }
    }
    QueueItem item = queue[highestPriorityIndex];
    for (int i = highestPriorityIndex; i != rear; i = (i + 1) % MAX_QUEUE_SIZE) {
        int nextIndex = (i + 1) % MAX_QUEUE_SIZE;
        queue[i] = queue[nextIndex];
    }
    rear = (rear - 1 + MAX_QUEUE_SIZE) % MAX_QUEUE_SIZE;
    count--;
    if (verbose) {
        char debugmessagedequeue[50];
        snprintf(debugmessagedequeue, sizeof(debugmessagedequeue), "Queue size after dequeue: %d", count);
        log_with_timestamp("DEBUG   ", debugmessagedequeue, -1, -1, "");
    }
    return item;
}


void* producertask(void* arg) {
    int producerId = (int)(size_t)arg;
    char producerstartmessage[50];
    snprintf(producerstartmessage, sizeof(producerstartmessage), "Producer %d started", producerId);
    log_with_timestamp("PRODUCER", producerstartmessage, -1, -1, "");


    while (1) {
        QueueItem item;
        item.data = rand() % 10; // Random data between 0-9
        int randPriority = rand() % 3;
        item.priority = (randPriority == 0) ? 'L' : (randPriority == 1) ? 'N' : 'H';


        sem_wait(&spaceAvailable);
        pthread_mutex_lock(&queueMutex);
        addtoqueue(item);
        pthread_mutex_unlock(&queueMutex);
        sem_post(&itemsAvailable);
        log_with_timestamp("PRODUCER", "Produced item", producerId, item.data, getPriorityName(item.priority));
        sleep(rand() % MAX_WAIT_TIME + 1);
    }
    return NULL;
}


void* consumertask(void* arg) {
    int consumerId = (int)(size_t)arg;
    char consumerstartmessage[50];
    snprintf(consumerstartmessage, sizeof(consumerstartmessage), "Consumer %d started", consumerId);
    log_with_timestamp("CONSUMER", consumerstartmessage, -1, -1, "");


    while (1) {
        sem_wait(&itemsAvailable);
        pthread_mutex_lock(&queueMutex);
        QueueItem item = removefromqueue();
        pthread_mutex_unlock(&queueMutex);
        sem_post(&spaceAvailable);
        log_with_timestamp("CONSUMER", "Consumed item", consumerId, item.data, getPriorityName(item.priority));
        sleep(rand() % MAX_WAIT_TIME + 1);
    }
    return NULL;
}


int main(int argc, char* argv[]) {
    int numProducers = 2;
    int numConsumers = 2;
    int maxQueuesize = MAX_QUEUE_SIZE;
    int timeout = DEFAULT_TIMEOUT;

    if (argc > 1) {
        for (int i = 1; i < argc; i++) {
            if (strcmp(argv[i], "--verbose") == 0) {
                verbose = 1;
            } else if (i + 4 == argc) {
                numProducers = atoi(argv[1]);
                numConsumers = atoi(argv[2]);
                maxQueuesize = atoi(argv[3]);
                timeout = atoi(argv[4]);
            }
        }
    } else {
        printf("Using default values. To specify, use: ./main <Producers> <Consumers> <Queue Size> <Timeout> [--verbose]\n");
    }


    if (numProducers < 1 || numProducers > 5 ||
        numConsumers < 1 || numConsumers > 4 ||
        maxQueuesize < 1 || maxQueuesize > MAX_QUEUE_SIZE ||
        timeout < 1) {
        printf("Invalid input. Producers must be between 1-5, Consumers 1-4, Queue size 1-20, timeout > 0\n");
        return 1;
    }

    if (verbose) {
        log_with_timestamp("SYSTEM  ", "Verbose debugging enabled", -1, -1, "");
    }


    printf("=====================Configuration======================");
    printf("\nProducers: %d, Consumers: %d, Queue Size: %d, Timeout: %d seconds\n", numProducers, numConsumers, maxQueuesize, timeout);
    printf("\nTo specify configuration, at terminal do: ./main <Producers> <Consumers> <Queue Size> <Timeout>\n");
    printf("\nTo enable DEBUGGING MODE, at terminal add --verbose at the end of configuration\n");
    //Display Compiled Model Parameters
    printf("\nCompiled Model Parameters:\n");
    printf("  Max Queue Size: %d\n", MAX_QUEUE_SIZE);
    printf("  Default Timeout: %d seconds\n", DEFAULT_TIMEOUT);
    printf("  Max Wait Time: %d seconds\n\n", MAX_WAIT_TIME);


    // Get and Display Current Time & Date
    time_t now = time(NULL); log_with_timestamp("SYSTEM", "Execution started", -1, -1, "");


// Get and Display Current User Name & Hostname 
    struct passwd *pw = getpwuid(getuid());
    char hostname[256];
    gethostname(hostname, sizeof(hostname));
    printf("  User: %s\n", pw->pw_name);
    printf("  Hostname: %s\n\n", hostname);
    printf("=========================================================\n");


    pthread_mutex_init(&queueMutex, NULL);
    sem_init(&spaceAvailable, 0, maxQueuesize);
    sem_init(&itemsAvailable, 0, 0);


    pthread_t producerThreads[numProducers];
    pthread_t consumerThreads[numConsumers];


    for (int i = 0; i < numProducers; i++) {
        if (pthread_create(&producerThreads[i], NULL, producertask, (void*)(size_t)i) != 0) {
            perror("Failed to create producer thread");
            exit(EXIT_FAILURE);
        }
    }


    for (int i = 0; i < numConsumers; i++) {
        if (pthread_create(&consumerThreads[i], NULL, consumertask, (void*)(size_t)i) != 0) {
            perror("Failed to create consumer thread");
            exit(EXIT_FAILURE);
        }
    }


    sleep(timeout);


    for (int i = 0; i < numProducers; i++) {
        pthread_cancel(producerThreads[i]);
        pthread_join(producerThreads[i], NULL);
    }
    for (int i = 0; i < numConsumers; i++) {
        pthread_cancel(consumerThreads[i]);
        pthread_join(consumerThreads[i], NULL);
    }


    pthread_mutex_destroy(&queueMutex);
    sem_destroy(&spaceAvailable);
    sem_destroy(&itemsAvailable);


    log_with_timestamp("SYSTEM  ", "Execution completed", -1, -1, "");
    printf("\n===========================================================");
    return 0;
}





