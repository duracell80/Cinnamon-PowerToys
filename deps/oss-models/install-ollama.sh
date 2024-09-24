#!/bin/bash

CWD=$(pwd)

sudo apt install pipx
pipx install ollama --include-deps

mkdir -p "${HOME}/.local/share/oss-models/ollama"
cp -f "${CWD}/scripts/ollama/ollama_summary.py" "${HOME}/.local/share/oss-models/ollama/"
cp -f "${CWD}/scripts/ollama/summarize_article.sh" "${HOME}/.local/bin/summarize_article"
cp -f "${CWD}/scripts/ollama/summarize_transcript.sh" "${HOME}/.local/bin/summarize_transcript"


read -p "Do you wish to install Ollama? (yes/no) " yn

case $yn in
        yes ) curl https://ollama.ai/install.sh | sh;;
        no ) echo "[i] Skipping LLaVA";;
esac


read -p "Do you wish to install LLaVA (4GB image description model)? (yes/no) " yn

case $yn in
	yes ) ollama pull llava;;
	no ) echo "[i] Skipping LLaVA";;
esac

read -p "Do you wish to install LLaVA with Llama3 (4GB image description model)? (yes/no) " yn

case $yn in
        yes ) ollama pull llava-llama3;;
        no ) echo "[i] Skipping LLaVA";;
esac

read -p "Do you wish to install Bakllava (4GB image description model)? (yes/no) " yn

case $yn in
        yes ) ollama pull bakllava;;
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
ollama pull nomic-embed-text

echo -e "Now edit ollama service file to allow for cross origin so this pc can be used as an ollama server"
echo -e "Add this ... "
echo -e "[Service]"
echo -e 'Environment="OLLAMA_ORIGINS=*""'

sudo systemctl edit ollama.service

cp -f "${CWD}/../../nemo/actions/pt-summarize-text.nemo_action" "${HOME}/.local/share/nemo/actions"
cp -f "${CWD}/../../scripts/summarize_text.py" "${HOME}/.local/share/powertoys"
cp -f "${CWD}/../../scripts/summarize_text.sh" "${HOME}/.local/share/powertoys"
