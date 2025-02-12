---
tags:
 - LLM
 - GPU
 - Howto Recipes
 - Engaging
---

# Running Your Own Retrieval-Augmented Generation (RAG) Model

RAG models harness the power of Large Language Models (LLMs) to query and
summarize a set of documents. Through RAG, one can combine the strengths of
retrieval-based and generative models to provide more accurate and contextually
relevant responses.

RAG also provides an interesting test case to make use of our resources on the
cluster. Here, we provide instructions on how to run a RAG model on our
documentation.

The code for developing this model can be found in this
[GitHub repository](https://github.com/mit-orcd/orcd-rag). Feel free to use
this repository as a guide to develop your own RAG model on a separate set of
documentation.

## Getting Started

### Working on a Compute Node

We require that you run this model on a compute node. You can request an
interactive session on a compute node with the following command:

```bash
salloc -N 1 -n 4 -p mit_normal
```

However, this work much more quickly with a GPU. If you have access to a
partition on Engaging with a GPU, then specify your partition:

```bash
salloc -N 1 -n 4 -p mit_normal_gpu --gres=gpu:l40s:1
```

I have specified an L40S GPU, which has 48GB of memory. You will need a GPU with
at least 40GB of memory for this model to work.

### Getting Access to HuggingFace

The LLMs used in this pipeline are from HuggingFace. By default, we use Llama
3.1, which is gated and requires users to request access. You can follow this
process for doing so:

1. [Create a HuggingFace account](https://huggingface.co/)
2. Request access to [meta-llama/Llama-3.1-8B-Instruct](https://huggingface.co/meta-llama/Llama-3.1-8B-Instruct)
3. Create a [user access token](https://huggingface.co/settings/tokens)
4. Save your user access token as an environment variable on Engaging:

```bash
export HF_TOKEN="your_user_access_token"
```

## Running the Model

### Running on a Container

You can run the RAG model on our documentation using the Apptainer image we have
saved to Engaging:

```bash
module load apptainer
apptainer exec --nv \
               --env HF_TOKEN=$HF_TOKEN \
               --bind $HF_HOME:/tmp/.cache/huggingface \
               /bin/bash -c 'export HF_HOME=/tmp/.cache/huggingface && python /tmp/rag.py'
```

The container runs out of the box, but we provide the option to select different
models or vectorstores. 

### Running via a Python Environment

The steps for running this model via a Python environment can be found on the
[GitHub repository](https://github.com/mit-orcd/orcd-rag).

<!--
TODO:
- Check to see if running this on a CPU works, and how much memory is required
- Input steps on pre-downloading the model before running the container
    - Don't need to do this, just need to make sure HF_HOME is mounted
- Specify the path to the .sif image when it's globally saved
- Point container to global rag.py so that we can make edits?

Python script:
- Deal with the "Setting `pad_token_id` to `eos_token_id`:128009 for open-end generation." message
-->
