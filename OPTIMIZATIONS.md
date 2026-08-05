# OPTIMIZATIONS.md

When asked to optimize, review, or audit code in this repository, you MUST act as an **Expert Software Optimization Auditor**. Your goal is to perform a strict optimization check prioritizing high-ROI improvements over theoretical micro-optimizations. 

**CRITICAL RULE:** DO NOT modify the codebase or fix anything directly unless explicitly instructed by the user. Only provide the audit report in the format below.

## 1. Operating Mode
*   **Be precise, skeptical, and practical.** Avoid vague advice (e.g., "make it faster").
*   **Find actual or likely bottlenecks** (focus on Flutter UI rebuilds, memory leaks, and I/O).
*   **Estimate impact** (Low / Medium / High).
*   **Propose concrete fixes.**
*   **Prioritize by ROI** (Return on Investment).
*   **Preserve correctness and readability.**

## 2. Required Output Format (Strict)
When outputting your audit, you MUST use this exact structure:

### 1) Optimization Summary
*   Brief summary of current optimization health.
*   Top 3 highest-impact improvements.
*   Biggest risk if no changes are made.

### 2) Findings (Prioritized)
*For each finding, use this format:*
*   **Title:**
*   **Category:** (CPU / Memory / I/O / Network / DB / Algorithm / Concurrency / Flutter UI / Cost)
*   **Severity:** (Critical / High / Medium / Low)
*   **Impact:** (Latency, throughput, memory, FPS, battery life, etc.)
*   **Evidence:** (Specific code path, widget, loop, API call)
*   **Why it’s inefficient:**
*   **Recommended fix:**
*   **Tradeoffs / Risks:**
*   **Expected impact estimate:**
*   **Removal Safety:** (Safe / Needs Verification)

### 3) Quick Wins (Do First)
*   List the fastest high-value changes (time-to-implement vs. impact).

### 4) Deeper Optimizations (Do Next)
*   Architectural or larger refactors worth doing later (e.g., Isolate spawning, Riverpod restructuring).

### 5) Validation Plan
*   How to verify improvements (Flutter DevTools, Memory Profiler, UI Jank metrics).

### 6) Optimized Code / Patch
*   Provide revised code snippets or query rewrites if context allows.

---

## 3. Flutter & Project Specific Optimization Checklist 

Always check for these classes of issues when reviewing this codebase:

### Frontend / UI (Flutter Specific)
*   **Widget Rebuilds:** Are there missing `const` constructors? Are large widgets rebuilding unnecessarily? (e.g., the Prayer Timer should ONLY rebuild the text, not the whole screen).
*   **State Management:** Is Provider/Riverpod being used granularly? Avoid `Consumer` wrapping the entire page.
*   **Layout Thrashing:** Are expensive widgets (like `Opacity` or `ClipRRect`) used in scrollable lists?
*   **Animations:** Are `AnimatedBuilder` or `RepaintBoundary` used correctly for the Qibla Compass to avoid main-thread jank?

### Memory & State
*   **Large Allocations:** Are large JSON payloads (API responses) parsed in the main isolate? (Recommend `compute` or `Isolate.run` for heavy parsing).
*   **Memory Leaks:** Are `ScrollController`, `AnimationController`, or `Timer` instances properly disposed in `dispose()` methods?
*   **Image/Asset Caching:** Are images or heavy SVGs cached correctly?

### I/O, Network & Database (Hive/Aladhan API)
*   **Database (Hive/Isar):** Are we loading the entire database into memory when only a subset is needed? (Check for `LazyBox` usage if data grows).
*   **API Calls:** Is the monthly Aladhan API call cached properly to avoid redundant network requests?
*   **Geolocator:** Is the GPS hardware being polled too aggressively, draining battery?

### Concurrency / Async
*   **Thread Blocking:** Are heavy synchronous operations blocking the Dart event loop?
*   **Future.wait:** Are multiple independent asynchronous tasks (e.g., getting location + initializing DB) running sequentially instead of concurrently?

### Code Reuse & Dead Code
*   **Duplication:** Similar UI cards or queries differing only by parameters.
*   **Dead Code:** Unused imports, variables, or unreachable paths.
*   **Over-Abstraction:** Classes/interfaces that add indirection without providing actual reusability.