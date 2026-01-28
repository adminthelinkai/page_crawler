# 📄 Product Requirements Document (PRD)

## Product: Agentic Research & Learning Workspace

## Audience: Researchers, developers, analysts, learners

## Core Paradigm: **Node-based mind map + AI agents + persistent context**

---

## 1. Node-Based Knowledge Graph (Mind Map Core)

### Goal

Allow users to visually structure research as **interconnected nodes**, with AI agents operating inside and across nodes.

### Description

* Each node represents a **topic, question, chat, or research artifact**
* Nodes are connected via **directed edges**
* Nodes can spawn **child nodes** and reference **existing nodes**

### Key Capabilities

* Create, rename, delete nodes
* Spawn new nodes from any node
* Link existing nodes (no duplication)
* Hover preview of node content
* Click navigation to node

### Node Intersection Behavior

* When a new node is spawned:
  * User selects:
    * **New node**
    * **Link to existing node**
* Intersection edge stores:
  * `source_node_id`
  * `target_node_id`
  * `relationship_type` (example: *expands*, *references*, *contradicts*)

### Navigation

* Clicking any node:
  * Focuses canvas on that node
  * Loads its content on the right panel
* Clicking an intersection edge:
  * Highlights both nodes
  * Shows relationship metadata

### Acceptance Criteria

✅ Nodes are reusable (no forced duplication)
✅ Clicking nodes navigates instantly
✅ Relationships are visually and logically preserved

---

## 2. Automatic Node Referencing on Spawn

### Goal

Ensure every new node is **context-aware** and traceable.

### Description

* Any newly created node **must reference at least one existing node**
* This enforces graph integrity and research lineage

### User Flow

1. User clicks “+ New Node”
2. System prompts:
   * “What is this node related to?”
3. User selects existing node(s)
4. Node is created with visible connections

### AI Agent Behavior

* Suggest relevant nodes automatically based on:
  * Semantic similarity
  * Chat history
  * Current research topic

### Acceptance Criteria

✅ No orphan nodes
✅ AI suggests smart references
✅ Users can override suggestions

---

## 3. Persistent Notes System (Manual + Agentic)

### Goal

Enable **frictionless note capture**, both manual and AI-assisted.

### Description

* Each node has an associated **Notes Layer**
* Notes are visible in:
  * Right-side notes panel
  * Inline node view

### User Flow

* User can:
  * Type notes manually
  * Say things like:
    > “Add this as a note”
    > “Remember this”
    >
* Notes auto-save and sync to the node

### AI Agent Behavior

* Detects intent to save notes
* Automatically extracts:
  * Key insights
  * Definitions
  * Decisions
* Confirms silently or with lightweight toast

### Acceptance Criteria

✅ Notes persist across sessions
✅ Voice/text commands auto-trigger note saving
✅ Notes are node-scoped

---

## 4. Plugin System Between Nodes (Research Plugins)

### Goal

Allow **functional plugins** to operate between nodes.

### Plugin Type: Website Research Plugin

#### Description

* Plugin can be inserted **between two nodes**
* Represents an external research operation

#### User Flow

1. User clicks “+ Plugin” on an edge
2. Selects “Website Research”
3. Pastes URL
4. AI agent:
   * Crawls content
   * Extracts summaries, facts, citations
5. Results are injected into:
   * Target node
   * Notes
   * Context memory

#### Visual Representation

* Edge shows plugin icon
* Clicking plugin opens research output

### Acceptance Criteria

✅ Plugin output is traceable
✅ Research is scoped to edge context
✅ Multiple plugins supported per node

---

## 5. Node-to-Node Navigation Index (`< 1 / 5 >`)

### Goal

Enable **linear navigation** across related nodes.

### Description

* Nodes in a sequence show navigation:
  ```
  < 1 / 5 >
  ```
* Represents traversal order in a research thread

### User Flow

* Click left arrow → previous node
* Click right arrow → next node
* Index updates dynamically if nodes are added/removed

### AI Agent Behavior

* Auto-detects logical sequences
* Suggests ordering based on:
  * Time
  * Dependency
  * Topic progression

### Acceptance Criteria

✅ Smooth keyboard & click navigation
✅ Dynamic reindexing
✅ AI-assisted ordering

---

## 6. Import Existing LLM Chat via Public URL

### Goal

Allow continuation of work started elsewhere.

### Description

* User pastes a public LLM chat URL
* System:
  * Fetches content
  * Parses messages
  * Converts into a node

### AI Agent Behavior

* Summarizes imported chat
* Extracts:
  * Key ideas
  * Open questions
* Allows user to “Continue this conversation”

### Acceptance Criteria

✅ Full chat imported accurately
✅ Context preserved
✅ User can extend seamlessly

---

## 7. Auto-Grouping Similar Chats

### Goal

Reduce clutter and reveal thematic structure.

### Description

* AI continuously clusters chats/nodes by similarity
* Groups are shown as:
  * Collapsible clusters
  * Auto-labeled topics

### AI Agent Behavior

* Uses embeddings + semantic similarity
* Re-groups dynamically as content evolves

### User Control

* Accept
* Rename
* Override grouping

### Acceptance Criteria

✅ Non-destructive grouping
✅ User override allowed
✅ Groups update intelligently

---

## 8. Deep Research Mode (Multi-Agent)

### Goal

Enable **long-horizon, multi-step research**, similar to advanced research tools.

### Description

* User enables “Deep Research”
* AI spawns:
  * Planner agent
  * Research agent(s)
  * Synthesizer agent

### Capabilities

* Web search
* Citation tracking
* Multi-source synthesis
* Long-running tasks

### Output

* Structured report node
* Sources node
* Summary notes

### Acceptance Criteria

✅ Multi-step reasoning visible
✅ Sources cited
✅ Results persist as nodes

---

## 9. Learning Mode: Recommended Videos

### Goal

Support **learning-oriented chats** with multimedia.

### Trigger

* AI detects:
  * “Explain”
  * “Learn”
  * “How does X work”

### Behavior

* AI suggests:
  * Relevant videos
  * Playlists
* Shown at bottom of node or side panel

### Acceptance Criteria

✅ Only shown in learning contexts
✅ High relevance
✅ Non-intrusive UI

---

## 10. YouTube Video Context Injection

### Goal

Treat videos as **first-class knowledge sources**.

### Description

* User pastes YouTube link
* System:
  * Extracts transcript
  * Summarizes content
  * Adds to node context

### AI Agent Behavior

* Uses transcript as RAG source
* References timestamps when answering

### Acceptance Criteria

✅ Transcript parsed correctly
✅ Video content influences answers
✅ Video visible in node

---

## 11. Per-Chat RAG / Notebook LLM

### Goal

Enable **file-grounded conversations** per node.

### Description

* Each node supports file uploads:
  * PDF
  * Docs
  * CSV
* Files become **private RAG context**

### AI Agent Behavior

* Indexes files
* Answers strictly from provided material (when enabled)
* Shows citations to file sections

### Acceptance Criteria

✅ Files scoped per node
✅ No cross-node leakage
✅ Clear citations
