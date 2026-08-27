---
name: msladek-pr-review
description: Review one or more pull requests. Use when asked to review a PR, open PRs matching a ticket or issue, or a related cross-repository PR series.
---

# msladek PR Review

Inspect current PR snapshots from isolated worktrees and report findings first.

Before reviewing, read applicable repository instructions and documented conventions, use relevant domain skills, and compare changed implementations and tests with neighboring examples.

## Prepare review snapshots

Use `gh` to resolve current matching PRs and their exact base and head commit IDs; do not rely on local branch names or stale remote-tracking refs. For related PRs, establish dependency and rollout order.

Reuse a local repository only when its canonical remote matches or is a mere rename; otherwise use a temporary clone. Fetch the exact commits into dedicated review refs, create a detached temporary worktree at each head commit, and verify its `HEAD` and comparison base before reviewing.

## Review the actual change

1. Read applicable repository instructions and documented conventions and use relevant domain skills.
2. Review the complete `base...head` diff, every changed file, and enough repository context to trace changed behavior through callers, configuration, tests, and runtime paths.
3. For related PRs, verify cross-PR contracts, artifacts, dependencies, compatibility, and rollout order end to end.
4. Inspect checks and existing review comments, but verify their claims independently.
5. Perform separate behavior, implementation-quality, test, and style passes. Complete every applicable pass regardless of validation results.
6. Review correctness, security, compatibility, runtime and deployment integration, implementation quality, and tests wherever applicable. Passing builds and tests are evidence, not a substitute for inspecting runtime behavior, wiring, failure paths, assertions, mocks, and missing runtime or integration coverage.
7. Judge code style first against documented conventions, then consistent neighboring patterns, then the wider repository. Without a stable convention, report only blatant readability or consistency problems.
8. Keep scope to the requested PR diffs and acceptance criteria.

## Validate proportionally

Trust PR code only when its repository belongs to the authenticated user or one of their organizations. Otherwise inspect it statically and rely on existing CI.

For trusted PRs, run the narrowest relevant syntax checks, tests, builds, or artifact inspections from the temporary worktree.

## Report findings first

Report demonstrated, actionable correctness, maintainability, code-style, test, and documented-convention findings introduced by the PR. Do not suppress a material finding merely because it is not a correctness defect.

Order findings by severity and then by PR while labeling their type accurately. Cite the exact PR-head location for every finding. For correctness and security findings, explain the failing scenario, impact, and cause. For maintainability, test, and style findings, provide concrete evidence. Name the smallest safe correction when useful.

If there are no findings, say so explicitly. Always state validation performed and remaining gaps.

Keep review worktrees and temporary clones after reporting findings so follow-up questions can be investigated against the same exact commits. Report their paths. After the user confirms the review is finished, remove clean snapshots and the empty task directory.
