#!/bin/bash

t=100

for i in $(seq 1 $t);
do
	echo "[i] Generation ${i} of ${t}"
	./main.py --steps=5 --guidance=3.5 --rewrite="lock" --angle="ultra-wide" --style="photorealistic"
done
