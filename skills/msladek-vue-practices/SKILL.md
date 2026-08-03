---
name: msladek-vue-practices
description: Apply reactive, declarative Vue 3 and Pinia practices when writing, reviewing, refactoring, or debugging Vue components and related TypeScript. Use for Composition API components, composables, Pinia stores, watchers, derived state, service extraction, async actions, and Vue code-structure decisions.
---

# msladek Vue Practices

Favor reactive data flow over imperative synchronization:

`computed` for derivation → `watch` for effects → actions for commands.

Inspect neighboring code and reuse the project's established Vue, Pinia, composable, service, and formatting patterns before introducing a new pattern or dependency.

## Own state at the smallest useful boundary

- Keep state local when only one component owns it.
- Extract stateful logic into a composable when it represents a cohesive concern, improves a large component, or is reusable.
- Use Pinia for state shared across components or representing a feature/application domain.
- Put network, storage, and external-system operations in services or clients.
- Keep stateless transformations as plain functions.
- Do not create a store, composable, or service merely to add a layer.

## Model data reactively

- Keep writable source state minimal with `ref` or `reactive`.
- Express every value derivable from reactive inputs with `computed`.
- Keep computed getters pure and their results read-only; update source state instead of mutating, performing I/O, manipulating the DOM, or triggering effects.
- Copy props, computed values, or store state into local refs only for an intentionally independent editable draft. Initialize or reset it from its source deliberately, derive dirty, save, and undo capabilities, and submit a snapshot through an explicit command.
- Derive permission and workflow capabilities such as `canEdit`, `canSave`, and `canDelete` with `computed`.
- Preserve reactivity when destructuring. Use `storeToRefs` for Pinia state and getters; destructure bound actions directly from the store.
- Prefer a writable computed or `defineModel` for two-way projections instead of paired synchronization handlers.

## Use effects deliberately

- Use `watch` only for side effects, external synchronization, or explicit state transitions; derive reactive values with `computed` instead.
- Use `watchEffect` when automatic dependency tracking is genuinely clearer than explicit sources.
- Avoid watcher chains, feedback loops, and broad deep watchers.
- Debounce or throttle external effects and requests, not source state or computed derivation.
- Own resource cleanup alongside registration in a composable or lifecycle hook: cancel stale async work and clean up subscriptions, timers, and listeners.

## Shape stores and composables clearly

- Prefer setup-style Pinia stores when that matches the repository.
- Expose source refs, computed getters, and focused actions from stores.
- Keep domain-derived state in store-level computed getters when multiple consumers need it.
- Let composables accept refs or getters when inputs must stay reactive.
- Return a plain object of refs, computed refs, and actions from composables so destructuring retains reactivity.
- Prefer Vue, the browser platform, or established project composables for common storage, event, polling, timing, and cleanup behavior.

## Keep components declarative

- Define typed public component contracts with props, emits, slots, `v-model`, and minimal exposed APIs. Use generics when genuinely generic, and bind templates through those contracts and computed values.
- Make thin wrappers transparent: deliberately forward supported attributes and slots, and expose only the imperative API consumers require.
- Preserve semantic markup, associated labels, accessible names, and stable identity keys when composing components.
- Avoid direct DOM access unless integrating an imperative browser or third-party API.
- Let components compose state and behavior; move substantial domain logic and I/O to their proper boundaries.
- Keep templates simple by naming non-trivial conditions and transformations as computed values.
- Use the project's localization and locale-aware formatting facilities for user-visible text, dates, and numbers.
- Never render untrusted HTML without a reviewed sanitizer.

## Keep application boundaries explicit

- Use generated API documents and types when available instead of duplicating transport contracts.
- Centralize client construction, authentication, caching, and global plugin setup outside components.
- Use typed injection keys for application-provided dependencies and configuration.
- Lazy-load routes and other large optional UI boundaries when it materially reduces initial work; do not async-wrap small components without a measured or evident benefit.

## Keep commands explicit

- Use actions or named functions for user commands, mutations, navigation, and requests.
- Recheck permission and workflow invariants inside commands even when the UI exposes a computed capability flag.
- Keep loading and error state close to the action that owns it.
- Reset loading state reliably with `try`/`finally`.
- Prevent duplicate submissions and concurrent command races.
- Centralize mutations that must preserve shared invariants.

## Structure code by concern

- Treat modules, `<script setup>`, component `setup()`, and Pinia setup functions as composition roots.
- Use blank lines at composition roots to group cohesive concerns.
- Do not use blank lines to divide ordinary functions; extract named functions when one needs visual sections or handles multiple responsibilities.
- Prefer cohesive functions over rigid line-count limits.
- Keep related state, computed values, effects, and actions near one another instead of grouping everything by primitive type.

## Work and review

1. Trace the data flow, classify source state, derived state, effects, and commands, and select the smallest appropriate owner.
2. Implement the smallest coherent change, replacing duplicated or manually synchronized derived state without speculative abstractions.
3. Run the repository's relevant formatter, linter, type checker, and focused tests.

Check before finishing:

- Could any writable or synchronized state be computed?
- Is state owned once at the smallest boundary, with every copy an explicit draft and reactivity preserved?
- Does every effect or async command have a real purpose, clear ownership, cleanup, and race protection?
- Are public component and application boundaries typed, secure, localized, and accessible?
- Is every extraction justified by ownership, cohesion, or reuse, and would a named helper improve an ordinary function?
