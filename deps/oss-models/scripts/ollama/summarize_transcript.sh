#!/usr/bin/bash

#ollama pull llama3

./ollama_summary.py --model=llama3 --file="${1}" --prompt="Please give a detailed summary of the text, giving a section of bullet points as a key takeaways section at the end of the summary. Attempt to list who was speaking in the transcript and note if there are any items to follow up on or research further. Provide output in markdown format if possible" --context="transcription"
