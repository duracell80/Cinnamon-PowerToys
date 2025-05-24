#!../bin/python3
import argparse
import ollama
import base64
import sqlite3
import uuid, json, os, sys, io

from PIL import Image
from PIL import ExifTags
from exif import Image as ExifImage

conn = sqlite3.connect("data.db")

def select_generations(conn):

	curr = conn.cursor()
	curr.execute('''SELECT timestamp, seed, prompt, image_thumbnail FROM generations''')
	rows = curr.fetchall()

	return rows



def image_to_base64(image_path):
	print(f"[i] Describing ... {image_path}")
	try:
		with open(f"{image_path}", "rb") as image_file:
			encoded_string = base64.b64encode(image_file.read()).decode("utf-8")
		return encoded_string
	except FileNotFoundError:
		print(f"Error: File not found: {image_path}")
		return None
	except Exception as e:
		print(f"An error occurred: {e}")
		return None


def insert_description(conn, timestamp, seed, style, prompt, keywords, description, words, rating):

	values = (str(uuid.uuid4()), int(timestamp), int(seed), str(style), str(prompt), str(keywords), str(description), str(words), int(rating))

	sql = ''' INSERT INTO descriptions (uuid, timestamp, seed, style, prompt, keywords, description, words, rating)
		VALUES(?,?,?,?,?,?,?,?,?)'''

	curr = conn.cursor()
	curr.execute(sql, values)

	conn.commit()

	print(f"\n\n[i] DB UPDATE: Updated a generation record\n\n")


def parse_command_line_args():
	parser = argparse.ArgumentParser(description='')
	parser.add_argument('-f', '--file', help='Input file path', required=False)
	parser.add_argument('-m', '--model', help='Image classification model', required=False, default="llava")
	args = parser.parse_args()

	return args


args = parse_command_line_args()

generations = select_generations(conn)

client = ollama.Client(host='http://127.0.0.1:11434')

for gen in generations:
	ts = gen[0]
	se = gen[1]
	pr = gen[2]

	curc = conn.cursor()
	curc.execute(f'SELECT timestamp, seed FROM descriptions WHERE timestamp = {ts} AND seed = {se} LIMIT 1')
	row = curc.fetchall()


	if int(len(row)) == 1:
		print(f"[i] Description already exists in DB for: {ts}_{se}.jpg")
	else:
		image_stream = io.BytesIO(gen[3])
		image = Image.open(image_stream)
		image.save(f"/tmp/flux-{ts}_{se}.jpg")
		image_base64 = image_to_base64(f"/tmp/flux-{ts}_{se}.jpg")

		prompt = f'Describe this image, produce 5 keywords from that description, say what words are present in the image, place into the words field and say what the style of image is. For example the image maybe in a cartoon style, painting style or be a photorealistic styled image, return the result in JSON format including the description field, the words field, the style field that contains the style of image and the keywords field. Available styles to choose from are: cartoon, painting, photo, illustration. Only output JSON in your response.'

		response = ollama.generate(model=f"{args.model}", prompt = prompt, images = [f"{image_base64}"])
		actual_response = response['response']
		print(actual_response)

		json_response = actual_response.replace(" ```json", "").replace("```", "")

		try:
			file_bits = args.file.split("-")
			meta_bits = file_bits[1].split("__")
		except:
			print(f"[i] Continue in DB Loop Mode")

		meta_words = "none"
		meta_rating = 5

		try:
			data = json.loads(json_response)
			meta_keys = ""

			try:
				for key_item in data["keywords"]:
					meta_keys += f"{key_item},"
			except:
				meta_keys = "none"

			meta_words = ""

			try:
				for word_item in data["words"]:
					meta_words += f"{word_item},"
			except:
				meta_words = "none"

			insert_description(conn, int(ts), int(se), str(data["style"]).lower(), str(pr), str(meta_keys[:-1]), str(data["description"].replace("'", "").replace("\"", "").replace("-", " ")), str(meta_words[:-1]),int(meta_rating))
		except:
			print(f"[i] Error encountered when describing file: /tmp/flux-{ts}_{se}.jpg")

conn.close()
