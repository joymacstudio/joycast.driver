# Audit

Expert evaluation of codebase quality, architecture, and improvement opportunities.

**Arguments:** $ARGUMENTS

If argument provided — focus on that area. If empty — full codebase audit.

## Purpose

This is not about finding bugs or dead code (that's `/refactor`).

This is about stepping back and asking: "Given what we know today, could this be done better?"

You're acting as an external expert reviewing the codebase with fresh eyes and current best practices.

## Phase 1: Context

1. **Read CLAUDE.md** — understand current architecture, patterns, constraints
2. **Understand the product** — what does it do, who uses it, what matters most
3. **Review project history** — how did it evolve, what decisions were made and why

## Phase 2: Evaluation

Assess each area with a critical but fair eye:

### Architecture
- Is the structure clear and logical?
- Are responsibilities well-separated?
- Is there unnecessary complexity?
- Would a simpler approach work just as well?

### Reliability
- What can fail? What happens when it does?
- Are there single points of failure?
- Is error handling consistent and robust?
- Are edge cases covered?

### Performance
- Are there obvious bottlenecks?
- Is work done efficiently (no redundant operations)?
- Are resources used appropriately?

### Maintainability
- How easy is it to understand the code?
- How easy is it to make changes?
- Are there parts that everyone is afraid to touch?
- Is the code self-documenting or does it need comments?

### Modern Practices
- Are there outdated patterns that have better alternatives now?
- Are deprecated APIs still in use?
- Could newer language/framework features simplify things?

## Phase 3: Assessment

For each area, provide honest assessment:

### ✅ Good
What's working well. Acknowledge good decisions.

### ⚠️ Could Be Better
Things that work but have room for improvement. Explain the trade-off.

### 🔄 Consider Rethinking
Approaches that might benefit from a different solution. Explain why and what the alternative would be.

## Phase 4: Recommendations

Prioritize recommendations by impact:

### High Impact
Changes that would significantly improve reliability, performance, or maintainability.

### Medium Impact
Improvements worth doing when touching that code anyway.

### Low Impact
Nice-to-haves, not urgent.

For each recommendation:
- What to change
- Why it's better
- Effort estimate (small / medium / large)
- Risks or trade-offs

## Guidelines

- **Be honest** — if something is bad, say so. If it's good, say that too.
- **Be specific** — vague feedback is useless. Point to concrete code.
- **Be pragmatic** — perfect is the enemy of good. Working code has value.
- **Don't invent problems** — if the codebase is solid, say so and be done.
- **Consider context** — solo developer, evolving requirements, shipping matters.

## Output

Provide:
1. **Overall assessment** — brief summary of codebase health
2. **Detailed findings** — by category
3. **Prioritized recommendations** — actionable next steps
4. **What's good** — explicitly acknowledge what doesn't need changes
