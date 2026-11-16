---
name: lexicon
description: Use when adding fantasy dictionary or fictionary lexicon entries for requested characters, places, names, or lore terms.
compatibility: opencode
---

## Purpose

Create dictionary-style lexicon entries for fantasy characters, places, names, and lore terms requested by the user.

## When To Use

Use this skill when the user asks to create, add, draft, or update entries for a fantasy dictionary, fictionary lexicon, glossary, character index, place index, or similar reference.

The user may provide one name, multiple names, or a mixed list of characters, places, and terms.

## Required Workflow

1. Identify the exact list of requested entries.
1. Read the `AGENTS.md` file in the current working directory before drafting any entry.
1. Follow the lexicon format, style, source URL, and repository-specific instructions from that `AGENTS.md`.
1. Use only the wiki page indicated by `AGENTS.md` as the source of truth.
1. For each requested entry, find the corresponding wiki page.
1. Draft entries strictly from that wiki page only.
1. If a requested page is missing, incomplete, ambiguous, or does not contain enough non-spoiler information, report that clearly instead of inventing content.

## Execution Constraints

- Never process entries as a batch. If the user requests multiple entries, handle them one by one from source lookup through drafting and validation before moving to the next entry.
- Never write or run scripts to generate, transform, validate, sort, deduplicate, or otherwise process lexicon entries.
- For multi-entry requests, defer only the whole-list sorting and duplicate-name check until every individual entry has been drafted and validated.
- Do not perform any other batch-level editing, validation, generation, or cleanup.

## Source Rules

Use the wiki page specified in `AGENTS.md` as the exclusive source of truth.

Do not use:

- internal memory
- other websites
- fandom knowledge
- books, games, films, or adaptations not present on the wiki page
- inferred lore
- plausible but unsourced details

If the wiki page does not support a detail directly, omit it.

# Entry Requirements

Each entry must be:

- thorough
- lore-rich
- clearly written
- strictly derived from the corresponding wiki page
- spoiler-free
- suitable for a dictionary or lexicon

## Spoiler Policy

Avoid spoilers completely.

Do not include:

- plot twists
- deaths
- betrayals
- hidden identities
- late-story revelations
- final outcomes
- major character arc resolutions
- chronology that reveals future events

If the wiki page is spoiler-heavy, extract only safe introductory, descriptive, or contextual information.

## Content Guardrails

Do not include:

- repeated names
- filler
- irrelevant trivia
- unsupported interpretation
- overly generic descriptions
- details included only to make the entry longer
- redundant useless details, like overblown descriptions of clothes, appearances and so forth.
- wiki metadata, navigation text, edit notices, citations, tables of contents, category labels, or maintenance notes.

## Missing Or Unsafe Entries

If an entry cannot be created safely, explain the reason briefly.

Use this kind of response:

`Could not create an entry for <name>: the wiki page is missing, incomplete, ambiguous, or too spoiler-heavy to produce a safe entry from the allowed source.`

## Output

Produce only the requested lexicon entries unless the user asks for explanation.

Keep the final entries polished, concise, and directly usable in the target lexicon.

## Finalisation

- **Final check**: after producing a draft for an entry description, report to the user whether you have performed all individual checks, validation and guardrails indicated throughout the skill. If any checks failed you must re-do the work untill all checks pass. If you are given a list of character entries to add, perform the check one by one after each character _before_ moving to the next one. Produce a table that shows, for each entry, whether each single requirement in "Content guardrails" and "Spoiler policy" is fulfilled.
