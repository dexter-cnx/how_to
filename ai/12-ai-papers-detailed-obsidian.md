---
title: 12 AI Papers ที่เปลี่ยนโลก
tags:
  - ai
  - machine-learning
  - deep-learning
  - llm
  - rag
  - diffusion
  - obsidian
created: 2026-04-17
---

# 12 AI Papers ที่เปลี่ยนโลก

> โน้ตนี้สรุปและอธิบายเชิงลึกแบบอ่านแล้วเห็นทั้งภาพรวมของวงการ AI ตั้งแต่ยุค Deep Learning กลับมาเกิดใหม่ จนถึงยุค LLM, RAG, และ Diffusion

---

## ภาพรวมสั้นที่สุด

AI ที่เราใช้ทุกวันนี้ไม่ได้เกิดจาก paper เดียว แต่เป็นผลรวมของงานวิจัยหลายสาขาที่ค่อย ๆ ต่อกันเป็นชั้น ๆ ดังนี้

- **Perception** — ทำให้คอมพิวเตอร์มองเห็นและเข้าใจข้อมูล เช่น AlexNet, ViT, CLIP
- **Generation** — ทำให้ AI สร้างข้อมูลใหม่ได้ เช่น GANs, DDPM, Latent Diffusion
- **Language Intelligence** — ทำให้ AI เข้าใจและสร้างภาษาได้ดี เช่น Transformer, GPT-3, InstructGPT
- **Reasoning / Grounding** — ทำให้ตอบดีขึ้น คิดเป็นขั้นตอน และอ้างอิงความรู้จริง เช่น Chain-of-Thought, RAG
- **Scaling Principles** — ทำให้รู้ว่า “ยิ่งขยายอย่างถูกทาง ยิ่งเก่ง” เช่น Scaling Laws

---

## ภาพสรุปใหญ่

![[12-ai-papers-overview.png]]

> ภาพนี้ช่วยให้เห็นว่าทั้ง 12 งานวิจัยไม่ได้อยู่คนละโลก แต่เชื่อมกันเป็นระบบเดียว

---

# วิธีอ่านโน้ตนี้

แต่ละ paper จะอธิบาย 6 อย่าง:

1. **มันคืออะไร**
2. **แก้ปัญหาอะไรในยุคนั้น**
3. **แนวคิดหลัก**
4. **ผลกระทบต่อวงการ**
5. **ของที่เราใช้วันนี้ได้รับอิทธิพลอย่างไร**
6. **คำจำง่าย ๆ**

---

# Part 1 — จุดเริ่มต้นของยุคใหม่

## 1) AlexNet (2012)

**Paper:** *ImageNet Classification with Deep Convolutional Neural Networks*

### มันคืออะไร
AlexNet คือ paper ที่ทำให้โลกกลับมาสนใจ Deep Learning แบบจริงจังอีกครั้ง โดยใช้ **Convolutional Neural Networks (CNNs)** ชนะการแข่งขัน ImageNet แบบทิ้งห่างคู่แข่ง

### ก่อนหน้านั้นมีปัญหาอะไร
ก่อน AlexNet งานด้าน Computer Vision มักพึ่ง feature engineering แบบ manual เช่น SIFT, HOG หรือการออกแบบ feature ด้วยมือ นักวิจัยต้องเดาเองว่าภาพควรถูกแทนด้วยลักษณะอะไร

### แนวคิดหลัก
AlexNet ใช้ CNN ลึกหลายชั้น ให้โมเดลเรียนรู้ feature จากข้อมูลเอง ตั้งแต่ขอบ เส้น รูปร่าง ไปจนถึงวัตถุระดับสูง

องค์ประกอบสำคัญ:
- Convolution layers
- ReLU activation
- Dropout
- Data augmentation
- GPU training

### ทำไมมันสำคัญ
มันพิสูจน์ว่าเมื่อมี
- ข้อมูลขนาดใหญ่
- โมเดลลึกพอ
- พลังประมวลผลจาก GPU

ผลลัพธ์จะกระโดดขึ้นแบบมหาศาล

### ผลกระทบต่อโลกจริง
AlexNet จุดชนวนให้เกิดยุคใหม่ของ:
- image classification
- object detection
- face recognition
- medical imaging
- self-driving perception

### คำจำง่าย ๆ
> AlexNet = จุดที่โลกเชื่อว่า Deep Learning ใช้งานจริงได้

### ภาพจำ
```text
ภาพ → Conv → Conv → Conv → Fully Connected → Label
```

---

## 2) GANs (2014)

**Paper:** *Generative Adversarial Nets*

### มันคืออะไร
GAN คือกรอบการเรียนรู้ที่มีโมเดล 2 ตัวแข่งกัน:
- **Generator (G)** สร้างข้อมูลปลอม
- **Discriminator (D)** แยกว่าจริงหรือปลอม

### แก้ปัญหาอะไร
ก่อน GAN การสร้างภาพใหม่ให้ดูสมจริงยังยากมาก โมเดลสร้างข้อมูลมักได้ผลลัพธ์ที่เบลอหรือไม่คม

### แนวคิดหลัก
Generator พยายามหลอก Discriminator ส่วน Discriminator พยายามจับผิด Generator ทั้งสองฝ่ายเก่งขึ้นเรื่อย ๆ จน Generator สร้างข้อมูลที่ดูสมจริงมากขึ้น

### ทำไมมันสำคัญ
GAN ทำให้โลกเห็นชัดว่า AI ไม่ได้มีหน้าที่แค่ “จำแนก” แต่ยังสามารถ “สร้าง” ได้

### ผลกระทบต่อโลกจริง
- AI Art
- face generation
- image-to-image translation
- deepfake
- super resolution

### จุดแข็งและข้อจำกัด
จุดแข็ง:
- ภาพคม
- ผลลัพธ์ดูจริงมาก

ข้อจำกัด:
- train ยาก
- instability สูง
- mode collapse

### คำจำง่าย ๆ
> GAN = ศิลปินปลอม vs ตำรวจจับของปลอม

### ภาพจำ
```text
Noise → Generator → Fake Image → Discriminator
Real Image ───────────────────────→ Discriminator
```

---

## 3) Transformer (2017)

**Paper:** *Attention Is All You Need*

### มันคืออะไร
Transformer คือสถาปัตยกรรมที่เปลี่ยนวงการ NLP ทั้งหมด และต่อมากลายเป็นแกนของ LLM แทบทั้งหมด

### ก่อนหน้านั้นมีปัญหาอะไร
โมเดลลำดับแบบเดิม เช่น RNN/LSTM มีข้อจำกัดเรื่อง:
- จำบริบทยาว ๆ ได้ไม่ดี
- parallelization ยาก
- training ช้า

### แนวคิดหลัก
Transformer ใช้ **self-attention** ให้แต่ละ token มองความสัมพันธ์กับ token อื่นได้โดยตรง ไม่ต้องประมวลผลทีละคำแบบ RNN

แนวคิดสำคัญ:
- Query
- Key
- Value
- Multi-head attention
- Positional encoding

### ทำไมมันสำคัญ
Transformer ทำให้โมเดล:
- เข้าใจ context ได้ลึกขึ้น
- train แบบขนานได้ดีขึ้น
- scale ไปสู่โมเดลใหญ่มหาศาลได้

### ผลกระทบต่อโลกจริง
เกือบทุกอย่างในยุค GenAI พึ่งแนวคิดนี้ เช่น:
- GPT
- BERT
- T5
- Llama
- Claude
- multimodal transformers

### คำจำง่าย ๆ
> Transformer = โมเดลที่ “มองทั้งประโยคพร้อมกัน” และรู้ว่าอะไรควรสนใจ

### ภาพจำ
```text
Token A/B/C → Self-Attention → Contextual Representation
```

---

# Part 2 — ยุคที่ภาษาเริ่มฉลาดขึ้นจริง

## 4) GPT-3 (2020)

**Paper:** *Language Models are Few-Shot Learners*

### มันคืออะไร
GPT-3 คือการพิสูจน์ว่าถ้าขยาย language model ให้ใหญ่มากพอ ความสามารถจะโผล่ออกมาเอง เช่น few-shot learning, instruction-like behavior, text generation ที่ลื่นไหลขึ้นมาก

### จุดเด่น
- 175B parameters
- few-shot / zero-shot ability
- เขียนข้อความได้ใกล้เคียงมนุษย์มากขึ้น

### ทำไมมันสำคัญ
GPT-3 เปลี่ยนมุมมองของโลกธุรกิจจาก
- “AI เป็นของแล็บวิจัย”
ไปเป็น
- “AI เป็น platform และ product ได้”

### ผลกระทบต่อโลกจริง
- copywriting tools
- code generation
- summarization
- chat assistant
- workflow automation

### ข้อสังเกตสำคัญ
GPT-3 ยังไม่ใช่ chatbot ที่เชื่อฟังเก่งเท่า ChatGPT ยุคหลัง แต่เป็นหลักฐานชัดว่า **scale อย่างเดียวก็ปลดล็อกความสามารถใหม่ ๆ ได้**

### คำจำง่าย ๆ
> GPT-3 = จุดที่คนเริ่มรู้สึกว่า AI “คุยรู้เรื่องแล้ว”

---

## 5) InstructGPT (2022)

**Paper:** *Training language models to follow instructions with human feedback*

### มันคืออะไร
InstructGPT คือแนวคิดที่พา LLM จาก “เก่งภาษา” ไปสู่ “ใช้งานได้จริง” โดยทำให้มันตอบตามความตั้งใจของมนุษย์มากขึ้น

### ปัญหาที่ GPT ดิบ ๆ ยังมี
แม้โมเดลใหญ่จะเก่ง แต่ยังมีปัญหา เช่น:
- ตอบไม่ตรงคำสั่ง
- verbose เกิน
- unsafe บางกรณี
- ไม่ align กับสิ่งที่ผู้ใช้ต้องการจริง

### แนวคิดหลัก
กระบวนการสำคัญคือ:
1. **SFT** — supervised fine-tuning จากตัวอย่างคำตอบที่ดี
2. **Reward Model** — ฝึกโมเดลให้ประเมินว่าคำตอบไหนดีกว่า
3. **RLHF / PPO** — ปรับพฤติกรรมโมเดลด้วย feedback ของมนุษย์

### ทำไมมันสำคัญ
InstructGPT คือสะพานจาก
- language model
ไปสู่
- assistant model

### ผลกระทบต่อโลกจริง
แนวคิดนี้กลายเป็นพื้นฐานของ chatbot assistant จำนวนมาก

### คำจำง่าย ๆ
> InstructGPT = เปลี่ยน AI จาก “พูดเก่ง” ให้เป็น “ฟังคำสั่งเป็น”

### ภาพจำ
```text
Base LLM → SFT → Reward Model → PPO/RLHF → Helpful Assistant
```

---

## 6) Scaling Laws (2020)

**Paper:** *Scaling Laws for Neural Language Models*

### มันคืออะไร
Scaling Laws ไม่ใช่ paper ที่ออกโมเดลใหม่ แต่เป็น paper ที่บอกว่า performance ของโมเดลสัมพันธ์กับ:
- model size
- data size
- compute

อย่างเป็นระบบ

### แนวคิดหลัก
เมื่อเพิ่มทรัพยากรอย่างเหมาะสม loss จะลดลงตามรูปแบบที่คาดการณ์ได้ ไม่ได้สุ่มดีขึ้นแบบมั่ว ๆ

### ทำไมมันสำคัญ
มันทำให้บริษัทใหญ่รู้ว่า:
- ควรลงทุน compute แค่ไหน
- ควรเก็บ data เพิ่มเท่าไร
- ควร scale model ไปทางไหน

### ผลกระทบต่อโลกจริง
การแข่งขันในวงการ AI กลายเป็นการแข่งขันด้าน:
- data pipeline
- compute infrastructure
- optimization efficiency

### คำจำง่าย ๆ
> Scaling Laws = สูตรบอกว่า “ถ้าโตอย่างถูกทาง ความเก่งจะตามมา”

### ภาพจำ
```text
Params ↑ + Data ↑ + Compute ↑ → Loss ↓ → Capability ↑
```

---

# Part 3 — Computer Vision และ Multimodal ยุคใหม่

## 7) ViT (2020)

**Paper:** *An Image is Worth 16x16 Words: Transformers for Image Recognition at Scale*

### มันคืออะไร
ViT หรือ Vision Transformer คือการเอา mindset ของ Transformer จากภาษา มาใช้กับภาพ

### แนวคิดหลัก
แทนที่จะใช้ convolution แบบ CNN อย่างเดียว ViT จะ:
- ตัดภาพเป็น patch
- แปลงแต่ละ patch เป็น token
- ส่งเข้า Transformer

### ทำไมมันสำคัญ
มันทำให้คนเห็นว่า “ภาพก็ tokenized ได้เหมือนภาษา” และเปิดประตูสู่โลก multimodal

### ผลกระทบต่อโลกจริง
- modern vision backbone
- image classification
- segmentation
- multimodal models
- foundation models for vision

### คำจำง่าย ๆ
> ViT = เอาภาพมาปฏิบัติเหมือนประโยค

### ภาพจำ
```text
Image → Patches → Tokens → Transformer → Prediction
```

---

## 8) CLIP (2021)

**Paper:** *Learning Transferable Visual Models From Natural Language Supervision*

### มันคืออะไร
CLIP ฝึกให้โมเดลเข้าใจความสัมพันธ์ระหว่างภาพกับข้อความ โดยเรียนจากคู่ image-text จำนวนมหาศาล

### แนวคิดหลัก
มี encoder สองฝั่ง:
- image encoder
- text encoder

และฝึกให้ representation ของภาพและข้อความที่ตรงกันอยู่ใกล้กันใน embedding space

### ทำไมมันสำคัญ
CLIP ทำให้ AI ไม่ได้แค่ “เห็นภาพ” แต่เริ่ม “เข้าใจว่าภาพนั้นสัมพันธ์กับคำบรรยายอะไร”

### ผลกระทบต่อโลกจริง
- zero-shot classification
- image search
- prompt-based image understanding
- text-to-image guidance
- multimodal reasoning

### คำจำง่าย ๆ
> CLIP = ทำให้ภาพกับภาษาเริ่มคุยกันรู้เรื่อง

### ภาพจำ
```text
Image Encoder ↔ Shared Embedding Space ↔ Text Encoder
```

---

# Part 4 — ยุคของการสร้างภาพด้วย Diffusion

## 9) DDPM (2020)

**Paper:** *Denoising Diffusion Probabilistic Models*

### มันคืออะไร
DDPM คือแนวคิดสร้างข้อมูลด้วยการเริ่มจาก noise แล้วค่อย ๆ denoise กลับมาเป็นภาพ

### แนวคิดหลัก
มี 2 กระบวนการ:
- **Forward process**: เติม noise เข้าไปทีละน้อย
- **Reverse process**: ฝึกโมเดลให้ดึงภาพกลับจาก noise

### ทำไมมันสำคัญ
มันให้วิธีสร้างภาพที่มีเสถียรกว่า GAN ในหลายกรณี และคุณภาพสูงมากเมื่อปรับปรุงต่อ

### ผลกระทบต่อโลกจริง
กลายเป็นฐานคิดของภาพสังเคราะห์ยุคใหม่

### คำจำง่าย ๆ
> DDPM = สร้างภาพด้วยการ “ค่อย ๆ ล้าง noise ออก”

### ภาพจำ
```text
Clean Image → add noise → noisy image
Noisy image → denoise step by step → clean image
```

---

## 10) Latent Diffusion (2021)

**Paper:** *High-Resolution Image Synthesis with Latent Diffusion Models*

### มันคืออะไร
Latent Diffusion คือการทำ diffusion ไม่ใช่ใน pixel space ตรง ๆ แต่ทำใน **latent space** ซึ่งเล็กกว่าและคำนวณถูกกว่า

### แนวคิดหลัก
pipeline โดยย่อ:
1. ใช้ autoencoder / VAE บีบภาพลง latent
2. ทำ diffusion ใน latent
3. decode กลับเป็นภาพ

### ทำไมมันสำคัญ
มันลด cost มหาศาล ทำให้ text-to-image ระดับคุณภาพสูงเริ่มเข้าถึงได้จริง

### ผลกระทบต่อโลกจริง
แนวคิดนี้คือแกนของระบบอย่าง Stable Diffusion และมีอิทธิพลต่อ ecosystem ของ generative image model อย่างมาก

### คำจำง่าย ๆ
> Latent Diffusion = ทำ diffusion ในพื้นที่ที่เล็กกว่า ฉลาดกว่า และคุ้มกว่า

### ภาพจำ
```text
Image → VAE Encoder → Latent → Diffusion → VAE Decoder → New Image
```

---

## 11) GANs vs DDPM vs Latent Diffusion — ต่างกันยังไง

### GAN
- ภาพคม
- train ยาก
- ไม่เสถียร

### DDPM
- เสถียรขึ้น
- คุณภาพดี
- ช้ากว่า

### Latent Diffusion
- ลดต้นทุน
- เร็วขึ้น
- practical มากขึ้น

### สรุปจำง่าย
> GAN = คมแต่ซ้อมยาก  
> DDPM = เนียนและเสถียร  
> Latent Diffusion = พร้อมใช้งานระดับ ecosystem

---

# Part 5 — ทำให้ AI คิดและตอบจากความจริงมากขึ้น

## 12) Chain-of-Thought (2022)

**Paper:** *Chain-of-Thought Prompting Elicits Reasoning in Large Language Models*

### มันคืออะไร
Chain-of-Thought หรือ CoT คือแนวคิดว่าถ้าเรากระตุ้นให้โมเดลแก้ปัญหาเป็นขั้นตอน ผล reasoning จะดีขึ้นมาก

### แนวคิดหลัก
แทนที่จะถามแล้วให้ตอบ final ตรง ๆ เรากระตุ้นให้โมเดล “แตกปัญหาเป็นลำดับ”

### ทำไมมันสำคัญ
ทำให้เห็นว่า **วิธีถาม** ก็เปลี่ยนความสามารถที่ดึงออกมาจากโมเดลได้

### ผลกระทบต่อโลกจริง
- reasoning prompts
- math solving
- coding assistants
- agent planning
- self-reflection workflows

### คำจำง่าย ๆ
> CoT = อย่าให้ AI เดาสรุปเร็วเกินไป ให้มันค่อย ๆ คิด

### ภาพจำ
```text
Prompt → intermediate reasoning → final answer
```

---

## 13) RAG (2020)

**Paper:** *Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks*

### มันคืออะไร
RAG คือการทำให้โมเดลไปค้นข้อมูลจริงก่อน แล้วค่อยตอบ แทนที่จะอาศัยความจำในพารามิเตอร์อย่างเดียว

### ปัญหาที่มันแก้
LLM มักมีปัญหา:
- hallucination
- knowledge cutoff
- ตอบมั่นใจแม้ข้อมูลผิด

### แนวคิดหลัก
pipeline แบบง่าย:
1. รับคำถาม
2. retrieve เอกสารที่เกี่ยวข้อง
3. ส่ง context ให้ LLM
4. generate คำตอบจากข้อมูลที่ดึงมา

### ทำไมมันสำคัญ
RAG คือสะพานจากโมเดลทั่วไป ไปสู่ระบบ AI สำหรับองค์กร

### ผลกระทบต่อโลกจริง
- enterprise chatbot
- internal knowledge assistant
- support bot
- documentation QA
- legal / finance / policy search assistant

### คำจำง่าย ๆ
> RAG = อย่าให้โมเดลเดา ให้มันไปค้นก่อน

### ภาพจำ
```text
User Question → Retriever → Relevant Docs → LLM → Grounded Answer
```

---

# สรุปเชิงระบบ: 12 paper นี้ประกอบกันเป็น AI ที่เราใช้ทุกวันยังไง

## ถ้าเป็น ChatGPT / AI Assistant ยุคใหม่
คุณสามารถมองเป็นชั้น ๆ ได้แบบนี้

### ชั้นที่ 1: สมอง
- Transformer
- GPT-3
- Scaling Laws

### ชั้นที่ 2: พฤติกรรม
- InstructGPT
- Chain-of-Thought

### ชั้นที่ 3: ความรู้
- RAG

### ชั้นที่ 4: มัลติโหมด
- CLIP
- ViT

### ชั้นที่ 5: การสร้างภาพ
- DDPM
- Latent Diffusion
- GANs

### ชั้นที่ 6: รากฐาน vision ยุคใหม่
- AlexNet

---

# มุมมองแบบ Product / Engineering

## ถ้าคุณเป็น Developer
สิ่งที่ควรเข้าใจไม่ใช่แค่ชื่อ paper แต่คือ “แต่ละตัวแก้ pain point คนละชั้น”

- อยากให้ตอบเก่งขึ้น → ดู model / prompting / alignment
- อยากให้ตอบจากข้อมูลบริษัท → ดู RAG
- อยากให้คิดเป็นขั้นตอน → ดู CoT / agent design
- อยากให้เข้าใจภาพ → ดู CLIP / ViT
- อยากสร้างภาพ → ดู diffusion

## ถ้าคุณเป็น Founder
paper พวกนี้สอนว่า moat ของ AI product ไม่ได้อยู่แค่ model
แต่อยู่ที่:
- system integration
- data quality
- distribution
- workflow fit
- latency / cost control

## ถ้าคุณเป็น AI Engineer
ต้องแยกให้ออกว่าอะไรคือ:
- base capability
- alignment layer
- retrieval layer
- tool layer
- memory layer
- product UX layer

---

# Insight สำคัญที่คนมักพลาด

## 1. AI ไม่ได้เก่งเพราะ paper เดียว
มันเก่งเพราะมีหลาย paper มาต่อกันเป็นห่วงโซ่

## 2. Transformer สำคัญมาก แต่ไม่พอ
ถ้าไม่มี alignment, retrieval, prompting, tool use ก็ยังไม่กลายเป็น product ที่ดี

## 3. RAG ไม่ได้ทำให้โมเดลฉลาดขึ้นโดยตรง
แต่มันทำให้คำตอบ “อิงความจริงขึ้น”

## 4. CoT ไม่ได้เปลี่ยน model weights
แต่มันเปลี่ยนวิธีดึงความสามารถออกมา

## 5. Diffusion ทำให้ภาพสวยและเสถียรกว่าแนวทางเก่าหลายกรณี
นี่คือเหตุผลที่ text-to-image บูมหนักในยุคหลัง

## 6. Scaling Laws เปลี่ยนทั้งกลยุทธ์บริษัท
มันบอกว่าความเก่งไม่ได้เพิ่มแบบสุ่ม แต่เพิ่มแบบวางแผนได้

---

# Cheat Sheet จำเร็ว

## ถ้าต้องจำแค่ 1 บรรทัดต่อ paper
- **AlexNet** — ทำให้ Deep Learning กลับมายิ่งใหญ่อีกครั้ง
- **GANs** — สอนให้ AI สร้างข้อมูลใหม่แบบสมจริง
- **Transformer** — โครงสร้างแกนกลางของ LLM
- **GPT-3** — พิสูจน์พลังของการ scale model
- **InstructGPT** — ทำให้ AI ทำตามคำสั่งได้ดีขึ้น
- **Scaling Laws** — สูตรการโตของความสามารถโมเดล
- **ViT** — เอา Transformer ไปใช้กับภาพ
- **DDPM** — สร้างภาพด้วยการลบ noise ทีละขั้น
- **Latent Diffusion** — diffusion แบบคุ้ม compute และ practical
- **CLIP** — เชื่อมภาพกับภาษาเข้าด้วยกัน
- **Chain-of-Thought** — ทำให้ reasoning ดีขึ้นด้วยการคิดเป็นขั้นตอน
- **RAG** — ให้ AI ค้นข้อมูลก่อนตอบ

---

# ตัวอย่างภาพรวมการต่อระบบ

## AI Assistant สำหรับองค์กร
```text
User
  ↓
Retriever (RAG)
  ↓
Relevant Documents
  ↓
LLM (Transformer-based)
  ↓
Reasoning Pattern / CoT
  ↓
Answer
```

## AI Image Generation
```text
Prompt
  ↓
Text Encoder / CLIP-like representation
  ↓
Latent Diffusion Model
  ↓
Generated Image
```

## Multimodal AI
```text
Image + Text
   ↓
CLIP / ViT / Multimodal Transformer
   ↓
Shared Understanding
   ↓
Reasoning / Generation
```

---

# สรุปสุดท้าย

ถ้าจะเข้าใจ AI แบบไม่ผิวเผิน ต้องเห็นว่า:

- **AlexNet** เปิดยุคใหม่ของ Deep Learning
- **Transformer** เปิดยุคใหม่ของภาษาและ foundation models
- **GPT-3 + Scaling Laws** บอกว่าการขยายโมเดลปลดล็อกพลังมหาศาล
- **InstructGPT + CoT** ทำให้โมเดลใช้งานเป็นผู้ช่วยได้จริง
- **RAG** ทำให้ตอบบนข้อมูลจริงได้มากขึ้น
- **ViT + CLIP** ทำให้ภาพกับภาษาเริ่มหลอมรวมกัน
- **DDPM + Latent Diffusion + GANs** ทำให้ AI สร้างสื่อใหม่ได้อย่างทรงพลัง

> สุดท้าย AI ที่เราใช้ทุกวัน ไม่ได้เป็นแค่ “โมเดล”  
> แต่มันคือ “ระบบของโมเดล + ความรู้ + วิธีคิด + การจัดพฤติกรรม + การเชื่อมต่อโลกจริง”

---

# อ่านต่อ / โน้ตที่ควรลิงก์ใน Obsidian

คุณสามารถแตกโน้ตนี้ต่อเป็นโน้ตลูกได้ เช่น

- [[Transformer อธิบายละเอียด]]
- [[RAG สำหรับระบบองค์กร]]
- [[Diffusion Model แบบเข้าใจง่าย]]
- [[InstructGPT และ RLHF]]
- [[Scaling Laws กับกลยุทธ์บริษัท AI]]
- [[Vision Transformer และ CLIP]]
- [[ภาพรวม AI Product Architecture]]

---

# Glossary

## CNN
โครงข่ายประสาทที่ออกแบบมาสำหรับข้อมูลเชิงพื้นที่ เช่น ภาพ

## Self-Attention
กลไกที่ทำให้ token หนึ่งดูความสัมพันธ์กับ token อื่นทั้งหมดได้

## Parameter
ค่าน้ำหนักในโมเดลที่ใช้เก็บความรู้เชิงสถิติ

## RLHF
การใช้ feedback จากมนุษย์มาช่วยปรับพฤติกรรมของโมเดล

## Latent Space
พื้นที่แทนข้อมูลแบบย่อ ที่เก็บสาระสำคัญของข้อมูลไว้

## Hallucination
การที่โมเดลตอบผิดแต่พูดเหมือนมั่นใจว่าถูก

---

# ใช้โน้ตนี้ยังไงดี

- อ่านรอบแรกเพื่อเห็นภาพรวม
- อ่านรอบสองโดยแยกว่า paper ไหนคือ model, ไหนคือ system layer
- ถ้าจะ build product ให้เริ่มจาก RAG + instruction-following + tool integration
- ถ้าจะเข้าใจ research ให้ลงลึก Transformer, Scaling Laws, RLHF, Diffusion ต่อ

---

# TL;DR

AI ยุคใหม่เกิดจากการสะสมพลังของงานวิจัย 10+ ปี:
- **AlexNet** จุดไฟ
- **Transformer** เปลี่ยนสถาปัตยกรรม
- **GPT-3** ขยายจนเกิดความสามารถใหม่
- **InstructGPT** ทำให้ใช้งานจริง
- **RAG** ทำให้ grounded
- **CoT** ทำให้ reasoning ดีขึ้น
- **ViT / CLIP** ทำให้ multimodal
- **DDPM / Latent Diffusion / GANs** ทำให้สร้างสื่อใหม่ได้

> เข้าใจทั้ง 12 งานนี้ = เริ่มมอง AI เป็น “ระบบ” ไม่ใช่แค่คำฮิต
