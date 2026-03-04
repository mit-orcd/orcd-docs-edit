---
tags:
 - LLM
 - Containers
 - Howto Recipes
 - Engaging
---

# Running a Personal OpenClaw AI Assistant on Engaging

*Contributed by Quilee Simeon (qsimeon@mit.edu)*

[OpenClaw](https://github.com/openclaw/openclaw) is an open-source AI assistant
platform that connects to cloud LLM providers (Anthropic Claude, OpenAI GPT-4o,
Google Gemini, OpenRouter, etc.). This recipe deploys OpenClaw on the Engaging
cluster using [Apptainer](../software/apptainer.md) so the agent has direct
access to your research data and cluster compute resources.

!!! warning "Responsible Use and Data Privacy"
    Because OpenClaw sends your prompts and any referenced file contents to
    **cloud LLM providers** for inference, you should treat it like any other
    cloud service:

    - **Only use low-risk data.** Do not expose sensitive, export-controlled,
      or ITAR data to the agent. If you are unsure about your data
      classification, consult [MIT IS&T data classification guidelines](https://ist.mit.edu/security/data-classification).
    - **Only grant access to what the agent needs.** Use the `--containall`
      flag and explicit `--bind` mounts (see
      [Accessing Research Data](#accessing-research-data)) rather than
      exposing your entire home directory.
    - **Review third-party skills carefully.** OpenClaw supports community
      skills that can execute arbitrary code. Only install skills from
      sources you trust, and audit skill code before enabling it.
    - **Keep sandboxing enabled.** OpenClaw's built-in sandbox restricts the
      agent's ability to run commands and modify files. Disabling it gives
      the agent your full user permissions on the cluster — see
      [Sandboxing](#sandboxing) below.

The code and Apptainer configuration for this recipe can be found in the
[openclaw-engaging](https://github.com/qsimeon/openclaw-engaging) GitHub
repository, which is a fork of the upstream
[OpenClaw](https://github.com/openclaw/openclaw) project with HPC-specific
additions for SLURM and Apptainer.

## How It Works

The OpenClaw gateway runs inside a read-only Apptainer `.sif` container on a
SLURM compute node. The agent calls cloud LLM APIs over HTTPS — no local GPU is
needed for inference. All agent state (conversation history, configuration,
workspace) is stored in a persistent directory (we recommend using scratch
space — see [Session Persistence](#session-persistence)), so it survives job
preemptions.

You access the web dashboard from your laptop via an SSH tunnel through a login
node, similar to the [port forwarding approach used for Jupyter](jupyter.md#port-forwarding).

```
Your laptop (browser)
    │
    │  SSH tunnel (port 18790)
    ▼
Login node (orcd-login.mit.edu)
    │
    │  forwards to compute node
    ▼
Compute node (SLURM job)
    └── Apptainer container
        └── OpenClaw gateway (port 18790)
            └── calls cloud LLM APIs (HTTPS)
```

## Prerequisites

- An MIT Engaging account ([request access](https://orcd-docs.mit.edu/getting-started/))
- An API key from [Anthropic](https://console.anthropic.com/),
  [OpenAI](https://platform.openai.com/), or
  [OpenRouter](https://openrouter.ai/)

!!! note
    The agent calls cloud LLM APIs for inference, so no GPU is required to run
    OpenClaw itself. However, GPU partitions are available if your agent needs
    to launch data-processing or analysis tasks that benefit from GPU
    acceleration.

## Step 1: Clone and Build the Container (~10 min)

Log in to a login node and clone the repository:

```bash
ssh <username>@orcd-login.mit.edu
git clone https://github.com/qsimeon/openclaw-engaging.git
cd openclaw-engaging
```

Load the Apptainer module and build the container image on a compute node:

```bash
module load apptainer/1.4.2
srun --mem=8G --time=01:00:00 --cpus-per-task=2 \
  apptainer build apptainer/openclaw.sif apptainer/openclaw.def
```

The build takes roughly 10 minutes. Verify it succeeded:

```bash
apptainer exec apptainer/openclaw.sif openclaw --version
```

!!! tip
    Add the upstream remote so you can pull future OpenClaw updates:

    ```bash
    git remote add upstream https://github.com/openclaw/openclaw.git
    ```

## Step 2: Run the Setup Wizard

The setup wizard walks you through configuring your LLM provider, API key,
model selection, optional channels (Telegram, Slack, Discord), and skills.
Run it on a compute node:

```bash
srun --pty --mem=8G --time=01:00:00 --cpus-per-task=2 ./apptainer/setup.sh
```

!!! note
    You may see skill install failures mentioning "brew not installed." These
    are non-fatal — Homebrew is not available on HPC nodes, but the core agent
    functionality works without these optional skills.

After setup completes, activate the `openclaw` shortcut:

```bash
source ~/.bashrc
openclaw --help
```

The `openclaw` command now works like a native command — you no longer need to
type `apptainer exec ...` for every operation.

## Step 3: Test the Agent

Send a quick test message to confirm everything is working:

```bash
openclaw agent --local --agent main -m "Hello from Engaging!"
```

You can also start an interactive session on a compute node:

```bash
srun --pty --mem=1G --time=02:00:00 bash
openclaw agent --local --agent main -m "Explore CSV files in ~/my-project/data/"
```

## Step 4: Launch the Web Dashboard

The web dashboard provides a browser-based chat interface for interacting with
your agent. Start it by submitting a SLURM batch job:

```bash
cd ~/openclaw-engaging
sbatch apptainer/slurm-gateway.sh
```

Check the job status and get the connection details:

```bash
squeue -u $USER
cat openclaw-gw-<jobid>.out
```

The output file contains an SSH tunnel command and a dashboard URL with an
authentication token. It will look something like:

```
SSH tunnel command:
  ssh -f -N -L 18790:<node>:18790 <username>@orcd-login.mit.edu

Dashboard URL:
  http://localhost:18790/?token=<your-token>
```

On your **local machine**, run the SSH tunnel command from the job output:

```bash
ssh -f -N -L 18790:<node>:18790 <username>@orcd-login.mit.edu
```

The `-f` flag sends the tunnel to the background so you can continue using
your terminal. Then open the dashboard URL in your browser.

![OpenClaw web dashboard showing a chat session with the agent](../images/openclaw/openclaw_dashboard_chat.png)

!!! tip
    If you get a "port already in use" error, kill the existing tunnel first:

    ```bash
    lsof -ti:18790 | xargs kill -9
    ```

    Then re-run the SSH tunnel command.

## Staying Updated

The gateway launcher automatically checks for upstream OpenClaw updates. When
updates are available, you will see a notice before the gateway starts.

To apply updates manually:

```bash
./apptainer/update.sh
```

This fetches the latest changes from upstream, merges them, and optionally
rebuilds the container. You can also check for updates without applying them:

```bash
./apptainer/update.sh --check
```

## Tips and Customization

### Accessing Research Data

By default, Apptainer
[binds your home directory](../software/apptainer.md#more-on-using-singularity)
into the container. If your data is stored elsewhere (e.g., scratch space or
shared lab storage), bind additional paths in `apptainer/slurm-gateway.sh` using
the `-B` flag:

```bash
apptainer exec -B /path/to/data apptainer/openclaw.sif openclaw gateway ...
```

### GPU Access

To give your agent access to a GPU for data-processing tasks, edit
`apptainer/slurm-gateway.sh` and add GPU resource requests:

```bash
#SBATCH -p mit_normal_gpu
#SBATCH -G l40s:1
```

See [Requesting Resources](../running-jobs/requesting-resources.md#gpus) for
available GPU types and partitions.

### Changing the Model

You do not need to re-run the full setup wizard to switch models. Use the
config command:

```bash
openclaw config set agent.model "anthropic/claude-opus-4-6"
```

!!! warning "API Usage Limits"
    Autonomous agents can generate high API usage in a short period of time.
    Some LLM providers have been known to suspend accounts that exceed
    undocumented usage thresholds. Monitor your usage on your provider's
    dashboard and consider setting spending limits or rate caps to avoid
    unexpected charges or account restrictions.

### Session Persistence

All conversation history, agent configuration, and workspace state is stored in
the `~/.openclaw/` directory. By default this is in your home directory, but
the `.openclaw/` directory can grow large over time. We recommend moving it to
scratch space to avoid filling your home directory quota:

```bash
# Move existing state to scratch (one-time setup)
mv ~/.openclaw /pool001/$USER/openclaw-state
ln -s /pool001/$USER/openclaw-state ~/.openclaw
```

!!! tip
    Replace `/pool001/$USER` with the appropriate scratch path for your group.
    See [Storage and Filesystems](../filesystems-file-transfer/filesystems.md)
    for available options.

With a persistent state directory in place:

- Sessions survive SLURM job preemptions — just resubmit the gateway job and
  reconnect.
- You can switch between compute nodes freely.
- Your agent remembers previous conversations.

### Sandboxing

OpenClaw has two layers of sandboxing you should be aware of:

1. **OpenClaw's internal sandbox** restricts what the agent can do inside the
   container (file access, shell commands). Keep this **enabled** (the default).
2. **Apptainer isolation** controls what the container can see on the host.
   Using `--containall` prevents the container from automatically mounting
   your entire home directory, limiting exposure to only the paths you
   explicitly bind.

For tighter isolation, launch the gateway with `--containall` and explicit
bind mounts instead of relying on Apptainer's default home-directory mount:

```bash
apptainer run \
  --containall \
  --home /pool001/$USER/openclaw-state \
  --bind /path/to/project:/workspace \
  apptainer/openclaw.sif gateway run
```

!!! warning
    We strongly recommend keeping OpenClaw's internal sandboxing enabled.
    Disabling it gives the agent your full user permissions on the cluster,
    allowing it to read, modify, or delete any files you have access to.
    Combine the internal sandbox with `--containall` and minimal bind mounts
    for the best security posture.

## HPC vs. Cloud Differences

!!! info
    If you have used OpenClaw on
    [DigitalOcean](https://marketplace.digitalocean.com/apps/openclaw), here are
    the key differences on Engaging:

    - **No always-on gateway**: SLURM jobs have wall-time limits. When the job
      ends, resubmit with `sbatch apptainer/slurm-gateway.sh`. Your sessions
      persist automatically.
    - **SSH tunnel required**: Engaging compute nodes are not directly reachable
      from the internet. The SSH tunnel through a login node provides secure
      access to the dashboard.
    - **No systemd**: There is no service manager on compute nodes. The gateway
      runs as a foreground process inside the SLURM job.

    These are fundamental HPC constraints, not Apptainer limitations. The
    `openclaw` shortcut and persistent state directory keep the experience
    close to the cloud deployment.
