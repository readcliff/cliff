# Cliff

An open-source AI agent for your terminal, with its own wallet on Robinhood Chain.

Cliff reads and edits your files, runs commands when you say yes, fetches the web, puts a folder at a live link and keeps a wallet whose key never leaves your computer. You bring the model: Claude, GPT, Gemini, or a local model through any OpenAI-compatible endpoint, so it also works offline.

One file, no dependencies, MIT. Website: https://readcliff.xyz

```sh
curl -fsSL https://readcliff.xyz/install.sh | sh
```

The installer checks for Node.js 18 or later, downloads `cliff.mjs`, checks its SHA-256 against `version.json` and adds a `cliff` command to `~/.local/bin`. It is short; [read it first](install.sh) if you like. You can also download [`cliff.mjs`](cliff.mjs) from this repo and run it with `node cliff.mjs`.

## Use it

```sh
cliff setup                 # pick a provider, model and key (the key stays on this computer)
cliff                       # chat in this folder
cliff -p "fix the failing test" --json
cliff publish ./site        # a live link for a static folder (free links last 7 days)
cliff wallet new            # make a Robinhood Chain wallet, encrypted with your passphrase
cliff mcp add <name> <url>  # plug in any MCP server
cliff cloud run "add a dark mode toggle" --repo https://github.com/you/site
cliff doctor                # check the setup
```

Every file change shows a diff and waits for a yes. Every command shows the exact line first. Wallet sends always ask, every time, and need your passphrase.

## What it can do

- **Files and commands.** List, read and search your project, edit with a diff you approve, and run shell commands after you see them.
- **Web fetch.** Pages come back as text, wrapped as data, so a page can't give Cliff orders.
- **A wallet on Robinhood Chain.** Make or import a key, encrypted on your disk with scrypt and AES-256-GCM. Balances, confirmed sends with a per-send limit, and quotes for Pons tokens. It never swaps on its own.
- **Live links.** Publish a folder of static files to a shareable link on readcliff.xyz.
- **MCP.** Add any MCP server over HTTP or as a local command.
- **Memory and sessions.** Notes in a plain text file, saved chats, and `--continue` to pick up where you left off.
- **Costs in the open.** After every answer Cliff shows tokens and cost at the provider's list price. You pay your provider directly; Cliff adds nothing.

## Offline, with a local model

Point `cliff setup` at a model server on your own computer (Ollama, LM Studio or llama.cpp, or anything OpenAI-compatible). A local model needs no key, nothing leaves your computer except the pages you ask it to fetch, and every answer shows $0.

## Cloud tasks

`cliff cloud run "task"` hands a job to a throwaway machine (a Vercel Sandbox) and lets you close the laptop. The machine installs this same `cliff.mjs`, checked against `version.json`, optionally clones a public repo or takes uploaded files, runs the task with your own model key, streams the log and packs the changed files for download. It can also publish an output folder to a live link. Then it is stopped and deleted.

- `cliff key new` makes the API key the cloud uses, signed by your wallet, with no browser needed.
- `cliff cloud status|logs|download|stop <task>` and `cliff cloud list` follow a task.
- One task per wallet per day is free. After that a task costs 1 credit a minute, charged up front, and unused minutes come back.
- Inside a cloud task Cliff has no wallet tools and refuses wallet commands.
- Your model key is sent per task, passed to the machine only as an environment variable, and never stored or logged. The log, the answer and the files are scrubbed of it.

## Where your data lives

Everything Cliff keeps is in `~/.cliff` on your computer: config, keys, memory, sessions and the encrypted wallet. Nothing is sent anywhere except to the model provider you choose, the pages you ask it to fetch, the Robinhood Chain RPC for wallet calls, and readcliff.xyz when you publish a link or run a cloud task.

## Tests

```sh
node test/run.mjs           # offline tests: hashing, keys, signing, RLP, units, prices and the file tools
node test/release.mjs       # writes version.json (size and SHA-256 of cliff.mjs) for a release
```

## The token

`$CLIFF` buys credits for hosted extras, such as live links that last 30 days and cloud task minutes beyond the free one a day. Buying credits burns it. The agent itself is free and always will be. It is not an investment, and nothing here promises returns.

## License

MIT. See [LICENSE](LICENSE). Changes are listed in [CHANGELOG.md](CHANGELOG.md).
