import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/TopicPopup.dart';
import 'package:tekachigeojit/components/NavBar.dart';

class OOPtopics extends StatelessWidget {
  const OOPtopics({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final OOPTopics = [
      'Object-Oriented Concepts',
      'Overloading and Overriding',
      'Inheritance and Multilevel Hierarchy',
      'Packages and Interfaces',
      'Exception Handling',
      'Multithreaded Programming',
      'Event Handling',
      'AWT',
      'UML',
      'Data Abstraction',
      'Encapsulation and Data Hiding',
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
                  'Object Oriented Programming',
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
                  children: List.generate(OOPTopics.length, (index) {
                    final topic = OOPTopics[index];
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
      'Object-Oriented Concepts': '''
Object-Oriented Programming (OOP) is a programming paradigm based on the concept of objects, which contain data (attributes) and behavior (methods).

An object represents a real-world entity (like a Student, BankAccount, or Car) and interacts with other objects through method calls (message passing).

Core Concepts
• Class: Blueprint for creating objects
• Object: Instance of a class
• Abstraction: Showing essential features, hiding internal details
• Encapsulation: Wrapping data and methods into a single unit
• Inheritance: Acquiring properties from another class
• Polymorphism: One interface, many implementations

Quick Example Idea
• Class: Car
• Attributes: speed, fuel
• Methods: accelerate(), brake()

Advantages
• Models real-world entities
• Improves code reusability
• Easier maintenance and scalability
• Better data security
''',

      'Overloading and Overriding': '''
Method Overloading
• Same method name
• Different parameter list (type/number/order)
• Compile-time polymorphism
• Improves readability

    Common use cases: multiple constructors, utility methods like print(int) vs print(String).

Example:
add(int a, int b)
add(double a, double b)

Method Overriding
• Same method name and parameters
• Occurs in inheritance
• Runtime polymorphism
• Uses @Override annotation

    Overriding enables dynamic dispatch: the method that runs depends on the actual object type at runtime.

Key Difference
• Overloading → Compile time
• Overriding → Runtime
''',

      'Inheritance and Multilevel Hierarchy': '''
Inheritance allows a class to acquire properties and behavior of another class.

    It models an “is-a” relationship (e.g., Dog is an Animal). Use inheritance when the relationship is truly hierarchical.

Types of Inheritance
• Single Inheritance
• Multilevel Inheritance
• Hierarchical Inheritance

Multilevel Inheritance
A → B → C
• Child class inherits from a derived class
• Promotes code reuse
• Uses extends keyword

    Example: Animal → Mammal → Dog

Benefits
• Reduces redundancy
• Improves maintainability
• Supports polymorphism

    Tip: Avoid overly deep inheritance chains; composition is often cleaner.
''',

      'Packages and Interfaces': '''
Packages
• Group related classes and interfaces
• Avoid name conflicts
• Improve modularity
• Example: java.util, java.lang

    Packages also help structure large projects (e.g., auth, services, utils). You typically import classes using the package name.

Interfaces
• Collection of abstract methods
• Achieves multiple inheritance
• Implemented using implements keyword
• Variables are public, static, final

    In Java, interfaces can also have default and static methods (Java 8+), which helps add features without breaking implementations.

Difference
• Package → Code organization
• Interface → Behavior specification
''',

      'Exception Handling': '''
Exception Handling manages runtime errors to maintain normal program flow.

    Instead of crashing the program, exceptions allow you to catch an error, show a message, retry, or safely exit.

Key Keywords
• try: Wrap risky code
• catch: Handle exception
• finally: Executes always
• throw: Explicitly throw exception
• throws: Declare exception

    Example: dividing by zero or accessing a file that doesn’t exist.

Types of Exceptions
• Checked Exceptions (Compile-time)
• Unchecked Exceptions (Runtime)

Benefits
• Prevents abnormal termination
• Improves reliability
• Separates error handling logic

    Best practice: catch specific exceptions first, then more general ones.
''',

      'Multithreaded Programming': '''
Multithreading allows multiple threads to run concurrently.

    This helps when tasks can run in parallel, like handling multiple users on a server or keeping a UI responsive while doing background work.

Thread Creation
• Extending Thread class
• Implementing Runnable interface

    Modern Java often uses executors (ExecutorService) to manage threads more safely.

Thread Lifecycle
• New
• Runnable
• Running
• Blocked
• Terminated

Advantages
• Better CPU utilization
• Faster execution
• Used in games, servers, GUI apps

Issues
• Race condition
• Deadlock
• Synchronization needed

Thread safety tools: synchronized, locks, and concurrent collections.
''',

      'Event Handling': '''
Event Handling responds to user actions like clicks and key presses.

    It’s the core of event-driven programming: the program waits for events and reacts using callback methods.

Delegation Event Model
• Event Source: Generates event
• Event Listener: Handles event
• Event Object: Contains event info

Common Events
• Mouse events
• Keyboard events
• Action events

Used in GUI-based applications

Example: a Button click triggers an ActionEvent handled by an ActionListener.
''',

      'AWT': '''
AWT (Abstract Window Toolkit) is a Java GUI toolkit.

    AWT is one of the earliest Java GUI libraries. Swing is built on top of AWT and provides more flexible, lightweight components.

Features
• Platform-dependent
• Uses native OS components
• Heavyweight components

AWT Components
• Frame
• Button
• Label
• TextField
• Checkbox

Used for basic GUI applications

Layout managers (FlowLayout, BorderLayout, GridLayout) control component positioning.
''',

      'UML': '''
UML (Unified Modeling Language) is a visual modeling language.

    It’s used to plan and communicate design before (or alongside) coding, especially in object-oriented systems.

Purpose
• Design system architecture
• Visualize object-oriented systems
• Improve communication

Common UML Diagrams
• Class Diagram
• Use Case Diagram
• Sequence Diagram

Class diagrams often show: attributes, methods, visibility (+, -, #), and relationships like inheritance and composition.

Widely used in software design phase
''',

      'Data Abstraction': '''
Abstraction hides implementation details and shows only essential features.

    It focuses on “what” an object does rather than “how” it does it.

Achieved Using
• Abstract classes
• Interfaces

    Abstract classes can contain both abstract and concrete methods, while interfaces mainly define contracts (with some defaults in Java).

Example
• Using ATM without knowing internal process

Benefits
• Reduces complexity
• Improves security
• Enhances maintainability
''',

      'Encapsulation and Data Hiding': '''
Encapsulation bundles data and methods together.

The idea is to keep an object’s state consistent by controlling how data is changed.

Data Hiding
• Restricts direct access to data
• Uses access modifiers:
  - private
  - protected
  - public

Typically done using private fields with public getters/setters (or methods like deposit(), withdraw()).

Benefits
• Protects data
• Improves control
• Enhances code safety

Encapsulation is implemented using classes.

Note: Encapsulation is the overall bundling; data hiding is the access restriction part.
''',
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
                topicContents: topicContents,
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
