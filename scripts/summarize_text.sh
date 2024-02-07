#!/bin/sh

if ! [ -x "$(command -v ollama)" ]; then
  echo 'Error: ollama is not installed.' >&2
  zenity --error \
          --text="Error: ollama is not installed."
  exit 1
fi


FILE_DIR=$(dirname "$1")
FILE_BIT=$(basename "$1")

FILE_NME=${FILE_BIT%%.*}
FILE_EXT=${FILE_BIT##*.}


if [ "$FILE_EXT" = "txt" ] || [ "$FILE_EXT" = "log" ]; then
    (
    echo "50"
    "${HOME}/.local/share/powertoys/summarize_text.py" --model=mistral:latest --text="${1}" --words=2000 --prompt="summarize this text"
    echo "100";

    ) |
    zenity --progress \
    --title="Text summary" \
    --text="Summarizing text with mistral in ollama ..." \
    --percentage=25 \
    --width=500 \
    --timeout=180
else
    zenity --error \
          --text="Error: Supplied file is not a .txt or .log"
fi

zenity --text-info --title="Summary of text" --filename="${1}_summary.txt"

