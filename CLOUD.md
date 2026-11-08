# Cloud install (Claude Code on the web)

A step-by-step guide for using this kit with **Claude Code on the web**: the
version you open at [claude.ai/code](https://claude.ai/code), or in the Claude
app, where Claude works on a computer in the cloud rather than on yours.

You don't need to install anything on your own computer, use a terminal, or
know how to program. It takes about five minutes.

> Using Claude Code on your own machine instead (the terminal CLI, an IDE
> extension or the desktop app)? Follow [LOCAL.md](LOCAL.md).

## What this kit does, in plain words

Normally one Claude does all the work in a session. This kit gives it a small
team of helpers, each suited to one kind of job:

| Helper | What it's for |
|--------|---------------|
| `scout` | Quickly finds where things are in a project. |
| `planner` | Writes a plan before a bigger change. |
| `coder` | Makes the changes the plan describes and runs the tests. |
| `reviewer` | Checks the finished work for mistakes. |
| `archivist` | Looks things up in your past sessions. |

The kit also gives the main Claude a short set of rules for when to hand work
to a helper. The goal is to use your plan's usage more efficiently on long
tasks. You don't have to do anything differently: just use Claude Code as
usual.

## Why there's a setup step

Every new cloud session starts on a brand-new, empty computer, which is thrown
away when the session ends. So anything you install by hand during one session
is gone in the next.

To get the kit into **every** session, you save one line in your
**environment's setup script**. An *environment* is the saved settings your
cloud sessions run with. Its *setup script* is a list of commands that runs
automatically at the start of each new session. You add the line once, and
from then on every new session installs the kit by itself.

## What you need

- A Claude account that can use Claude Code on the web
  ([claude.ai/code](https://claude.ai/code)).
- That's all. This repository is public, so you don't need a GitHub account or
  any password for the kit itself.

## Step by step

### 1. Open your environment's settings

1. Go to [claude.ai/code](https://claude.ai/code) and open a session (a new or
   an old one, either is fine).
2. At the top of the session, in the title bar, click the **name of the cloud
   environment** (often it's called **Default**). A menu opens.
3. Next to the environment, click **Edit**.

The menus sometimes move a little as the app is updated. If you can't find
them, see Anthropic's guide:
[Cloud environments](https://code.claude.com/docs/en/cloud-environments).

### 2. Paste the line into "Setup script"

Find the box called **Setup script** and paste in this line exactly. On GitHub,
the copy button at the right of the box below copies it for you:

```bash
git clone --depth 1 -b master https://github.com/Marku-a/claude-agents /tmp/claude-kit && bash /tmp/claude-kit/install.sh || true
```

- It must stay on **one line**. Don't add line breaks inside it.
- If the box already has something in it, **don't delete it**. Click at the
  end, press Enter to start a new line, and paste there.
- **Leave "Network access" as it is.** The default setting already lets the
  kit download. You don't need to add any websites. The download is only
  blocked if network access is turned off completely (see Troubleshooting).
- Don't paste passwords or keys into the setup script. The kit doesn't need
  any.

### 3. Save

Click **Save**.

### 4. Start a new session

The setup script only runs when a session **starts**. Sessions that are already
open don't get the kit, so start a **new** session.

### 5. Check that it worked

In the new session, type:

> what agents are available?

The answer should list `scout`, `planner`, `coder`, `reviewer` and
`archivist`. If it does, you're done.

## What it changes (and what it doesn't)

- It only changes files on the throwaway cloud computer of each session:
  it adds the helper files and a section of rules to Claude's settings there.
- It never touches your own computer, your projects or your account settings.
- It never asks for, reads or stores any password or key.

## Good to know

- **Updates happen by themselves.** Each new session downloads the latest
  version of the kit, so there's nothing to update.
- **More than one environment?** The line only works in the environment you
  saved it in. If you use several, add it to each one.
- **Usage.** The helpers run on different Claude models: `scout` and
  `archivist` on Haiku (cheap and fast), `coder` on Sonnet, and `planner` and
  `reviewer` on Opus. Their work counts toward your plan's usage like
  everything else.
- **Turning it off.** Edit the environment again, delete the line, save, and
  start a new session.

## Troubleshooting

If the helpers don't show up in step 5, check these in order:

1. **Was it a new session?** Only sessions started *after* you saved get the
   kit. Start another new one.
2. **Is it the right environment?** Look at the environment name at the top of
   the session. It must be the one where you saved the line.
3. **Is the line exact?** Open the setup script again and compare it with the
   line above: one line, nothing missing at the start or end. If in doubt,
   delete it and copy it again.
4. **Is network access turned off?** If the environment's **Network access**
   is set to **None**, the kit can't download. Set it back to the default
   (Limited).
5. **Still stuck?** Ask the session itself: "Did the setup script run? Why
   are the agents from claude-agents missing?" Claude can look at the cloud
   computer and tell you what went wrong.

The end of the line (`|| true`) means a failed install never stops your
session from starting. You'd just be working without the helpers until it's
fixed.
