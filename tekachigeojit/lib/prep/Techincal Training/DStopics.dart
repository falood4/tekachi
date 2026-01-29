import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/TopicPopup.dart';
import 'package:tekachigeojit/components/NavBar.dart';

class DStopics extends StatelessWidget {
  const DStopics({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final DSTopics = [
      "Sorting",
      "Sorting Techniques",
      "Trees",
      "Graphs",
      "Graph Traversal and Algorithms",
      "Stack",
      "Queue",
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
                  'Data Structures',
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
                  children: List.generate(DSTopics.length, (index) {
                    final topic = DSTopics[index];
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

    final topicContents = {
      'Sorting':
          '''Sorting is the process of arranging data in a specific order, typically in ascending or descending order. Common sorting algorithms include Bubble Sort, Selection Sort, and Insertion Sort.
Why sorting matters
• Faster searching (binary search needs sorted data)
• Easier data analysis
• Used internally by databases, operating systems, compilers

Classification of Sorting Algorithms

A. Based on Memory Usage
• Internal Sorting: Entire data fits in main memory
Example: Bubble, Quick, Merge

• External Sorting: Data too large for memory, uses disk
Example: External Merge Sort

B. Based on Method
• Comparison-based: Compare elements
Example: Bubble, Selection, Merge, Quick

• Non-comparison-based: Use value properties
Example: Counting, Radix, Bucket''',

      'Sorting Techniques': '''1. Bubble Sort
• Repeatedly steps through the list, compares adjacent elements and swaps them if they are in the wrong order.

Algoritcom

• Compare adjacent elements
• Swap if needed
• Repeat for all passes

2.Selection Sort

Select the smallest element and place it at the correct position.

Algorithm

• Find minimum element
• Swap with first unsorted position
• Repeat

3. Insertion Sort: 
Insert each element into its correct position in a sorted subarray.

Algorithm
• Assume the first element in the array is already sorted (a single-element list is inherently sorted).
• Pick the next element from the unsorted part. This element is often referred to as the key.
• Compare the key with the elements in the sorted part, moving from right to left.
• Shift any elements that are greater than the key one position to the right to create space.
• Insert the key into the position where all elements to its left are smaller than it, and all elements to its right are greater.

4. Merge Sort:
An efficient and general purpose comparison-based sorting algorithm. Most implementations of merge sort are stable, which means that the relative order of equal elements is the same between the input and output. Merge sort is a divide-and-conquer algorithm that was invented by John von Neumann in 1945.

Algorithm

• Divide the unsorted list into n sub-lists, each containing one element (a list of one element is considered sorted).
• Repeatedly merge sublists to produce new sorted sublists until there is only one sublist remaining. This will be the sorted list.


5. Quicksort

Quicksort is a divide-and-conquer algorithm. It works by selecting a "pivot" element from the array and partitioning the other elements into two sub-arrays, according to whether they are less than or greater than the pivot. For this reason, it is sometimes called partition-exchange sort. The sub-arrays are then sorted recursively.

• Choose a Pivot: Select a "pivot" element from the array
• Partition the Array: Rearrange the other elements into two sub-arrays: those smaller than the pivot go to its left, and those greater than the pivot go to its right
• Recursively Sort Sub-arrays: Apply the entire quicksort process recursively to the left and right sub-arrays until the sub-arrays are too small to be sorted, at which point the entire array is sorted. 

6. Heap Sort

Heapsort is an efficient, comparison-based sorting algorithm that reorganizes an input array into a heap (a data structure where each node is greater than its children) and then repeatedly removes the largest node from that heap, placing it at the end of the array in a similar manner to Selection sort.
 ''',

      'Trees':
          '''A tree is a hierarchical data structure consisting of nodes, where each node contains a value and references to its child nodes. The topmost node is called the root, and nodes without children are called leaves. Trees are used to represent hierarchical relationships and enable efficient searching, insertion, and deletion operations.

Key Properties
• A tree has a root node
• Every node (except root) has exactly one parent
• A node can have zero or more children
• Nodes with no children are called leaf nodes
• Depth: Maximum number of edges from root to a leaf
• Order: Maximum number of children a node can have

Tree Types

1. Balanced and Unbalanced Trees

Balanced Tree

• All leaf nodes are at the same depth
• Every internal node has the same order
• Guarantees uniform access time

Unbalanced Tree

• Leaf nodes may be at different depths
• Search time can degrade significantly

2. General Tree

• No restriction on the number of children
• Used to represent hierarchical data


3. Binary Tree

A binary tree is a tree where each node has at most two children:
• Left child
• Right child
Binary trees form the foundation for more advanced search trees used in databases

4. Binary Search Tree (BST)

A Binary Search Tree is a binary tree with an ordering property:

Properties:
• Left subtree contains values ≤ parent
• Right subtree contains values ≥ parent
• Enables efficient searching
''',

      'Graphs':
          '''A graph is a non-linear data structure used to represent relationships between entities.

A graph G is defined as:

𝐺=(𝑉,𝐸);
V (Vertices / Nodes): Set of points
E (Edges): Set of connections between vertices

Types of Graphs

3.1 Undirected Graph
Edges have no direction
(u, v) = (v, u)

3.2 Directed Graph (Digraph)
Edges have direction
(u → v) ≠ (v → u)

3.3 Weighted Graph
Each edge has a weight/cost
Used in shortest path problems

3.4 Unweighted Graph
All edges have equal weight
Only connectivity matters

3.5 Simple Graph
No self-loop
No multiple edges between same vertices

3.6 Multigraph
Multiple edges allowed between same vertices

3.7 Complete Graph
Every vertex connected to every other vertex
For n vertices, edges = n(n−1)/2

3.8 Cyclic Graph
Contains at least one cycle

3.9 Acyclic Graph
No cycles
Directed Acyclic Graph (DAG) is very important''',

      'Graph Traversal and Algorithms': '''1. Breadth First Search (BFS)

• Traverses level by level
• Uses Queue

Time Complexity: O(V + E)

2. Depth First Search (DFS)

• Traverses depth-wise
• Uses Stack / Recursion


Important Graph Algorithms

1. Shortest Path Algorithms

• Dijkstra’s Algorithm: Weighted graphs (no negative weights)
• Bellman–Ford: Handles negative weights
• Floyd–Warshall: All-pairs shortest paths

2. Minimum Spanning Tree (MST)

• Connects all vertices with minimum total edge weight
• Algorithms:
    Prim’s Algorithm
    Kruskal’s Algorithm

3. Topological Sorting
• Linear ordering of vertices in a DAG
• Used in task scheduling''',

      'Stack':
          '''A stack is a linear data structure that follows the Last-In, First-Out (LIFO) principle, meaning the last element added is the first one to be removed. Operations on a stack occur at only one end, called the "top. Stacks are usually implemented using arrays or linked lists."
Stack Operations

•Push Operation: Adds an element at the top of the stack.
•Pop Operation: Removes the topmost element.
•Peek Operation:Returns the top element without deletion.
          ''',

      'Queue':
          '''A queue is a linear data structure that follows the First-In, First-Out (FIFO) principle, meaning the first element added is the first one to be removed. Operations on a queue occur at two ends: the "front" for removal and the "rear" for addition. Queues are typically implemented using arrays or linked lists.

Queue Operations
• Enqueue Operation: Adds an element at the rear of the queue.
• Dequeue Operation: Removes the frontmost element.
• Peek Operation: Returns the front element without deletion.

Double-Ended Queue (Deque)
A deque allows insertion and deletion from both ends (front and rear).

Circular Queue
A circular queue connects the end of the queue back to the front, forming a circle. This allows for efficient use of space by reusing empty slots.'''
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
