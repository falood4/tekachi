import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/TopicPopup.dart';
import 'package:tekachigeojit/components/NavBar.dart';

class OStopics extends StatelessWidget {
  const OStopics({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final OSTopics = [
      "Functions of an Operating System",
      "Types of Operating Systems",
      "Processes",
      "Multithreading",
      "CPU Scheduling",
      "Inter Process Communication",
      "Memory Management",
      "Disk Scheduling Algorithms",
      "Deadlocks"
    ];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
        iconTheme: const IconThemeData(color: Color(0xFF8DD300)),
        title: Text(
          'Techincal Training',
          style: TextStyle(
            color: const Color(0xFF8DD300),
            fontFamily: "Trebuchet",
            fontSize: 0.075 * screenWidth,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: NavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Operating Systems',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.05,
                    fontFamily: "Trebuchet",
                  ),
                ),
                SizedBox(height: screenWidth * 0.05),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * 0.05,
                  mainAxisSpacing: screenWidth * 0.05,
                  childAspectRatio: 1.5,
                  children: List.generate(OSTopics.length, (index) {
                    final topic = OSTopics[index];
                    return _topicButton(context, topic);
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _topicButton(BuildContext context, String title) {
    final screenWidth = MediaQuery.of(context).size.width;

    final  topicContents = {
  'Functions of an Operating System': '''An Operating System (OS) acts as an interface between the user and computer hardware. It manages system resources and provides services for application programs.

Main Functions
• Process Management: Creation, scheduling, and termination of processes
• Memory Management: Allocation and deallocation of main memory
• File Management: Creation, deletion, and access control of files
• Device Management: Control of I/O devices via drivers
• Security & Protection: Prevents unauthorized access
• Resource Allocation: Ensures fair usage of CPU, memory, and I/O devices

Why it matters
• Enables multitasking
• Improves system efficiency
• Ensures system stability and security''',

  'Types of Operating Systems': '''Operating Systems can be classified based on how they manage resources and users.

Major Types
• Batch OS: Executes jobs in batches with no user interaction
• Time-Sharing OS: Multiple users share CPU time (e.g., UNIX)
• Real-Time OS: Provides immediate response within deadlines
• Distributed OS: Manages multiple systems as a single unit
• Network OS: Provides services over a network

Key Idea
• Choice of OS depends on system requirements like speed, reliability, and scalability''',

  'Processes': '''A process is a program in execution. It is an active entity with its own resources.

Process States
• New
• Ready
• Running
• Waiting
• Terminated

Process Control Block (PCB)
• Stores process ID
• Process state
• Program counter
• CPU registers
• Memory management info
• I/O status

Why PCB is important
• Allows OS to manage and track processes efficiently''',

  'Multithreading': '''Multithreading allows multiple threads to exist within a single process.

Key Points
• Threads share process resources
• Each thread has its own stack and program counter

Benefits
• Better CPU utilization
• Faster response time
• Resource sharing
• Improved scalability

Challenges
• Requires careful synchronization
• Can cause race conditions if not handled properly''',

  'CPU Scheduling': '''CPU Scheduling decides which process gets the CPU.

Scheduling Types & Working Principles

Non-Preemptive Scheduling
Process runs until it completes or enters waiting state (cannot be interrupted)

• FCFS (First Come First Serve)
  - Processes executed in arrival order
  - Simple queue implementation
  - Suffers from convoy effect (short processes wait for long ones)

• SJF (Shortest Job First)
  - Selects process with smallest burst time
  - Minimizes average waiting time
  - Requires knowing burst time in advance (prediction needed)

Preemptive Scheduling
Running process can be interrupted and moved back to ready queue

• Round Robin (RR)
  - Each process gets fixed time quantum (e.g., 10ms)
  - After quantum expires, process moves to end of queue
  - Good for time-sharing systems
  - Performance depends on quantum size

• Priority Scheduling
  - Each process assigned a priority number
  - CPU allocated to highest priority process
  - Can be preemptive or non-preemptive
  - Risk: Starvation of low-priority processes (solved by aging)

• Shortest Remaining Time First (SRTF)
  - Preemptive version of SJF
  - Switches to process with shortest remaining time
  - Optimal but requires burst time prediction

Scheduling Criteria
• CPU utilization: Keep CPU busy
• Throughput: Number of processes completed per unit time
• Turnaround time: Total time from submission to completion
• Waiting time: Time spent in ready queue
• Response time: Time from submission to first response

Dispatcher
• Performs context switching
• Switches CPU to user mode
• Jumps to proper location in user program
• Dispatch latency: Time to stop one process and start another''',

  'Inter Process Communication': '''Inter Process Communication (IPC) allows processes to communicate and synchronize.

IPC Methods
• Shared Memory: Processes share a common memory area
• Message Passing: Processes communicate via messages
• Pipes: Unidirectional communication
• Sockets: Communication over a network

Why IPC is needed
• Data sharing
• Synchronization
• Modular system design''',

  'Memory Management': '''Memory Management handles allocation and deallocation of memory.

Memory Management Techniques

Fixed Partitioning
• Memory divided into fixed-size partitions at boot time
• Each process allocated to smallest sufficient partition
• Advantages: Simple implementation, fast allocation
• Disadvantages: Internal fragmentation, limits number of processes

Variable Partitioning
• Partitions created dynamically based on process size
• OS maintains free memory list
• Allocation strategies:
  - First Fit: Allocate first sufficient block
  - Best Fit: Allocate smallest sufficient block (minimizes waste)
  - Worst Fit: Allocate largest available block
• Advantage: No internal fragmentation
• Disadvantage: External fragmentation over time

Paging
• Physical memory divided into fixed-size frames
• Logical memory divided into same-size pages
• Page table maps logical pages to physical frames
• Eliminates external fragmentation
• Page table contains:
  - Page number
  - Frame number
  - Valid/invalid bit
  - Protection bits
• Address translation: Page number + Offset
• May suffer from internal fragmentation in last page

Segmentation
• Memory divided into logical segments (code, data, stack)
• Each segment has base address and limit
• Segment table stores base and limit for each segment
• Supports different-sized logical units
• Better matches program structure
• May suffer from external fragmentation

Key Concepts
• Logical Address: Generated by CPU (program's view)
• Physical Address: Actual location in RAM
• Memory Management Unit (MMU): Hardware that translates logical to physical addresses
• Swapping: Moving entire process between main memory and disk
  - Swap Out: Move process to disk
  - Swap In: Move process back to memory
• Fragmentation:
  - Internal: Allocated memory larger than requested
  - External: Free memory scattered in small blocks

Virtual Memory (Advanced)
• Allows execution of processes larger than physical memory
• Uses demand paging or demand segmentation
• Page replacement algorithms when memory full

Goal
• Efficient utilization of main memory
• Provide illusion of larger memory
• Protect processes from each other''',

  'Disk Scheduling Algorithms': '''Disk Scheduling determines the order of disk access requests to minimize seek time.

Disk Access Components
• Seek Time: Time to move read/write head to correct track (dominant factor)
• Rotational Latency: Time for desired sector to rotate under head
• Transfer Time: Time to read/write data
• Total Access Time = Seek Time + Rotational Latency + Transfer Time

Disk Scheduling Algorithms

FCFS (First Come First Serve)
• Services requests in arrival order
• No starvation - all requests eventually served
• Advantages: Simple, fair
• Disadvantages: High seek time, poor performance
• Example: Queue [98, 183, 37, 122, 14, 124, 65, 67]
  Head moves: 98→183→37→122→14→124→65→67

SSTF (Shortest Seek Time First)
• Selects request closest to current head position
• Greedy approach - minimizes immediate seek time
• Advantages: Better than FCFS, reduces seek time
• Disadvantages: May cause starvation of distant requests
• Example: From position 53, picks 65 (closest) then 67, etc.

SCAN (Elevator Algorithm)
• Head moves in one direction, services all requests until end
• Then reverses direction
• Like elevator moving up/down floors
• Advantages: No starvation, uniform wait time
• Disadvantages: Long waiting time for recently visited locations
• Example: If moving right from 53→199, services 65,67,98,122...
  Then reverses: 183,122,98...

C-SCAN (Circular SCAN)
• Head moves in one direction only
• After reaching end, jumps back to beginning (no servicing during return)
• More uniform wait time than SCAN
• Treats disk as circular list
• Advantages: Better response time uniformity
• Disadvantages: More seek distance than SCAN

LOOK
• Similar to SCAN but reverses at last request, not disk end
• More efficient than SCAN (doesn't go to physical end)
• Head "looks" ahead for more requests

C-LOOK (Circular LOOK)
• Circular version of LOOK
• Returns to first request after last request in direction
• Most commonly used in modern systems

Performance Metrics
• Average Seek Time: Total head movement / Number of requests
• Throughput: Number of requests completed per unit time
• Variance: Consistency of response times
• Fairness: Avoidance of starvation

Why it matters
• Disk I/O is often bottleneck in system performance
• Proper scheduling reduces mechanical movement
• Improves overall system responsiveness''',

  'Deadlocks': '''A deadlock occurs when processes wait indefinitely for resources held by each other, creating a circular dependency.

Necessary Conditions (All 4 must hold simultaneously)

1. Mutual Exclusion
• At least one resource must be held in non-sharable mode
• Only one process can use the resource at a time
• Other processes must wait until resource is released
• Example: Printer, disk drive
• If resources can be shared, no deadlock occurs

2. Hold and Wait
• Process holding at least one resource is waiting to acquire additional resources
• Process doesn't release currently held resources while waiting
• Example: Process P1 holds Resource A and waits for Resource B

3. No Preemption
• Resources cannot be forcibly taken away from a process
• Resource released only voluntarily by process holding it
• Process must explicitly release resource after completion
• Example: Cannot take CPU from process mid-execution

4. Circular Wait
• Set of processes {P0, P1, ..., Pn} where:
  - P0 waits for resource held by P1
  - P1 waits for resource held by P2
  - Pn waits for resource held by P0
• Forms a circular chain of dependencies
• Can be represented as Resource Allocation Graph (RAG) with cycle

Handling Deadlocks

Prevention (Ensure at least one condition never holds)
• Mutual Exclusion: Make resources sharable (not always possible)
• Hold and Wait: Require process to request all resources at once, or release held resources before requesting new ones
• No Preemption: Allow resource preemption - if process requests unavailable resource, release currently held resources
• Circular Wait: Impose ordering on resource types - process can only request resources in increasing order

Avoidance (Use Safe State)
• Banker's Algorithm: Check if allocation leads to safe state
• Safe State: System can allocate resources to processes in some order avoiding deadlock
• Requires advance knowledge of maximum resource needs
• More flexible than prevention but has overhead

Detection (Allow deadlock, then detect)
• Periodically run detection algorithm
• Check for cycles in Resource Allocation Graph
• Wait-for graph approach
• Recovery needed once detected

Recovery (After detection)
• Process Termination:
  - Abort all deadlocked processes
  - Abort one process at a time until deadlock cycle is eliminated
• Resource Preemption:
  - Select victim process
  - Rollback process to safe state
  - Preempt resources from victim
  - Risk of starvation if same process repeatedly selected

Real-World Example
Process P1: Holds Printer, Needs Scanner
Process P2: Holds Scanner, Needs Printer
→ Circular wait → Deadlock

Impact
• System halt - no progress
• Resource wastage
• Requires intervention
• Can bring entire system down if not handled''',
};
    return ElevatedButton(
      onPressed: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: 'Close',
          barrierColor: Colors.black54,
          transitionDuration: const Duration(milliseconds: 180),
          pageBuilder: (context, animation, secondaryAnimation) {
            return Center(
              child: TopicPopup(
                topicTitle: title,
                topicContents: {title: topicContents[title]!},
              ),
            );
          },
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(curved),
                child: child,
              ),
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFD9D9D9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: screenWidth * 0.04,
          fontFamily: "Trebuchet",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}