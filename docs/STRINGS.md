# "Zed" in strings — what Zeo renames, and what it must not

Measured 2026-09-13 against Zed `9d272b036335`: **404 string literals** in
`crates/` contain the word `Zed`. Patch `0025` changes **21** of them. This file
is why the other 383 stay. Re-measured 2026-10-07 — see
[the last section](#re-measured-2026-10-07-against-cb73ee1d45db).

Re-run the count before trusting any number here:

```sh
grep -rhoE '"[^"]*\bZed\b[^"]*"' crates/ --include='*.rs' | wc -l
```

## The axis is not "is it visible" — it is "what does it name"

The first pass classified by visibility and got 245 candidates. Nearly all were
wrong, because the most visible "Zed" strings are visible *precisely because they
name Zed Industries*:

> `Upgrade to Zed Pro` · `Your Zed Pro Trial has expired` · `Sends the current
> conversation to the Zed team` · `Authorize Zed in your browser` · `Zed's hosted
> models`

Zeo runs on Zed's backend by design ([`REBRAND.md`](REBRAND.md) §3). There is no
Zeo Pro; the OAuth page really does say Zed, the conversation really does go to
Zed's team, and the subscription really is theirs. Renaming these would not be a
rebrand — it would be false.

**The rule: a literal becomes "Zeo" only when it names the application the user
is running.** Vendor, service, plan, team and hosted models stay "Zed".

## What must never change, and what breaks if it does

| Class | Count | What breaks |
|---|---|---|
| **Font family names** — `Zed Mono`, `Zed Sans`, `Zed Plex Sans`, `Zed Icons` | 15 | values of `font_family:`; the file behind `Zed Mono` is *Lilex*, shipped under that alias. The editor stops finding its own font |
| Vendor, plan, team, hosted models | 42 | states something untrue |
| Tests, fixtures, examples | 31 | noise; and the window-title tests assert the *old* format |
| Windows paths, `.exe`, `C:\Zed Data` | 19 | not built here |
| `User-Agent` — `Zed/{} ({}; {})` | 3 | changes what remote servers see |
| Theme names — `Zed (Default)` | 3 | breaks themes referenced from user settings |
| `migrator.rs` literals | — | corrupts settings migration |
| `zed.dev` URLs (156) and the `zed://` scheme (70) | — | decided in REBRAND §3 and patch `0022` |

## One large class needed no patch at all

The **window title** — the string a user sees more than any other — is built from

```rust
ReleaseChannel::try_global(cx).unwrap_or(Stable).display_name()
```

which patch `0021` already makes return `"Zeo"`. **75 sites reach the product
name that way.** The three `"Zed — root1, root2"` literals that looked like the
highest-value target are *test assertions* for that code.

This is the pattern worth copying: where the product name is read from the
channel, the rebrand is free and cannot drift.

## What `0025` does cover

| | |
|---|---|
| seen constantly | `Welcome to Zeo` · `Welcome back to Zeo` · `Open Zeo Log` · `Zeo — Settings` · `Zeo failed to launch` |
| seen on events | the update flow · CLI installation · the xdg-desktop-portal error · the OAuth callback page · `Add to existing Zeo window` |

## What was left out on purpose

**24 settings descriptions** and **154 log, error and macOS-only strings.** They
are upstream UI copy — the churniest kind of file — so each one bought costs a
`refresh.sh` conflict forever, for text read once or never.

## Why literals and not `display_name()`

`display_name()` would be better in principle: self-maintaining, and plausibly
upstreamable, since Zed Nightly displays "Zed" in these same strings where it
should display its own channel name.

It was tested and rejected for `0025`. The sites bind to `&'static str`:

```rust
let label = match auto_updater.map(...) {
    Some(AutoUpdateStatus::Updated { .. }) => "Please restart Zed to Collaborate",
    ...                                     => "Updating...",
};
```

Reaching for `display_name()` forces `format!`, which turns the binding into a
`String` and drags in sibling arms like `"Updating..."` that have nothing to do
with the rebrand. Converting those sites properly is a separate change, and one
worth offering upstream rather than carrying.

## Re-measured 2026-10-07 against `cb73ee1d45db`

Three weeks of snapshots later, upstream had added **6** literal texts containing
`Zed` and removed none (354 → 360 sites, unpatched). The comparison is by text, so
a literal that only moved or lost an `.into()` — all eighteen "support is built-in
to Zed!" lines did — does not count as new:

```sh
# in each tree; then diff the second column
grep -rnoE '"[^"]*\bZed\b[^"]*"' crates/ --include='*.rs' | sed -E 's/^([^:]+):[0-9]+:/\1\t/' | sort -u
```

| New text | Where | Decision |
|---|---|---|
| "Made by the Zed team…" — the Delta announcement | `auto_update_ui` | stays: Delta is Zed Industries' product |
| "Zed's edit predictions not included in the Free plan." | `edit_prediction_ui` | stays: their plan |
| "Not signed in to Zed." · "Zed rejected the credentials…" | `language_models_cloud` | stays: their account and service |
| "…Grok models in Zed's agent." | `x_ai_subscribed` | stays, with the OpenAI and Copilot lines that say the same |
| "Zed is awesome!" | `markdown` tests | stays: a test |

The lowercase surface moved as little: `.zed/` 139 → 144 references, `zed.dev` 183
→ 189, three new internal `ZED_*` variables. None is a candidate.

**What the re-measurement did find was two misses, not new strings:**

- **The application menu.** "Zed", "About Zed", "Quit Zed" and the About window's
  title are not macOS-only: on Linux the title bar renders the same menus. `0025`
  now builds them from `display_name()`, which takes `format!` cleanly here because
  `MenuItem::action` and `Menu::name` take `impl Into<SharedString>`. The `f10`
  binding opens that menu **by name** — `["app_menu::OpenApplicationMenu", "Zed"]`,
  compared with `==` — so `0025` also treats `"Zed"` as the application menu's old
  name instead of editing `default-linux.json`, which is churny upstream and would
  still leave every user keymap that names it broken.
- **`ideName` in the Claude Code lock file** came from our own patch `0002`, so it
  never appeared in an upstream inventory. It is now the release channel's display
  name — Zeo here, still correct for Zed upstream, where `0002` is offered.

Still deliberately unchanged, and why, beyond the table above: the four doc comments
"without repeating Zed's defaults" (settings schema hover text — one conflict per
bump for text almost nobody reads), `serverInfo.name: "zed"` in `0002`'s MCP server
and the ACP/MCP/DAP/OAuth client names (protocol identities other software may key
on), and the `"Zed Agent"` agent id, which is stored in every native thread's row —
renaming it would orphan those threads exactly as removing an `agent_servers` entry
does.

## Added 2026-10-09: the root refusal (story 032)

| Text | Where | Decision |
|---|---|---|
| "Running Zed as root or via sudo is unsupported." · "…all subsequent non-root usage of Zed." | `util` (`prevent_root_execution`) | renamed in `0025`: it is printed to whoever just started this binary. `ZED_ALLOW_ROOT` keeps its name — an environment variable a user already sets is an interface, like `f10`'s menu name |

`check-rebrand.sh` never listed it, before the fix or after: the message is one
string literal spread over four lines, and the scanner reads a literal one line at
a time, so a multi-line literal is invisible to it. The rebrand baselines therefore
did not change; a re-measurement that wants this class has to read across lines.
