#!../bin/python3

import sqlite3, uuid, base64, time, os, sys
from PIL import Image


conn = sqlite3.connect("data.db")


def img2bin(filename):
	png_img = Image.open(filename)
	jpg_img = png_img.convert("RGB")

	half = 0.5
	out_img = jpg_img.resize( [int(half * s) for s in png_img.size] )

	out_img.save("images/store.jpg")

	with open("images/store.jpg", 'rb') as file:
		blobData = file.read()

	with open("images/store.blob", "wb") as bfile:
		bfile.write(base64.b64encode(blobData))

	os.remove("images/store.jpg")

	return blobData






def bin2img(filename, ext = "jpg"):
	with open(filename, 'rb') as bfile:
		image_blob = base64.b64decode(bfile.read())

	with open(filename.split(".")[0] + "." + ext, "wb") as ifile:
		ifile.write(image_blob)




def dbi2img(conn, fetchid, ext = "jpg"):
	cur = conn.cursor()
	if isinstance(fetchid, int):
		sql = f"SELECT image_thumbnail, timestamp, seed, steps, prompt, prompt_modified FROM generations WHERE timestamp = '{fetchid}'"
	else:
		sql = f"SELECT image_thumbnail, timestamp, seed, steps, prompt, prompt_modified FROM generations WHERE uuid = '{fetchid}'"

	cur.execute(sql)
	res = cur.fetchone()

	#image_blob = base64.b64decode(res[1])
	image_blob = res[0]

	with open(f"images/fluxthumb-{res[1]}__se{res[2]}-st{res[3]}.jpg", "wb") as ifile:
		ifile.write(image_blob)

#dbi2img(conn, "83399da9-9306-45a4-bffd-599900bb3d8d")
#dbi2img(conn, 1723317057)


#sys.exit()


def add_table():
	try:
		curr = conn.cursor()
		curr.execute(""" CREATE TABLE generations (
			uuid TEXT,
			timestamp INTEGER, timetogen FLOAT, modelvar TEXT, chip TEXT, offload TEXT, gpuinfo TEXT, seed INTEGER, steps INTEGER,
			height INTEGER, width INTEGER, style TEXT, angle TEXT, prompt TEXT, prompt_rewriter TEXT, prompt_modifier TEXT,
			prompt_modified TEXT, prompt_sequence INTEGER, prompt_guidance FLOAT, prompt_negative TEXT, image_thumbnail BLOB)""")

		conn.commit()

	except:
		return

# timestamp:{timestamp};seed:{seed};style:{style};keywords:{keywords};description:{description}
def add_table_desc():
	try:
		curr = conn.cursor()
		curr.execute(""" CREATE TABLE descriptions (
			uuid TEXT,
			timestamp INTEGER, seed INTEGER, style TEXT, prompt TEXT, keywords TEXT, description TEXT, words TEXT, rating INTEGER)""")

		conn.commit()

	except:
		return


def add_generation(conn, values):

	sql = ''' INSERT INTO generations (uuid, timestamp, timetogen, modelvar, chip, offload, gpuinfo, seed, steps, height, width, style, angle, prompt, prompt_rewriter, prompt_modifier, prompt_modified, prompt_sequence, prompt_guidance, prompt_negative, image_thumbnail)
		VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) '''

	curr = conn.cursor()
	curr.execute(sql, values)
	conn.commit()

	print(f"[i] SQLITE3 INSERT: Created a generation record")

# timestamp:{timestamp};seed:{seed};style:{style};keywords:{keywords};description:{description}
def add_description(conn, values):

	sql = ''' INSERT INTO descriptions (uuid, timestamp, seed, prompt, style, keywords, description, words, rating)
		VALUES(?,?,?,?,?,?,?,?,?) '''

	curr = conn.cursor()
	curr.execute(sql, values)
	conn.commit()

	print(f"[i] SQLITE3 INSERT: Created a description record")


#add_table()
add_table_desc()


generations = [
	(str(uuid.uuid4()), "1723317057", 136, "schnell", "cpu", "sequential", "nvidia-rtx-3050-6gb", 463672, 5, 1080, 1920, "photorealistic", "wide", "Create A futuristic space station floating above the planet's surface", "llama3", "Introduce photorealistic elements and lifelike objects that would naturally fit into the scene. The camera angle is a ultra-wide shot showing the background unblurred", "Cosmic Gateway: Envision a sleek, spherical space station suspended 10,000 meters above the rust-red terrain of a distant planet. Incorporate photorealistic details like solar panels, airlocks, and communication arrays. Capture the breathtaking vista with an ultra-wide shot, showcasing the unfurled vastness of the alien landscape below.", 256, 0.5, "No negative prompt", img2bin("images/demo.png")),
]

descriptions = [
        (str(uuid.uuid4()), "1723317057", 463672, "illustration", "Create a futuristic space station floating above the planet mars", "space,space station,planet,mars,illustration", "A space station floating above the planet mars", "NASA, USA", 5)
]


#for generation in generations:
#	add_generation(conn, generation)

for description in descriptions:
       add_description(conn, description)

conn.close()
