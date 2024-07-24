#!../bin/python3

import ChatTTS
import torch
import torchaudio

chat = ChatTTS.Chat()
chat.load(compile=False) # Set to True for better performance

#rand_spk = "蘁淰敵欀妋秌罃悅僱褖焭譚嫓棶旣賗噘枠诃洖瘼氡斏冾檤柙愴誔皩蘌討蕌瞸佣璌倐岹壖纕筩禊瞵纁睘尭柒绝橩獙蓧傎姑谒咽娶掎贙帆惀缘峣葃墣棌羅胓暗減暽囦滘杮歪恘僟水嶇菄忉赌濠劅掉宽潳琴誃塚會氋佘歿趥蒷搮瓟暺塌羵倈实庽瀁笨楇嬢謉態塧崟坘喹垧檢虈渮亵茅翪败蘥说屍蛣嘝婌礆聗杉擈胰困嵖裿倍腙獵羠槤悗睗諫謌汃氰槖泴茣孤裢獳汁碦萣恙墷氈樦彃蟮槷哈妖嗅罓埕砵稙蒽唐畊僕全缓蛌岀奾栩謹抮给歸牛唴产勑氋趶趲爱箘衎瞣绾础玣僢磚矧箥笛蔛忠谁跽賕搃筈琁胖犑谈刭璳洍悫脒帻腝秣机涩糖益喺澿汃噿蝜亲傛糪挙偩脛翐掎磂玞姺眥盲訡涬伈杤檣徯歨箖椚来怤庐恝豄伽攖殱疫劖淔乯暒塻漍喻埾癠蘈刔蠬缥紲讲贁尐嫑腣沮舍蟎灛堧怕嚓蝺礖乽贞刐竷泸覫斑甠荏洚渲昖硳稪菫緜濍泌臡嵗嫢趫蘃梁歟瘱詆莶瑀藿密働販惌眯灉熻橪砩箔楐聤濺諈坖弣删呢淕癇橼垩讳栠蕴掘娾媘痥眠怓聊耸亳帯忥峋匝舀識贠曗綍们腿剿氃責舏傈藫篤兦厎蒰纺挑谂芩婻徏烺尜砚睉悂参戒椇焯崍欬喷僅晦覀瑋蒑灋碶巗姺渙槩椌捿录覧咙脡蓻懦硘稢罉誈亼蓜谩胁呵缄堻忄語圃栂犵艗碚畫彴瘎啌淑憭赢诰稖茌昈切嚭杴噫褀洩谪澛勗煸乇嗻浵胓莡蘌皺巅蠽皾炡婭垎親硝擬煵凶菓卥櫸濘蒣弗讟修橎蕠琐貸詄椻夛嵤絳奲瘹氠壑暭粓皃堨繸藯埨蚁褴螉姠趸臼紲杽耞蛙緆蠮供歹芗亗尠弒礈殲嘢缇蕕猐毃梖搠傾设擑亘詐蟥嘙綁恗乣產蟖沨掣種筋猲倜琍絬正蝫幄楩盆瑐壶娪昑傌璆纏襇走粔爊柹给堊剳翟胸灔粍磃琚慻弞斧四痝琢烟洙枼屣蒦菬竛斖臇棈抨濗灇砿瀑犈渢觍熭楆窥丙欂琠線碉櫋曹硲哜砍旪棠昺睭薷窈憋淴柜慔戴永卹惢内臐焭潥筷祄桡膆偍凥帓矃菡潰毹皸昒捦擠壙訚泽説幆笩泴牀椺畉僱嵠蒻昍墻癔俥来蓊搸覹艀熯浹漻肉偯狝揀咟枢贉觅梵牵舡嫅俱殡蟍熾戜蝥襯猑蚗肴揨揦粊綆悂濾峫玤貆梋嘑諆予尡喁望嗣堫痉帵欒吭俪綿耱牀暟楨沨燝櫃筭贔愁涆籹硊蔰羀仂俬請拌呀厯剰梙凨哺摇敟此臎梿樳緗寗忱塔聢蛤摠哑簊寠仚絎憶抇跺没濧泒每旞礴瞂歲琖川幅璒夶艭濟拟殻蜒扳疗窘莙屆溞悟荜愆瑩忑毯瀋優裨瞸緖毶緘坌襒傇膬荏匢蟪喒縞姩戥埋墷摲竘仈悢蒲玲荠衑喸慌偧员莰潐儜指绔訷瘕懐揕蒨哃筛儑歳彘蟐犞跌蜑咻褐恤嚿慱算磉祬怕湑棏崛簰斛楹姣嶒糭哎賮珹蔔緜渞焜縀一㴄"
rand_spk = chat.sample_random_speaker()

print(rand_spk) # save it for later timbre recovery

texts = ["The day has been filled with dogs standing outside polling stations, as their owners head into voting booths to cast their ballots.", "Download Free Open Source RVC Models for Voice Conversion with Examples for Music Generation and Speech Replacement."]

params_infer_code = ChatTTS.Chat.InferCodeParams(
	spk_emb = rand_spk, # add sampled speaker
	temperature = .3,   # 0.3 using custom temperature
	top_P = 0.7,        # 0.7 top P decode
	top_K = 20,         # 20 top K decode
)


text = """
chat T T S is a text to speech model designed for dialogue applications.
[uv_break]it supports mixed language input [uv_break]and offers multi speaker
capabilities with precise control over prosodic elements like
[uv_break]laughter[uv_break][laugh], [uv_break]pauses, [uv_break]and intonation.
[uv_break]it delivers natural and expressive speech,[uv_break]so please
[uv_break] use the project responsibly at your own risk.[uv_break]
""".replace('\n', '')

###################################
# For sentence level manual control.

# use oral_(0-9), laugh_(0-2), break_(0-7)
# to generate special token in text to synthesize.
# defaults 2, 0, 4
params_refine_text = ChatTTS.Chat.RefineTextParams(
	prompt='[oral_2][laugh_0][break_4]',
)

wavs = chat.infer(
	texts,
	params_refine_text=params_refine_text,
	params_infer_code=params_infer_code,
)

###################################
# For word level manual control.

wavs = chat.infer(texts[1],skip_refine_text=False,params_refine_text=params_refine_text,params_infer_code=params_infer_code)
torchaudio.save("~/Audio/TTS/test.wav", torch.from_numpy(wavs[0]), 22000)
