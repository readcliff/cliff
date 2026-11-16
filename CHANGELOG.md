# Changelog

## 0.2.0 (16 November 2026)

- Cloud tasks: `cliff cloud run "task" [--repo url] [--publish]`, then `status`, `logs`, `download`, `stop` and `list`. One free task per wallet per day.
- Inside a cloud task Cliff has no wallet tools and refuses wallet commands. Your model key is scrubbed from the log, the answer and the files.
- `cliff key new`: a free API key signed by your own wallet, no browser needed.
- Offline: a model server on your computer needs no key, and every answer shows $0. `cliff setup` lists the base URLs for Ollama, LM Studio and llama.cpp.
- `-p --json --log` prints each step to stderr while the JSON answer goes to stdout.

## 0.1.0 (15 November 2026)

- The terminal agent as one MIT file with no dependencies, for Node 18 and later.
- Models from Anthropic, OpenAI and Google Gemini, plus any OpenAI-compatible endpoint, with tokens and cost shown after every answer.
- Tools: list, read, search, write and edit files; shell commands; web fetch; memory; sessions with `--continue`; MCP servers over HTTP and stdio.
- A Robinhood Chain wallet: key made or imported locally and encrypted with scrypt and AES-256-GCM; balances, confirmed sends with a per-send limit, swap quotes for Pons tokens.
- Live links: `cliff publish` puts a folder of static files at a shareable link.
