---
name: error-handling
description: "Enterprise-grade error handling patterns. What separates amateur code from professional code."
---

# Error Handling

> **🤖 You don't need to do any of this manually.** The agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

<!-- ═══════════════════════════════════════════════════ -->
<!-- USER OVERVIEW                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## What Is This?
Battle-tested error handling patterns written into your code automatically. These make your code resilient, debuggable, and professional.

## Why Does It Exist?
90% of crashes come from unhandled errors, silent failures, and poor resource cleanup. Amateur code: bare `try/catch` with `console.log`. Professional code: structured patterns that recover gracefully, report meaningfully, and clean up after themselves.

## What It Does For You
The agent writes these patterns into your code automatically - you don't need experience with error handling. A senior dev reviewing your codebase would see Circuit Breaker patterns, structured error reporting, and graceful fallbacks - hallmarks of production-ready software.

---

## Activation
- Code with external API calls, file I/O, user input processing, or resource management
- During the Guard phase of F.O.R.G.E.
- New features interacting with external services

## Enforcement
- Agent MUST NOT leave bare `try/catch` with only `console.log`
- Every `catch` must handle meaningfully (retry, fallback, or structured report)
- For the security angle of errors (what NOT to do), see `security-guardian` #13

---

## Delineation with Security Guardian

| This Skill (What TO Do) | Security Guardian #13 (What NOT To Do) |
|---|---|
| Circuit Breaker for API resilience | Never "fail open" on auth errors |
| Graceful fallbacks | Never expose stack traces to users |
| Structured error reporting | Never log sensitive data in errors |
| Resource cleanup on failure | Generic messages to users, details in logs |

<!-- ═══════════════════════════════════════════════════ -->
<!-- PATTERNS                                           -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Pattern 1: Circuit Breaker

**When:** External API calls (OpenAI, Stripe, any third-party).
**Why:** Without this, one slow API call cascades and takes down your whole app.

```typescript
class CircuitBreaker {
  private failures = 0;
  private lastFailure = 0;
  private readonly threshold = 5;
  private readonly resetTimeout = 60_000; // 1 minute

  async call<T>(fn: () => Promise<T>, fallback?: () => T): Promise<T> {
    if (this.failures >= this.threshold) {
      if (Date.now() - this.lastFailure < this.resetTimeout) {
        if (fallback) return fallback();
        throw new Error("Service temporarily unavailable. Please try again.");
      }
      this.failures = 0;
    }

    try {
      const result = await fn();
      this.failures = 0;
      return result;
    } catch (error) {
      this.failures++;
      this.lastFailure = Date.now();
      if (fallback) return fallback();
      throw error;
    }
  }
}

// Usage
const openAIBreaker = new CircuitBreaker();
const response = await openAIBreaker.call(
  () => openai.chat.completions.create({ /* ... */ }),
  () => ({ choices: [{ message: { content: "AI is temporarily unavailable." } }] })
);
```

## Pattern 2: Error Aggregation (Structured Reporting)

**When:** Multiple operations that can each fail independently.
**Why:** Scattered `console.log("error:", e)` makes debugging impossible.

```typescript
type ErrorCategory = "auth" | "network" | "validation" | "storage" | "unknown";

interface StructuredError {
  category: ErrorCategory;
  operation: string;
  message: string;
  timestamp: number;
  context?: Record<string, unknown>;
}

class ErrorReporter {
  private errors: StructuredError[] = [];

  report(category: ErrorCategory, operation: string, error: unknown, context?: Record<string, unknown>) {
    const structured: StructuredError = {
      category,
      operation,
      message: error instanceof Error ? error.message : String(error),
      timestamp: Date.now(),
      context,
    };
    this.errors.push(structured);
    console.error(JSON.stringify({ level: "error", ...structured }));
  }

  getErrorsByCategory(category: ErrorCategory): StructuredError[] {
    return this.errors.filter(e => e.category === category);
  }
}

// Usage
const reporter = new ErrorReporter();
try {
  await saveToDatabase(data);
} catch (error) {
  reporter.report("storage", "saveToDatabase", error, { table: "posts", userId });
}
```

## Pattern 3: Graceful Degradation

**When:** A feature depends on a service that might be unavailable.
**Why:** App should never crash because one feature's backend is down.

```typescript
async function loadDashboard(userId: string) {
  const user = await getUser(userId); // Core - must succeed

  // Enhanced - degrade gracefully
  const [analytics, recommendations] = await Promise.allSettled([
    fetchAnalytics(userId),
    fetchRecommendations(userId),
  ]);

  return {
    user,
    analytics: analytics.status === "fulfilled"
      ? analytics.value
      : { available: false, message: "Analytics loading..." },
    recommendations: recommendations.status === "fulfilled"
      ? recommendations.value
      : { available: false, message: "Recommendations unavailable" },
  };
}
```

## Pattern 4: Fail Fast

**When:** Invalid state detected early in a function.
**Why:** Catch problems sooner = easier debugging, less damage.

```typescript
// ✅ Fail fast - validate at the boundary
function processPayment(amount: number, currency: string) {
  if (amount <= 0) throw new Error("Payment amount must be positive");
  if (!["usd", "eur", "gbp"].includes(currency)) throw new Error(`Unsupported currency: ${currency}`);
  // ... proceed with valid data
}

// ❌ Don't check deep inside nested logic where the error is hard to trace
```

## Pattern 5: Resource Cleanup

**When:** Code opens connections, file handles, timers, or subscriptions.
**Why:** Leaked resources cause memory issues and mysterious production bugs.

```typescript
// ✅ Always clean up - use try/finally
async function processFile(path: string) {
  const handle = await openFile(path);
  try {
    const data = await handle.read();
    return transform(data);
  } finally {
    await handle.close(); // Always runs, even on error
  }
}

// ✅ For subscriptions and intervals
useEffect(() => {
  const subscription = eventSource.subscribe(handler);
  const timer = setInterval(poll, 5000);
  return () => {
    subscription.unsubscribe();
    clearInterval(timer);
  };
}, []);
```

<!-- ═══════════════════════════════════════════════════ -->
<!-- REFERENCE                                          -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Anti-Patterns

| Anti-Pattern | Why It's Bad | Fix |
|---|---|---|
| `catch (e) { console.log(e) }` | No recovery, invisible in production | Structured reporting |
| Empty catch `catch {}` | Silently swallows errors | At minimum, log with context |
| `catch (e) { return null }` | Caller doesn't know it failed | Result type or re-throw |
| Catching too broadly | Hides different failure modes | Catch specific error types |
| No cleanup in error paths | Resource leaks | `try/finally` |
