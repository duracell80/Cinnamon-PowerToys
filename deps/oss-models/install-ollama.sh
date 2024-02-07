#!/bin/bash

CWD=$(pwd)

#curl https://ollama.ai/install.sh | sh

read -p "Do you wish to install LLaVA (4GB image description model)? (yes/no) " yn

case $yn in
	yes ) ollama pull llava;;
	no ) echo "[i] Skipping LLaVA";;
esac

read -p "Do you wish to install Mixtral (26GB large language model)? (yes/no) " yn

case $yn in
        yes ) ollama pull mixtral;;
        no ) echo "[i] Skipping Mixtral";;
esac

read -p "Do you wish to install Mistral (4GB large language model)? (yes/no) " yn

case $yn in
        yes ) ollama pull mistral;;
        no ) echo "[i] Skipping Mistral";;
esac

read -p "Do you wish to install Mistral Lite (4GB large language model)? (yes/no) " yn

case $yn in
        yes ) ollama pull mistrallite;;
        no ) echo "[i] Skipping Mistral Lite";;
esac

read -p "Do you wish to install Phi (1.6GB image description model)? (yes/no) " yn

case $yn in
        yes ) ollama pull phi;;
        no ) echo "[i] Skipping Phi";;
esac

read -p "Do you wish to install Llama2 (4GB large language model)? (yes/no) " yn

case $yn in
        yes ) ollama pull llama2;;
        no ) echo "[i] Skipping LLama2";;
esac

cp -f "${CWD}/../../nemo/actions/pt-summarize-text.nemo_action" "${HOME}/.local/share/nemo/actions"
cp -f "${CWD}/../../scripts/summarize_text.py" "${HOME}/.local/share/powertoys"
cp -f "${CWD}/../../scripts/summarize_text.sh" "${HOME}/.local/share/powertoys"
