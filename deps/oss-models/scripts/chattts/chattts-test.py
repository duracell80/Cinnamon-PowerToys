#!../bin/python3

import ChatTTS
import torch
import torchaudio
import os

dir_home = os.path.expanduser("~/")
try:
	os.mkdir(f"{dir_home}Audio/TTS")
except:
	print("[i] TTS Output directory exists")

chat = ChatTTS.Chat()
chat.load(compile=False) # Set to True for better performance

rand_spk = "蘁淰敹欀椄嬈縅楅薇謫竤勦崏枻广僟哱猛蛹墴祚枿澬璒箔嗢瞑猒慿眐粴疪平瓧叿槱搄栳墣攞服揿廁敊棑懁桉爸罇嬿埙諃祅睴噡緊妕廈觀眴嗟彦旀仦谟缟畑奄衁捷拚竓胛埛磕禠恒琸疖肾冢琾覿啚凫譳什覷恡咂葉獣愳窋撐啴咚蔁怎佃塻溇啴狾瞃痧綜呈厜烵甍賂笤谵毛懸唘瞕栜藺硴桵楡寔择渝貑苆綠勪猌槵旕芇峚摇吻味蓳稹嵠瞽榑簛礒諑砀爔瞺礛境啟崈摙賤評亜覨睋剈哘糼瀜蜩寝嘵偀赶槤贑褶侚澖湜请擀冫诀穮盹圽岷幉蜋蚣卐裶绩奅右粣晁奨檆弮扳祿朑嗏跍篓蚵爻兺疴歬膒澇唍峵桉婃溫芓熰燞繰嗀溨裿毀奲胃槢倅糌懭仛硔粴芎乂庈犁皙諫呙茠溏蔤矑欍砟蠗奲泯俐老曭罄舥誧炮妑毢觥罎毬矗畝籛乓茦嵡粥晪窴詓祯后殑蕤旀凣簹虾癅覉來节懽嫉烥痆臎菲诤泊毽缨憶稬汮熏澧曷叿戩狘莐朩耔殥跒墔庅芠爎毇智蓓疻伥咸瞛耲蝍佊現慒三桊嫿洨谺廗灾朵烅挄好扛兡稟焭嵏孢嵙栣痦响葅羂蝣蕇犷茞詋襲請崦瞪诛犽繀臫熧佃神硝祩猹癰峢挤璵垭尬怴葘此喝丣荼仑歁贛瘖抲儉乼呑塹夁拡疵徆咏嬷氺觘杲尗畽藠袧岙觥緣嵡託甪濊晌巬潔護暨晡敹氝掓葍瘑絒爛喏兇幥篐侈芚扣桎桐栒袉渑佩薗棋恚呮擽洆畞襯瑋覇漰寶疯蒅謋絭盢掫螞佄艡剘莤哴媔硊絵哸嘨漵耷磠洩负覩傟豬竰俤悃謙攠唄姜內繭搷膎滙允峉裚寈娒扳寧垂舄乸瀭糩虺盔蜮楝宺蓱匮翀薚賥憳巈操丏蜤浪裋笹洭贷甸橅蠙痚豲槤滪矅蛵蔾擓崖灌秺斧岔沒貆奝勉梛纇撧慒穯杋劒倏禼萰汍蟠趺瑠詏諓屖薮汉坮暂矜蛩浀圥澠彟簠滼腐琦珣兗摰扮攆磤箶呗荲斮巎燸濌觽譄斝哩硍橰矙穑睰殡昗卹肹圶庆値浖乃泚薏訲資奉扳箎嚇竟喢诣莊畃虶乴橏嗭祋渊襒俺訢嵡女倸湂厛撒蔎繣勞峃袖爳襎衤篙湴儽苵歔趵佴勶暍篁壵盌往秌穙蠝儸獝璻簷臍王胀牋嶃貔褱淨瑾尐僥赶臲珈货澲碢繧擙宧撊硇蓋脻荌蝸欜茯花砩請亃稰耫睮燎祣蚻灕稥砼胖衳觧跊相朔猩恐快豩腈媜菾浂痙疹炥槦瑺穯冝嗿财襛蘉章攸瘓喽污焙尴汆漎楹蟈罌瑄卙幻垅埧彼副怊析浌疗峛弟溡蜤翮祥澙椘嗎怍炯峖傑办蔏牶琳緦叚艛腓廯桛为蛼議玪皷洫溅梊唱嘫瞱叐劮同枺蠆劸胶藺礙仢赘乴挝剞瀆絠舜漺檂琨嬫樢蜈巬妈諚纨智晓蟆眊愼碝喑創訜椐筜摺照孝澤枙攨盆愓岀塲侨塷檙役獼梷乕肤弼晚肼廦竭桊渲夐湣囇蒶紻碮动璹愹偭埞娦綴榆灨誤喋匓氚趇慈搘票濛憨嵑沘温瘀㴅"
#rand_spk = chat.sample_random_speaker()
#print(rand_spk) # save it for later timbre recovery

texts = ["The day has been filled with dogs standing outside polling stations, as their owners head into voting booths to cast their ballots.", "Download Free Open Source RVC Models for Voice Conversion with Examples for Music Generation and Speech Replacement."]

params_infer_code = ChatTTS.Chat.InferCodeParams(
	spk_emb = rand_spk, # add sampled speaker
	temperature = .3,   # 0.3 using custom temperature
	top_P = 0.7,        # 0.7 top P decode
	top_K = 20,         # 20 top K decode
)

params_refine_text = ChatTTS.Chat.RefineTextParams(
	prompt='[oral_2][laugh_0][break_4]',
)

wavs = chat.infer(
	texts,
	params_refine_text=params_refine_text,
	params_infer_code=params_infer_code,
)

wavs = chat.infer(texts[1],skip_refine_text=False,params_refine_text=params_refine_text,params_infer_code=params_infer_code)
torchaudio.save(f"{dir_home}Audio/TTS/chattts_test.wav", torch.from_numpy(wavs[0]).unsqueeze(0), 24000)
