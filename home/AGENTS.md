## Authoring CLAUDE.md

- Structured format that enable scanning by human.
- Don't write long sentences or paragraphs: prefer lists.
- Write out tree structure in a human-readable way with a short comment next to a directory/ branch

## README content outline
The content is to the point and **always** follow this format:

- Overview: a short paragraph on what this repository contains.
- Structure: a table of the list structure.
- Glossary: domain specific terms only.
- Architectural decisions: considered solutions including disregarding alternatives. 

## Writing Style

- Never use the em dash "--", use plain dash "-" instead
- Avoid writing sentences relying on rhetorical grips
- Avoid writing sentences using colons ":" ("this reads like something specific: AI slop")
- Avoid writing sentences relying on gotchas ("it is not like this, it is like THIS")

## Working with code

- Answers are short and to the point.
- Sacrifice sentence structure for clarity.
- Prefer to put answers in list format.
- No long paragraphs, bullet lists only.
- For R code: when given clear instructions, never suggest or guess intention. Execute as instructed.
- For open-ended/exploratory work (parameter choices, diagnosing a bug, comparing approaches): discuss first, then test/run diagnostics and write up the result as a `.qmd` rendered to html in `notebooks/`, so we can look at it together and make an informed decision - rather than editing the production `.R` script directly. Only fold the result into the `.R` script once we've agreed on it from the notebook.

## Permissions

- Never modify auto-generated content (explicit and implicit), like CHANGELOG.md, _targets etc.

## Git

- Don't add yourself as a co-author in commit messages by default. Ask first before including one for larger commits, or for commits in languages outside my comfort zone.

## Imports
- My identity profile from @identity.md
