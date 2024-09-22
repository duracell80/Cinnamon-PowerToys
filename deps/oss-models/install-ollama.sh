#!/bin/bash

CWD=$(pwd)

mkdir -p "${HOME}/.local/share/oss-models/ollama"
cp -f "${CWD}/scripts/ollama/ollama_summary.py" "${HOME}/.local/share/oss-models/ollama/"
cp -f "${CWD}/scripts/ollama/summarize_article.sh" "${HOME}/.local/bin/summarize_article"
cp -f "${CWD}/scripts/ollama/summarize_transcript.sh" "${HOME}/.local/bin/summarize_transcript"


curl https://ollama.ai/install.sh | sh

read -p "Do you wish to install LLaVA (4GB image description model)? (yes/no) " yn

case $yn in
	yes ) ollama pull llava;;
	no ) echo "[i] Skipping LLaVA";;
esac

read -p "Do you wish to install Mixtral (26GB large language model)? (yes/no) " yn

case $yn in
        yes ) ollama pull mixtral;;
        no ) ollama rm mixtral && echo "[i] Skipping Mixtral";;
esac

read -p "Do you wish to install Mistral (4GB large language model)? (yes/no) " yn

case $yn in
        yes ) ollama pull mistral;;
        no ) ollama rm mistral && echo "[i] Skipping Mistral";;
esac

read -p "Do you wish to install Mistral Lite (4GB large language model)? (yes/no) " yn

case $yn in
        yes ) ollama pull mistrallite;;
        no ) ollama rm mistrallite && echo "[i] Skipping Mistral Lite";;
esac

read -p "Do you wish to install Phi (1.6GB small language model)? (yes/no) " yn

case $yn in
        yes ) ollama pull phi;;
        no ) ollama rm phi && echo "[i] Skipping Phi";;
esac

#read -p "Do you wish to install Llama3 (4GB large language model)? (yes/no) " yn

#case $yn in
#        yes ) ollama pull llama3;;
#        no ) ollama rm llama3 && echo "[i] Skipping LLama3";;
#esac

echo -e "\n\n[i] Pulling Llama3 as is used currently by many scripts ..."

ollama pull llama3

cp -f "${CWD}/../../nemo/actions/pt-summarize-text.nemo_action" "${HOME}/.local/share/nemo/actions"
cp -f "${CWD}/../../scripts/summarize_text.py" "${HOME}/.local/share/powertoys"
cp -f "${CWD}/../../scripts/summarize_text.sh" "${HOME}/.local/share/powertoys"
