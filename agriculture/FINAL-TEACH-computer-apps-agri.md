# Computer Applications in Agriculture — Teach + Exam Notes

**Who this is for:** You are learning this unit for the **first time**.  
**Source:** Your syllabus PDF (computer-controlled devices → models → apps → GIS/RS/GPS → DSS → expert systems).  
**Style:** Each idea is explained in plain language first. Exam tags come after.

| Tag | Exam job | How much to write |
|-----|----------|-------------------|
| **[1 mark]** | Define or expand one term | 1–3 lines |
| **[3 marks]** | Short note: def + 3–4 points | about ½ page |
| **[6 marks]** | Full answer: def → parts → agri use → limit/example | 1–1½ pages |

**How to read this once (about 2–3 hours):**

1. Read **Unit 0** (big picture).  
2. For each unit A–F: read **Teach me** fully, then skim **Exam pack**.  
3. Last 20 minutes: **Flash table** + write one **[6]** skeleton from memory.

---

# Unit 0 — Big picture (read this first)

## The farm problem in one story

Imagine a 10-acre field. One corner is dry. Another is rich in nitrogen. Insects attack only a strip near the road. The old way is: treat the **whole field the same** — same seed rate, same fertilizer, same spray, same water.

That wastes money and chemicals. It also underfeeds the needy zone.

Modern **computer applications in agriculture** try to answer four questions in a loop:

```text
1. SENSE   What is happening in this spot?     (sensors, GPS, remote sensing)
2. MODEL   What will happen if we do X?       (crop simulation models)
3. ADVISE  What must the farmer do?         (apps, DSS, expert systems)
4. ACT     Apply the right amount in place    (VRA, guided tractor, irrigation)
                ↑
         GIS holds the maps (layers of where + what)
```

**Memory hook:** **S-M-A-A** — Sense · Model · Advise · Act.

You do not need to be a programmer. You need to know **what each tool is for**, **what data it needs**, and **how to write a clear exam answer**.

---

# Unit A — Computer-controlled devices for agri inputs

## Teach me

### What “computer-controlled” means

A device is computer-controlled when:

1. Something in the field is **measured** (sensor).  
2. A computer **reads that signal**.  
3. The machine **changes what it does** (plant, spray, water) based on rules or maps.

Daily-life examples help: a **robot** follows a program to move and handle objects. An **ATM** is a computer that checks your account and gives cash. On a farm, the same idea drives planters and sprayers.

### Precision farming (the goal)

**Precision farming** (also called site-specific farming) means:

> Right input · right amount · right place · right time.

Not one blanket rate for the whole field.

### The five systems in your syllabus

#### 1. Sensor **[1]**

**Definition:** A sensor is a device that receives a signal or stimulus (heat, light, pressure, moisture, and more) and responds in a clear, useful way that a computer can use.

**Why farms use sensors:** Greenhouse and polyhouse climate control, soil moisture, and precision farming all need continuous measurement. Humans cannot stand in the field 24 hours a day.

**Easy example — barcode:** Black and white stripes on a pack. A light beam reads them. That is an **optical** sensor. Rule: there must be **line of sight** (nothing blocks the light).

#### 2. Seed planting system **[3]**

**Problem:** If seeds are too close, plants compete. If too far, land is wasted.

**How the system works:**

1. A mobile planter (towed or self-propelled) has **planting shoes** that put seed in the soil.  
2. Sensors near each shoe detect each planting event.  
3. Signals go to a computer.  
4. The computer controls spacing for a more even stand.

#### 3. Geospatial locator **[3]**

**Geospatial** means “linked to a place on Earth” (usually latitude and longitude).

While seeds are planted, a locator records **where each seed went**. The computer joins:

- seed drop events, and  
- location data  

into a **seed distribution profile** (a map of where seed was placed). That profile supports spacing control and later management.

#### 4. Variable Rate Application (VRA) **[3–6]**

**Definition:** VRA applies a material (seed, fertilizer, pesticide, lime) so the **rate changes with location or local field quality**.

**Contrast:**

| Uniform application | Variable rate |
|---------------------|---------------|
| Same dose everywhere | Dose follows a map or sensor |
| Simple machine setup | Needs maps + controller + GPS |

**Equipment families in the notes:** computer/controllers, liquid sprayers, granular fertilizer applicators, air sprayers/spreaders, drills and planters.

**Mental picture:** The soil map says “Zone A needs more N; Zone B needs less.” The spreader opens more over A and less over B while the tractor moves.

#### 5. Irrigation system (computer-linked) **[3]**

Water is an input like fertilizer. Sensors (or schedules, or maps) tell the controller when and how much to water. The same precision idea applies: do not flood the wet corner and starve the dry corner.

### How the five fit together

```text
Sensor measures need
   → Geospatial/GPS says WHERE
   → Controller decides RATE
   → Planter / sprayer / pump ACTS
```

### Common confusions

| Do not mix | Difference |
|------------|------------|
| Sensor vs GIS | Sensor **captures** a signal. GIS **stores and analyzes maps**. |
| VRA vs “smart sprayer with no map” | Without location + quality data, you cannot truly do variable rate. |
| GPS vs sensor | GPS answers “where am I?” Sensor answers “what is the condition?” |

### Exam pack — Unit A

**Mnemonic:** **S-S-G-V-I** — Sensor, Seed, Geospatial, VRA, Irrigation.

**Likely questions**

1. **[1]** Define sensor.  
2. **[3]** Short notes on Variable Rate Application.  
3. **[6]** Computer-controlled devices for agri input management with examples.

**[6] answer order:** define precision idea → list five systems with one sentence each → one flow (soil map + GPS + VRA) → one limit (bad map → bad rate).

---

# Unit B — Computer models and crop simulation

## Teach me

### Why models exist

Field experiments are expensive and slow. You cannot run 50 seasons in one week outside. A **model** compresses what science knows about crop growth into a form a computer can run.

### Three words you must separate **[1]**

| Word | Meaning |
|------|---------|
| **System** | The real crop + soil + weather + management together |
| **Model** | A **simplified** picture of that system, often as math equations |
| **Simulation** | Running the model through time with data to see what happens |

**One-line exam definition:**  
A **model** is a simplified representation of a system or process. **Simulation** is building models and analyzing the system with them.

### What a crop model does

Given weather and field data, a crop model can estimate:

- development stage (when it flowers, when it matures)  
- growth and biomass  
- yield  
- water and nutrient uptake  

It is a **what-if machine**: “If monsoon is late, what happens to yield for this variety?”

### Why we need simulation models **[3]** (four reasons from syllabus)

1. **Store knowledge** from many field trials in one structure.  
2. **Support teamwork** across disciplines (soil, weather, breeding).  
3. **Use systems analysis** on complex cropping problems.  
4. Provide **dynamic, quantitative** tools (numbers that change over time).

### Two main types of crop growth models **[3]**

| Type | How it works | Strength | Weakness |
|------|--------------|----------|----------|
| **Empirical / regression** | Fits a curve to past data (for example Richards function, polynomials) | Fast, simple | Weak on “why”; risky outside the data range |
| **Mechanistic** | Builds growth from physiology (photosynthesis, water, nitrogen) linked to environment | Explains mechanism | Needs more data and skill |

Think: empirical is a **fitted graph**. Mechanistic is a **mini plant physiology lab in software**.

### Inputs the model needs **[6]** — learn the groups

Crop modeling usually needs data on **weather, crop, soil, management**, and sometimes **insect-pests**.

#### Weather (usually **daily**)

Maximum and minimum temperature, rainfall, relative humidity, solar radiation, wind speed.

Why daily? Growth processes are calculated day by day.

#### Crop

Name, variety, phenology (days to anthesis, days to maturity), leaf area index (LAI), grain yield, above-ground biomass, 1000-grain weight.

**Phenology** = timing of life stages (flowering, maturity).

#### Soil

Layer thickness, pH, EC, N, P, K, soil organic carbon, texture, sand and clay %, moisture, saturation, field capacity, wilting point, bulk density.

These control water and nutrient supply to roots.

#### Management

- **Start date:** usually **sowing date**.  
- **Rice exception:** for transplanted rice, use **date of transplanting**, not nursery sowing.  
- Seed rate and depth.  
- Irrigation, fertilizer, manure, crop residue: amount, type, date, depth of placement.  
- If organic sources: **C:N ratio**.

### Uses **[3]**

**Farm level:** pre-season and in-season choices on cultural practices, fertilizer, irrigation, pesticides.  
**Policy level:** soil erosion risk, leaching of chemicals, climate change effects, large-area yield forecasts.

### Limits (always add for full marks)

- Bad weather data → bad forecast.  
- Wrong variety parameters → wrong yield.  
- Simple models often weak on pests and disease.  
- Garbage in, garbage out.

### Exam pack — Unit B

**Mnemonic for inputs:** **W-C-S-M** — Weather, Crop, Soil, Management.

**Likely questions**

1. **[1]** Define model / simulation / crop model.  
2. **[3]** Advantages of crop simulation models.  
3. **[3]** Empirical vs mechanistic models.  
4. **[6]** Components and input data requirements of crop simulation models.

---

# Unit C — Smartphone apps, markets, postharvest

## Teach me

### What a mobile app is **[1]**

A **mobile app** is software built for a small wireless device (smartphone or tablet), not a desktop. It can come **preloaded** or **downloaded** from an app store or the internet.

Your syllabus also covers apps for agriculture, horticulture, animal husbandry, and farm machinery. Indian notes often mention products from developers such as **Jayalaxmiagrotech**.

### Why phones matter for farmers

Many farmers are far from extension offices. Phones + **cloud** services + online content shrink that distance. Benefits include:

- better land decisions (soil condition + weather together)  
- smarter use of fertilizer, seed, and water  
- lower cost and less waste  

**RML (Reuters Market Light):** a subscription **SMS** service (not only a smartphone app) for local commodity prices, crop tips, and weather.

### Three technical types of apps **[1–3]**

| Type | Idea | Exam line |
|------|------|-----------|
| **Native** | Written for one platform (Android or iOS). Uses device features deeply | Best performance / device access |
| **Hybrid** | Mix of native shell + web technologies | Middle path |
| **Web app** | Lives on a remote server. You open it in a browser | No full install; needs network |

### Apps for farm advice (examples to name)

You do not memorize every star rating. You memorize **one job per app**.

| App | Teach yourself: “This app is for…” |
|-----|-------------------------------------|
| **AgriApp** | Online marketplace + chat with experts + farming videos |
| **IFFCO Kisan** | Weather, mandi rates, advisories, many Indian languages, ask experts |
| **Agri Media Video** | Video learning + chat + upload photos of sick crops |
| **Farm-Bee / RML Farmer** | Guidance through crop life cycle; many crops, markets, weather points |
| **KisanYojana** | Government schemes in one place (saves travel to offices) |
| **Smart Krishi** | Package of practices, stories, herb library, GPS farm contacts, tips, weather |

**IFFCO Kisan feature family (if asked to list services):** agro IT, call centre, urban grading, software solutions, commodity services, rural distribution.

**Farm-Bee numbers often asked:** about **450** crop varieties, **1300** markets, **3500** weather locations (as in notes).

### Apps for market prices

#### AgriMarket

Shows crop prices in markets within about **50 km** of your GPS location. You can also pick market and crop manually.

#### eNAM (National Agriculture Market) **[1–3] — high value**

**Problem:** India has many local APMC mandis. Prices and procedures differ. Farmers may not see the best buyer.

**Idea:** One **pan-India electronic trading portal** that networks existing **APMC mandis** into a more unified market.

| Fact | Detail |
|------|--------|
| Lead agency | **SFAC** (Small Farmers Agribusiness Consortium) |
| Ministry | Agriculture and Farmers’ Welfare, Government of India |
| Vision | Uniform procedures, less information asymmetry, real-time price discovery |
| Mission | Integrate APMCs online, transparent quality-based auction, timely online payment |
| Scale notes | **90+ commodities**; app in **8 languages**; start mostly intra-market, then inter-market / inter-state |

#### Rythu Bazar App

Local fresh vegetable and fruit market prices. Helps find a nearby Rythu Bazar.

#### Mandi app

Live mandi rates, zone-wise APMC lists, daily sync, language options.

#### AGMARKNET **[1]**

**Agricultural Marketing Information Network**, launched **March 2000** by the Union Ministry of Agriculture. Background system for market price information (pair with mandi apps in answers).

### Postharvest management **[1–3]**

**Golden rule (write exactly):**

> **Quality cannot be improved after harvest but maintained.**

Meaning:

1. Harvest only good produce for market.  
2. Poor quality already has a short postharvest life.  
3. After harvest you **cool, clean, sort, pack** to **hold** quality, not create it.  
4. Good cultural practices **before** harvest still matter.

**CHEETAH app (example in notes):** aims at postharvest losses in trade chains (including border crossings along the Trans-Africa Highway idea). Stats quoted in the PDF for global/Africa losses: about **$48 billion/year** in Africa, about **33%** of global food production lost; bruised lots can cost a farmer about **30%** when markets reject damage.

### Exam pack — Unit C

**Mnemonic:** **A-I-F-K-E** — AgriApp, IFFCO, FarmBee, KisanYojana, eNAM.

**Likely questions**

1. **[1]** Postharvest golden rule.  
2. **[1]** Expand eNAM / SFAC / AGMARKNET.  
3. **[3]** Types of mobile apps.  
4. **[3]** Any four agriculture apps and features.  
5. **[6]** Role of smartphone apps in farm advice and market price discovery.

---

# Unit D — Geospatial technology: GIS, remote sensing, GPS

## Teach me

This unit confuses students most. Separate three tools first.

| Tool | Question it answers | Farm picture |
|------|---------------------|--------------|
| **GPS** | **Where** am I / is this point? | Tractor position, sample point |
| **Remote sensing (RS)** | **What does this area look like** without walking every metre? | Satellite/drone image of stress |
| **GIS** | **How do I store, overlay, and analyze** all place-based data? | Map of soil + yield + weeds together |

### GIS — Geographic Information System **[1–6]**

**Plain definition:**  
A GIS is a computer system for **geographic (spatial) data** and the attributes attached to it. It can capture, store, edit, analyze, share, and display information that is tied to locations on Earth.

**Key difference from a normal database:**  
Every fact in GIS must link to a **spatial reference** (latitude/longitude or other coordinates).

**ESRI-style definition (good for exams):**  
An organized collection of computer hardware, software, geographic data, and people designed to efficiently capture, store, update, manipulate, analyze, and display geographically referenced information.

### Spatial data vs attribute data **[1–3]**

| | Spatial | Attribute (non-spatial) |
|--|---------|-------------------------|
| Means | **Where** | **What properties** |
| Examples | Field boundary polygon, well point, canal line | Crop name, yield, owner, soil class |

GIS is powerful because it joins both.

### How the real world becomes digital

Four basic geographic types:

| Type | Dimension | Example |
|------|-----------|---------|
| Point | 0-D (position only) | Tube well, sample site |
| Line | 1-D (has length) | Road, canal, fence |
| Area / polygon | 2-D (has area) | Field, village, lake |
| Surface | continuous values | Elevation, temperature |

### Raster vs vector **[3]**

| | Raster | Vector |
|--|--------|--------|
| Form | Grid of cells (pixels) | Points, lines, polygons |
| Best for | Continuous surfaces (elevation, NDVI, temperature) | Clear boundaries (roads, plots) |
| Think of | Photo / chessboard of values | Drawing with shapes |

**Conceptual models:**

- **Objects:** discrete things with boundaries (a road, a building).  
- **Fields:** a value everywhere (every point has elevation or soil moisture).

**Logical models:** raster · vector (including **TIN** for some continuous surfaces) · **object-oriented** models.

### Components of GIS **[3]** (learn both lists)

**Process list (four functions):**

1. Data input (digitizing, scanning, import)  
2. Storage and retrieval  
3. Analysis and manipulation  
4. Output (maps, tables)

**System list:**

1. Hardware  
2. Software  
3. Data  
4. Skilled people  

**Geodatabase:** one container for spatial and non-spatial data, with rules that can validate attributes.

### Five Ms of GIS application **[1]**

**Mapping · Measurement · Monitoring · Modeling · Management**

### Application domains **[3]**

Government and public service · business/service planning (including **geodemographics**) · logistics and transport · environment.

### Popular software names **[1]**

ArcGIS, AutoCAD, Cadcorp, ERDAS IMAGINE, IDRISI, Intergraph, MapInfo, MicroStation, and open-source options.

### GIS analysis operations (name any five) **[3]**

Retrieval, buffer generation, polygon overlay/dissolve, measurements, network analysis, digital terrain analysis, map transformation, export.

### Remote sensing **[3]**

**Definition:** Measuring properties of an object or area **without physical contact**. Principles can be acoustic or electromagnetic. In agriculture, most work uses the **electromagnetic spectrum**.

**Farm intuition:** When you look across a field and judge plant color without touching leaves, that is a human form of remote sensing. Satellites and aircraft do the same from high above.

**Uses:** find nutrient lack, disease, water stress, insect damage, hail/wind/herbicide damage, plant population. Images become **base maps** for VRA of fertilizer and pesticide so only affected zones are treated.

### GPS + GIS in agriculture (precision farming) **[6]**

Precision farming became practical when **GPS** (location) combined with **GIS** (maps and analysis). (If a note prints “CPS”, write **GPS**.)

| Use | What you understand |
|-----|---------------------|
| **Tractor guidance** | Record a path. Repeat it for tillage, fertilizer, harvest. Saves overlap and gaps. |
| **Crop-duster targeting** | Mark insect hotspots. Spray those zones only. Save chemical, fuel, time. |
| **Livestock tracking** | Collar transmitters follow valuable animals; also transit to market. |
| **Soil sampling** | Waypoint each sample. Map lab results. Treat only needy zones. |
| **Yield monitoring** | Estimate yield by zone. Plan next season from the map. |

Also: map field boundaries, roads, irrigation layouts, weed or disease patches.

**Mnemonic:** **T-C-L-S-Y** — Tractor, Crop-duster, Livestock, Soil sample, Yield.

### Exam pack — Unit D

**Likely questions**

1. **[1]** Define GIS / RS / spatial data / Five Ms.  
2. **[3]** Components of GIS.  
3. **[3]** Raster vs vector.  
4. **[6]** GIS and GPS applications in agriculture.  
5. **[6]** Geospatial technology concepts and components.

---

# Unit E — Decision Support System (DSS)

## Teach me

### Everyday analogy

You open a weather app before irrigating. The app does not irrigate for you. It **supports** your decision with data. A **DSS** is the general name for interactive computer systems that help people use data, models, documents, knowledge, and communication tools to make better decisions.

**Definition [1]:**  
A DSS is an interactive computer-based system that helps decision makers use communications technologies, data, documents, knowledge, and/or models to identify problems, complete decision tasks, and make decisions.

**Important:** A DSS **aids** the human. It does not replace responsibility.

### Related systems under the same umbrella

GIS, Enterprise Information Systems (EIS), Expert Systems (ES), OLAP, software agents, knowledge discovery tools, and group DSS are often grouped as DSS-class tools.

### Three architecture parts **[1–3]**

1. **Database / knowledge base** — facts and rules stored  
2. **Model** — how options are evaluated (your criteria and context)  
3. **User interface** — how a person talks to the system  

The user is part of the system too.

### Decision phases (classic framework) **[3]**

1. **Intelligence** — notice that a decision is needed  
2. **Design** — invent possible actions  
3. **Choice** — select one action  
4. **Implementation** — put it into practice  

### Five types of DSS **[3]**

| Type | Emphasizes | Example flavor |
|------|------------|----------------|
| **Model-driven** | Optimization / simulation models | Sprinter, MEDIAC, Brandaid (named in notes) |
| **Data-driven** | Large time-series data + queries | Retail-scale warehouses (WalMart-type example in notes) |
| **Communication-driven** | Groupware, video, bulletin boards | Team decisions |
| **Document-driven** | Policies, catalogs, archives | Find and read rules/specs |
| **Knowledge-driven** | Recommend actions like an expert | AI / expert systems |

**Mnemonic:** **M-D-C-D-K**.

### Tools often listed

Multi-dimensional / **OLAP** software, **query tools**, **data mining** tools.

### Technology levels **[3]**

1. **Application** — the finished DSS the manager uses.  
2. **Generator** — environment to build DSS apps (examples: Crystal, Analytica, iThink).  
3. **Tools** — languages, libraries, modules underneath.

### Other classifications (if the paper says “classify DSS”)

- **Holsapple & Whinston:** text, database, spreadsheet, solver, rule, and **compound** (hybrid of two or more; most popular).  
- Support levels: **Personal · Group · Organizational**.  
- IO view: inputs · user knowledge · outputs · decisions.  
- **IDSS:** intelligent DSS using AI or agents.  
- Non-agri examples in notes: clinical DSS; Canadian National Railway equipment testing to reduce derailments.

### When is a DSS worth building?

Ask: Is normal programming enough? Is the domain bounded? Is there a willing expert? Can the expert explain knowledge? Is knowledge heuristic (rules of thumb) and uncertain?

### Agriculture examples **[3–6]**

- **DSSAT4** (developed with USAID-era support): quickly assesses production systems to help farm and policy decisions.  
- **Precision agriculture** uses DSS ideas to tailor decisions to **portions of fields**.  
- Adoption still faces cost, skill, and data constraints.  
- Forestry also uses DSS heavily (long planning horizons).

### Exam pack — Unit E

**Likely questions**

1. **[1]** Define DSS.  
2. **[3]** Components of DSS.  
3. **[3]** Types of DSS with examples.  
4. **[6]** DSS in agriculture / precision farming / DSSAT.

---

# Unit F — Expert systems and Soil Information Systems

## Teach me

### Why expert systems for farming?

A farmer faces plant disease, insects, weather, markets, and soil together. No one person is a full expert in all of that every day. **Numerical formulas alone** often fail because much farm knowledge is **qualitative** (experience, rules of thumb).

An **expert system** is a computer program that solves problems by **mimicking human expert reasoning** — logic, belief, rules of thumb, and experience — not only calculation.

### Building blocks **[3]**

1. **User interface** — how the farmer or officer asks and sees answers  
2. **Database** — facts about the case  
3. **Knowledge base** — expert rules and knowledge  
4. **Inference mechanism** — engine that applies rules to facts to reach advice  

### Development phases **[3]**

Problem selection → knowledge acquisition → knowledge representation → programming → testing and evaluation.

### Soil Information System (SIS) **[3]**

SIS builds **high-resolution soil and topographic maps** with advanced sensors and geo-processing. It describes physical and chemical soil properties and how inputs move through soil. Advisors use it for **zone-wise** irrigation, drainage, and fertility — not one average for the whole farm.

### Benefits for farmers **[3]**

- Better decisions when a human specialist is not available  
- Higher profit through smarter input use and less loss  
- Sustainability (less runoff, better targeting)  
- Training tool that shows reasoning for new staff  

### Named systems to remember (examples)

**Web / portals:** Maize Agri Daksh (IASRI), Wheat expert system (IASRI), Digital mandi, mKisan portal, RICE Doctor (IRRI), TNAU AgriTECH PORTAL, Barley expert system, Rice Knowledge Management Portal, ES for agriculture and animal husbandry (DWCRA, Bhubaneswar).

**Mobile examples:** Crop insurance app (MoA), AgriMarket, mKisan, RainbowAgri, Manditrades, Mpower, IFFCO Kisan, eSAP.

### Exam pack — Unit F

**Likely questions**

1. **[1]** Define expert system / SIS.  
2. **[3]** Components of an expert system.  
3. **[3]** Importance of expert systems in agriculture.  
4. **[6]** Expert systems and SIS for farm decisions with examples.

---

# Unit G — How to write marks (copy this structure)

## [1 mark] pattern

Definition in one clear sentence. Optional second sentence with one example.

## [3 marks] pattern

1. Definition (2 lines)  
2. Three bullet points (feature / use / example)  
3. One closing line of importance  

## [6 marks] pattern

1. Introduction / definition  
2. Classification or components (table or numbered list)  
3. Agricultural applications with examples  
4. One limitation or challenge  
5. Conclusion (one line)

### Ready skeletons

**GIS + GPS in agriculture [6]**  
Def GIS + GPS → precision farming link → five uses T-C-L-S-Y → one limit → close.

**Crop simulation [6]**  
Def model/simulation → four reasons → empirical vs mechanistic → W-C-S-M inputs + rice transplant note → uses + limit.

**Computer-controlled devices [6]**  
Precision idea → S-S-G-V-I with one line each → VRA flow → limit.

**DSS / Expert system [6]**  
Def DSS vs ES → architecture → types or components → DSSAT / apps / SIS → close on better decisions.

---

# Unit H — Flash table (last revision)

| Cue | Answer |
|-----|--------|
| S-M-A-A | Sense, Model, Advise, Act |
| Precision farming | Right input, amount, place, time |
| Sensor | Stimulus → useful response/signal |
| VRA | Rate changes with location/quality |
| Model vs simulation | Picture vs running the picture |
| Empirical vs mechanistic | Curve fit vs physiology process |
| W-C-S-M | Weather, Crop, Soil, Management |
| Rice model start | Transplant date |
| Native / hybrid / web | Platform install / mix / browser |
| eNAM | Pan-India e-market of APMC mandis |
| SFAC | Implements eNAM under MoA&FW |
| AGMARKNET | Market info network, March 2000 |
| PHM golden rule | Quality not improved after harvest — maintained |
| GIS | Spatial + attribute computer system |
| GPS / RS / GIS | Where / sense without contact / analyze maps |
| Five Ms | Map, Measure, Monitor, Model, Manage |
| Raster / vector | Grid / points-lines-polygons |
| DSS core 3 | Database, model, user interface |
| DSS phases | Intelligence, Design, Choice, Implementation |
| M-D-C-D-K | Model, Data, Comm, Document, Knowledge DSS types |
| Holsapple compound | Hybrid of two+ DSS structures |
| ES core | Knowledge base + inference |
| SIS | High-res soil/topo maps for zone decisions |
| T-C-L-S-Y | Tractor, Crop-duster, Livestock, Soil, Yield |
| PDF typo CPS | Write GPS |

---

# Unit I — Gotchas that lose marks

1. **GIS ≠ GPS ≠ RS** — analyze maps ≠ locate ≠ sense at a distance.  
2. **Model ≠ simulation** — structure ≠ the run.  
3. **Attribute ≠ spatial** — both are required in GIS.  
4. **eNAM ≠ Rythu Bazar** — national electronic APMC network ≠ local vegetable market app.  
5. **Expert system ≠ spreadsheet** — inference + knowledge base, not only formulas.  
6. **VRA needs a map or sensor basis** — otherwise it is only a sprayer.  
7. Spell carefully: geospatial, phenology, inference, APMC, SFAC, AGMARKNET.

---

# Unit J — Mini self-test (cover answers, then check)

1. Why is line of sight needed for a barcode scanner?  
2. Why does transplanted rice use transplant date in a model?  
3. Name two differences between raster and vector.  
4. Write the postharvest golden rule from memory.  
5. List the three core parts of a DSS.  
6. What does the inference mechanism do in an expert system?  
7. Give one sentence each for GPS, RS, and GIS on a farm.

**Quick answers:**  
1) Light must reach the code with no block.  
2) Simulation of the field crop starts when the plant enters the main field.  
3) Raster = grid cells for continuous surfaces; vector = shapes for clear boundaries.  
4) Quality cannot be improved after harvest but maintained.  
5) Database/knowledge base, model, user interface.  
6) Applies rules in the knowledge base to facts to reach advice.  
7) GPS = where; RS = condition from a distance; GIS = store/analyze map layers.

---

**Source scope:** Your provided PDF unit on automated agri inputs, crop models, smartphone apps and markets, postharvest rule, GIS/RS/GPS, DSS, expert systems and SIS. If your teacher’s handout uses a different app list, keep their names and use this file for **concepts and structure**.

**Exam courage line:** Start every long answer with a clear definition and one farm example. Examiners read the first five lines carefully.
