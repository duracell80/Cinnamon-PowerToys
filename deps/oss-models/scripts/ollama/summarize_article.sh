#!/usr/bin/bash

#ollama pull llama3

$HOME/.local/share/oss-models/ollama/ollama_summary.py --model=llama3 --file="${1}" --prompt="Please give a detailed summary of this, giving a section of five bullet points as a key takeaways section at the end of the summary. Give me five keywords found in the article and present these preceeding with a hashtag for each." --context="article"
