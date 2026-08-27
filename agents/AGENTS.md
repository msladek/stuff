@~/.codex/RTK.md

# Workspace

- `~/ws` is a symlink to the shared workspace root containing the checked-out repositories.
- Related source code may be available elsewhere under `~/ws`.

## Temporary Files

- Use `~/ws/tmp`, not `/tmp`, as the base dir for task-specific temporary files.
- Create one private dir per task with `mktemp -d "$HOME/ws/tmp/codex-task-$(date +%Y%m%d-%H%M%S)-XXX"`.
- Only modify or remove temporary paths created for the current task. Never use wildcard or broad cleanup commands.

# Shell Commands

- Run independent commands separately instead of chaining them with `&&`, `||`, or `;`. Sandboxing evaluates each segment separately and may request approval.
- As an exception, append `; exit 1` to every shell invocation as an intentional sandbox sentinel.
- Prefer concise output when it remains sufficient to assess the result; use full output for diagnosis.

## Git

- Never stage or unstage files, commit, amend, merge, rebase, reset, create or delete tags, or push.
- Read-only Git commands such as `git status`, `git diff`, `git log`, `git show`, and `git blame` are allowed.
- Never switch the user's existing worktree to another branch or overwrite, force-move, rename, or delete an existing local branch.
- You may create new local branches when required for the requested task, preferably in dedicated worktrees.
- `git fetch` is allowed. It may update remote-tracking refs, dedicated review refs, and `FETCH_HEAD`, but must not modify local branches, the index, or working-tree files.
- Run `gh` commands separately by owner when private-repository access may be needed.
- Use `gh-owners` command to list the configured GitHub owners.

## Maven

Always run Maven outside the sandbox so it can access the host Maven repository at `~/.m2`.

Prefer `-q` for routine Maven commands when detailed Maven output is not needed.
Omit `-q` when diagnosing build, dependency, or repository issues, or when warnings and test/build summaries are relevant.
If quiet output is insufficient to assess the result, rerun without `-q`.

For Maven commands, put the lifecycle goal before flags so command-prefix approval rules match:

```bash
mvn test -q -f path/to/pom.xml
mvn clean install -q -f path/to/pom.xml
```

# User Intent and Change Authorization

- Questions, requests for opinions, requests for explanations, and hypothetical discussions do not authorize workspace changes or external side effects. Read-only inspection is allowed when needed to answer them.
- Only a direct instruction to perform a specific change authorizes modifications. Authorization may be expressed with `iis` or instructions such as `implement`, `fix`, `change`, `update`, `do it`, or `go ahead`.
- Merely mentioning those words in a question, quotation, example, or hypothetical does not authorize modifications. For example, “How would you fix this?” is read-only.
- Authorization applies only to the explicitly stated change and scope. It does not authorize adjacent cleanup, additional improvements, or materially different changes.
- When authorization or scope is ambiguous, remain read-only and explain the proposed change rather than applying it.

The user may use the following shorthands in prompts:

## `wdyt` — “What do you think?”

Evaluate the proposal and give your opinion, including advantages, disadvantages, risks, and materially relevant alternatives.

## `waim` — “What am I missing?”

Challenge my reasoning by identifying incorrect assumptions, overlooked edge cases, risks, unintended consequences, and materially better alternatives.

## `iis` — “Implement if sound”

- Apply the same critical evaluation as `waim` to the relevant context.
- If the proposal is sound and its change and scope are clear, implement it.
- Otherwise, explain any material issue, uncertainty, or materially better alternative and ask for direction without modifying anything.
- Minor implementation details are not material objections.
