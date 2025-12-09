---
name: "/verify-37signals"
description: "Review local changes against 37signals 'Code I Like' best practices"
agent: agent
---

# Context

This command reviews your current uncommitted changes to ensure they align with the 37signals "Code I Like" series principles.

# Principles to Enforce

## 1. Domain-driven boldness
- **Naming:** Look for bold, domain-specific naming (e.g., `erect_tombstone` vs `delete`). Avoid aseptic CRUD terms if a domain term exists.
- **Roles:** Check if roles are implemented clearly, potentially using Concerns.
- **Eloquent Code:** Code should read like a description of the business process.

## 2. Fractal journeys
- **Abstractions:** Check if code exhibits "fractal" qualities—similar patterns of clarity at different levels.
- **Orchestration:** High-level methods should orchestrate lower-level cohesive operations without mixing implementation details.
- **Symmetry:** Ensure operations in a method are at the same level of abstraction.

## 3. Good concerns
- **Usage:** Concerns should be used to extract cohesive "traits" or "roles" (e.g., `Trashable`, `Visible`), not just to split large files.
- **Semantics:** Each concern must represent a genuine "is-a" or "has-a" relationship.
- **Simplicity:** Don't replace standard OO (inheritance, composition) with concerns unnecessarily.

## 4. Vanilla Rails is plenty
- **Architecture:** Avoid unnecessary "Service Objects" or "Interactors" if standard Rails patterns suffice.
- **Fat Models:** It's okay to have rich models. Use concerns to organize them, not arbitrary service layers.
- **Direct Access:** Controllers can access domain models directly.

## 5. Active Record, nice and blended
- **Persistence:** Don't artificially separate persistence from domain logic. Active Record models *should* contain business logic.
- **Associations:** Use rich associations and scopes to express queries and relationships naturally.

## 6. Pragmatism (Globals & Callbacks)
- **Callbacks:** Acceptable for orthogonal concerns (lifecycle events, secondary logic).
- **CurrentAttributes:** Acceptable for global request context (e.g., `Current.user`).
- **Purity:** Prioritize convenience and readability over strict architectural purity.

# Instructions

## Step 1: Analyze Changes
1. Run `git diff` to see the changes.
2. Identify the key areas modified (Models, Controllers, new abstractions).

## Step 2: Verify Against Principles
For each change, ask:
- **Naming:** Is it bold and domain-specific? (Principle 1)
- **Structure:** Is it fractal? Are levels of abstraction mixed? (Principle 2)
- **Organization:** Are concerns used correctly? (Principle 3)
- **Architecture:** Is it "Vanilla Rails" or over-engineered? (Principle 4)
- **Logic:** Is domain logic blended with persistence effectively? (Principle 5)

## Step 3: Report
- **Commendations:** Point out where the code follows these principles well.
- **Violations:** Flag any specific lines or patterns that contradict the principles.
- **Suggestions:** Offer specific refactoring advice to align better (e.g., "Rename `remove` to `discharge_patient` to match the domain language").

If the changes are minor or unrelated (e.g., config changes), state that the principles may not apply.
