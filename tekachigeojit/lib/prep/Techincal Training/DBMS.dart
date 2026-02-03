import 'package:flutter/material.dart';
import 'package:tekachigeojit/components/TopicPopup.dart';
import 'package:tekachigeojit/components/NavBar.dart';

class DBMS extends StatelessWidget {
  const DBMS({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final DBMSTopics = [
      "Database System Architecture",
      "Three-Level Architecture",
      "ER Model and Keys",
      "Relational Algebra",
      "DDL, DML, DCL",
      "Joins and Subqueries",
      "ACID",
      "Deadlocks",
    ];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
        iconTheme: const IconThemeData(color: Color(0xFF8DD300)),
        title: Text(
          'Technical Training',
          style: TextStyle(
            color: const Color(0xFF8DD300),
            fontFamily: "RussoOne",
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
                  'Database Management System',
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
                  children: List.generate(DBMSTopics.length, (index) {
                    final topic = DBMSTopics[index];
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

    const topicContents = {
  'Database System Architecture': '''Database System Architecture describes how a DBMS is structured and how different components interact.

Main Components
• Query Processor: Interprets and executes SQL queries
• Storage Manager: Manages data storage, indexing, and buffering
• Transaction Manager: Ensures ACID properties
• Authorization & Integrity Manager: Controls access and enforces constraints

Why it matters
• Separates user applications from physical data storage
• Improves data security and consistency
• Enables efficient query execution''',

  'Three-Level Architecture': '''The three-level architecture separates database description into different levels to achieve data independence.

Levels
• Internal Level: Physical storage of data
• Conceptual Level: Logical structure of the entire database
• External Level: User-specific views

Data Independence
• Logical Data Independence: Change conceptual schema without affecting views
• Physical Data Independence: Change storage without affecting logical schema

Benefit
• Easier database maintenance and scalability''',

  'ER Model and Keys': '''The Entity-Relationship (ER) model is used for database design.

ER Model Concepts
• Entity: Real-world object
• Attribute: Property of an entity
• Relationship: Association between entities

Types of Keys
• Super Key: Any attribute set that uniquely identifies a record
• Candidate Key: Minimal super key
• Primary Key: Selected candidate key
• Foreign Key: Refers to primary key of another table

Usage
• Forms the basis for relational schema design''',

  'Relational Algebra': '''Relational Algebra is a procedural query language used to retrieve data from relations.

Basic Operations
• Selection (σ): Select rows
• Projection (π): Select columns
• Union (∪)
• Set Difference (−)
• Cartesian Product (×)
• Rename (ρ)

Derived Operations
• Join
• Intersection
• Division

Importance
• Foundation of SQL query processing and optimization''',

  'DDL, DML, DCL': '''SQL commands are categorized based on their functionality.

DDL (Data Definition Language)
• CREATE
• ALTER
• DROP
• TRUNCATE

DML (Data Manipulation Language)
• SELECT
• INSERT
• UPDATE
• DELETE

DCL (Data Control Language)
• GRANT
• REVOKE

Purpose
• Defines, manipulates, and secures database objects''',

  'Joins and Subqueries': '''Joins and subqueries allow retrieval of data from multiple tables.

Types of Joins
• Inner Join: Returns only matching rows from both tables
• Left Outer Join: Returns all rows from left table, matching rows from right (NULL if no match)
• Right Outer Join: Returns all rows from right table, matching rows from left (NULL if no match)
• Full Outer Join: Returns all rows from both tables (NULL where no match)
• Cross Join: Cartesian product of both tables
• Self Join: Table joined with itself
• Natural Join: Automatically joins on columns with same name

Example
```sql
-- Inner Join
SELECT * FROM Students S 
INNER JOIN Enrollments E ON S.id = E.student_id;

-- Left Join
SELECT * FROM Students S 
LEFT JOIN Enrollments E ON S.id = E.student_id;
```

Subqueries
• Nested queries inside SELECT, FROM, or WHERE clauses
• Can be correlated (references outer query) or non-correlated
• Types: Scalar (single value), Row, Table

Why important
• Enables complex data retrieval across multiple tables
• Provides flexible ways to combine and filter data''',

  'ACID': '''ACID properties ensure reliable transaction processing.

Properties
• Atomicity: All or nothing execution
• Consistency: Preserves database rules
• Isolation: Concurrent transactions do not interfere
• Durability: Committed changes persist

Why ACID matters
• Prevents data corruption
• Ensures correctness in concurrent environments''',

  'Deadlocks': '''A deadlock occurs when transactions wait indefinitely for resources.

Conditions for Deadlock
• Mutual Exclusion
• Hold and Wait
• No Preemption
• Circular Wait

Handling Deadlocks
• Prevention: Break one of the conditions
• Avoidance: Banker’s Algorithm
• Detection and Recovery

Impact
• Can halt transaction processing if unresolved''',
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
                topicContents: {
                  title: topicContents[title] ?? 'Content not available',
                },
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
        backgroundColor: const Color(0xFFD9D9D9),
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
