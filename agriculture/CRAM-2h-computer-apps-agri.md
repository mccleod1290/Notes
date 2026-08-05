# 2-HOUR CRAM — Computer Apps / ICT in Agriculture

**Source PDF:** agri input automation → models → apps → GIS/RS/GPS → DSS → expert systems 
**Exam map:** SVU-style 2nd year (1 / 3 / 6 mark tags). 
**How to use (120 min):** 0–15 mark legend + unit map · 15–70 units A–C · 70–100 units D–F · 100–120 write 2× 6-mark skeletons + flash gotchas.

**Mark legend**

| Tag | Meaning | Write length |
|-----|---------|--------------|
| **[1]** | Definition / one fact / expand abbreviation | 1–2 lines |
| **[3]** | Short note / list + one line each | ½ page |
| **[6]** | Full answer: def → parts → agri use → limit/example | 1–1½ pages |

---

## 0. One map of the whole syllabus

```text
SENSE the field → MODEL what will grow → ADVISE the farmer → ACT on map
 sensors/GPS crop simulation apps / expert / DSS VRA / irrigation
 ↑
 GIS holds layers
```

**Memory hook:** **S-M-A-A** — Sense · Model · Advise · Act.

---

## A. Computer-controlled devices (agri input management) **[3–6]**

### First principle

A computer-controlled farm device **measures** (sensor) → **locates** (GPS/geospatial) → **decides rate** (controller) → **applies input** (seed/fertilizer/water). Precision farming = right amount, right place, right time.

### Five systems (list for **[3]** / expand any one for **[6]**)

| Device | What it does | Exam one-liner |
|--------|--------------|----------------|
| **Sensor** | Converts heat/light/pressure into a computer signal | Barcode scanner = light → code (needs line of sight) |
| **Seed planting system** | Shoes plant seed; sensors log each drop | Optimal **spacing** under computer control |
| **Geospatial locator** | Sends lat/long of each seed to computer | Builds **seed distribution profile** |
| **Variable Rate Application (VRA)** | Rate of material depends on location / field quality | Not one flat rate for whole field |
| **Irrigation system** | Water by need / map / schedule under control | Links to sensors + VRA idea |

**Mnemonic for five devices:** **S-S-G-V-I** — Sensor, Seed, Geospatial, VRA, Irrigation.

### Gotchas

- Sensor is **not** the same as GIS. Sensor = data capture. GIS = store/analyze maps.
- Barcode needs **line of sight** (obstruction fails).
- VRA needs **location quality data** (soil/yield map). Without map, VRA is just a sprayer.

### Expected Qs

1. **[1]** Define sensor. 
2. **[3]** Write short notes on Variable Rate Application. 
3. **[6]** Explain computer-controlled devices for agri input management with examples.

---

## B. Computer / crop models **[3–6]**

### First principle

**Model** = simplified picture of a system in math form. 
**Simulation** = run that picture through time with weather/soil/management to forecast growth and yield.

### Why models **[3]** (list 4)

1. Store knowledge from many field trials in one structure. 
2. Force multi-discipline teamwork. 
3. Use systems analysis on complex crops. 
4. Give dynamic, quantitative tools for management choice.

### Two types of crop growth models **[1–3]**

| Type | Idea | Exam word |
|------|------|-----------|
| **Regression / empirical** | Fit a curve (Richards, polynomials) to growth data | Describes pattern; weak on “why” |
| **Mechanistic** | Build from physiology (photosynthesis, water, N) vs environment | Explains mechanism |

### Inputs you must list **[3–6]**

| Class | Key items |
|-------|-----------|
| **Weather** (daily) | Tmax, Tmin, rain, RH, solar radiation, wind |
| **Crop** | Name, variety, phenology (days to anthesis/maturity), LAI, biomass, 1000-grain weight |
| **Soil** | Layers, pH, EC, NPK, SOC, texture, sand/clay %, moisture, FC, WP, bulk density |
| **Management** | Sowing date (or **transplant date for rice**), seed rate/depth, irrigation, fertilizer, manure, residue, C:N if organic |

**Start time gotcha:** Simulation usually starts at **sowing**. For transplanted rice, use **transplant date**, not nursery sowing.

### Uses **[3]**

Pre-season / in-season decisions: fertilizer, irrigation, pesticides. Policy: erosion, leaching, climate effect, large-area yield forecast.

### Limits (add in **[6]** for full marks)

You need good daily weather. Wrong variety parameters give wrong yield. Simple models are weak on pests. Bad inputs give bad output.

### Expected Qs

1. **[1]** Define crop model / simulation. 
2. **[3]** Advantages of crop simulation models. 
3. **[3]** Differentiate empirical vs mechanistic models. 
4. **[6]** Components and input data requirements of crop simulation models.

**Hack:** Write **W-C-S-M** for inputs: Weather, Crop, Soil, Management.

---

## C. Smartphone apps (advice · market · postharvest) **[3–6]**

### First principle

App = software on phone/tablet (not desktop). Moves **weather, price, scheme, expert chat** to the field so the farmer decides faster.

### App types **[1]**

| Type | Meaning |
|------|---------|
| **Native** | Built for one OS; uses device features fully |
| **Hybrid** | Mix of native + web |
| **Web app** | Runs in browser from remote server |

### Farm-advice apps (name 5 for **[3]**)

| App | Remember for |
|-----|----------------|
| **AgriApp** | Marketplace + expert chat + videos (~0.1M users, ~4.3★) |
| **IFFCO Kisan** | Weather, mandi rates, advisories, **many Indian languages** |
| **Agri Media Video** | Videos + chat + upload infected crop image (~4.8★) |
| **Farm-Bee / RML Farmer** | Crop cycle content; many markets/weather points; multi-language |
| **KisanYojana** | **Govt schemes** gap-closer (saves trip to office) |
| **Smart Krishi** | Package of practices, library, GPS farm contacts, weather |

**RML:** Reuters Market Light — SMS service for **local price, crop tips, weather** (subscription).

### Market price apps **[3]**

| App | One fact |
|-----|----------|
| **AgriMarket** | Prices within **50 km** via GPS (or manual market pick) |
| **eNAM** | Pan-India electronic trading; links **APMC mandis**; SFAC implements under MoA&FW |
| **Rythu Bazar App** | Local vegetable market prices + nearest Rythu Bazar |
| **Mandi app** | Live mandi rates; zone-wise APMC; daily sync |

### eNAM must-know **[1–3]** (high frequency)

- **What:** Unified national electronic market for agri commodities. 
- **Who:** SFAC is the lead agency under the Ministry of Agriculture and Farmers’ Welfare. 
- **Why:** Real-time price discovery. Cut the information gap between buyer and seller. Support online payment. 
- **Vision/Mission line:** Uniform procedures across markets. Transparent auction based on quality of produce.

### Postharvest golden rule **[1]** (almost always asked)

> **Quality cannot be improved after harvest — only maintained.**

So harvest only good produce. Then cool, clean, sort, and pack. Poor quality means short shelf life. Cultural practices **before** harvest still matter for market life.

**CHEETAH app (Africa example):** Postharvest loss / border chain intelligence (exam can ask “apps for PHM”).

### Expected Qs

1. **[1]** Postharvest golden rule. 
2. **[1]** Expand eNAM / SFAC. 
3. **[3]** Types of mobile apps with examples. 
4. **[3]** Any four agriculture mobile apps and features. 
5. **[6]** Role of smartphone apps in farm advice and market price discovery.

**Hack:** **A-I-F-K-E** — AgriApp, IFFCO, FarmBee, KisanYojana, eNAM.

---

## D. Geospatial technology: GIS · RS · GPS **[6 heavy]**

### First principles (write this first in any long answer)

| Term | Plain meaning |
|------|----------------|
| **GIS** | Computer system for **geo-referenced** data: capture, store, edit, analyze, display |
| **Spatial data** | **Where** (point, line, polygon, surface) |
| **Attribute data** | **What** (name, yield, soil class) — non-location properties |
| **Remote sensing** | Measure object properties **without physical contact** (mostly EM spectrum in agri) |
| **GPS** | Satellite positioning for field coordinates |

ESRI-style definition (use in **[1]**/**[6]**): organized hardware + software + geographic data + people to handle geographically referenced information.

### GIS components **[3]** (two answer styles — both valid)

**Style A (process):** 1) Data input 2) Storage & retrieval 3) Analysis & manipulation 4) Output 

**Style B (system):** Hardware · Software · Data · People (skilled users)

**Software module group:** input/verify · storage/DB · transform · output · user interaction.

### Raster vs vector **[3]** (classic 1–3 mark)

| | **Raster** | **Vector** |
|--|------------|------------|
| Form | Grid of cells/pixels | Points, lines, polygons (+ TIN for surfaces) |
| Best for | Continuous fields (elevation, temp, NDVI) | Discrete objects (roads, fields, wells) |
| Trade | Simple math; can be heavy on storage | Precise boundaries; topology |

**Conceptual models:** **Objects** (discrete boundaries) vs **Fields** (value everywhere — elevation, soil chemistry).

**Four feature types to store:** point (0-D) · line (1-D) · area/polygon (2-D) · continuous surface.

### Five Ms of GIS application **[1–3]**

**Mapping · Measurement · Monitoring · Modeling · Management**

### GIS analysis ops (name any 5 in **[3]**)

Retrieval · buffer · overlay/dissolve · measurements · network · terrain analysis · map transform/export.

### GIS benefits (3 lines for **[3]**)

Integrate many databases · spatial analysis in complex settings · fast specialized maps · manage data in spatial context.

### Popular packages **[1]**

ArcGIS, ERDAS IMAGINE, IDRISI, MapInfo, AutoCAD (GIS-related), open-source options exist.

### Remote sensing in farm **[3]**

- Farmer eyeing leaf color without touching plant = primitive RS. 
- Modern: digital imagery + GIS for crop stress, management zones. 
- Pairs with GPS waypoints and yield maps.

### GPS + GIS in agriculture (precision farming) **[6]**

Precision / site-specific farming needs **GPS + GIS** (PDF typo “CPS” = **GPS**).

| Use | What happens |
|-----|----------------|
| **Tractor guidance** | Record path; repeat for cultivate / fertilize / harvest |
| **Crop-duster targeting** | Mark pest hotspots; spray only those zones |
| **Livestock tracking** | Collar transmitters. Track animals to market. |
| **Soil sampling** | Waypoint samples. Plot lab results on the map. Treat only needy zones. |
| **Yield monitoring** | Zone yields on a map. Plan the next season. |

**Hack:** **T-C-L-S-Y** — Tractor, Crop-duster, Livestock, Soil sample, Yield.

### Gotchas

- GIS is **not** only maps. Analysis and query are the exam point. 
- Attribute without location is a normal database. GIS **requires** a spatial link. 
- Raster is not photo only. Any grid (soil grid, NDVI) is raster. 
- The source PDF can print “CPS”. Write **GPS** in the answer.

### Expected Qs

1. **[1]** Define GIS / remote sensing / spatial data. 
2. **[1]** Five Ms of GIS. 
3. **[3]** Components of GIS. 
4. **[3]** Raster vs vector. 
5. **[6]** Applications of GIS and GPS in agriculture / precision farming. 
6. **[6]** Concept, components and uses of geospatial technology in DSS context.

---

## E. Decision Support System (DSS) **[3–6]**

### First principle

DSS = interactive computer system that helps a person use **data + models + knowledge + communication** to **structure a decision**. It does not replace the decision maker.

### Three core architecture parts **[1–3]**

1. **Database / knowledge base** 
2. **Model** (decision context + criteria) 
3. **User interface** 
(+ user as part of the system)

### DSS types **[3]** (memorize order)

| Type | Emphasizes |
|------|------------|
| **Model-driven** | Optimization / simulation models; few parameters from user |
| **Data-driven** | Time-series internal/external data; queries (Walmart-scale example in notes) |
| **Communication-driven** | Groupware, video conference, boards |
| **Document-driven** | Policies, catalogs, scanned docs retrieval |
| **Knowledge-driven** | Expert-like recommend actions (AI / expert systems) |

**Mnemonic:** **M-D-C-D-K** — Model, Data, Comm, Document, Knowledge.

### Decision phases (Early framework) **[1–3]**

**Intelligence → Design → Choice → Implementation** 
(search problem → invent options → pick → adopt)

### Tools under DSS umbrella **[1]**

OLAP / multi-dimensional analysis · Query tools · Data mining · also GIS, EIS, Expert Systems, group DSS.

### When to build **[3]** (checklist style)

Domain bounded? Human expert willing? Knowledge mainly heuristic? Conventional program not enough? Need/desire for expert-style help?

### Agri example **[1–3]**

**DSSAT** (USAID support era): rapid assessment of production systems for farm and policy decisions. Precision agriculture = decisions tailored to **parts of fields**, not whole-farm only. Forest management also heavy DSS user.

### Expected Qs

1. **[1]** Define DSS. 
2. **[3]** Components of DSS. 
3. **[3]** Types of DSS with examples. 
4. **[6]** DSS in agriculture and precision farming / DSSAT.

---

## F. Agriculture expert systems & Soil Information Systems **[3–6]**

### First principle

**Expert system** = program that solves problems by **mimicking expert reasoning** (rules, experience, logic) — not only number-crunching formulas. Needed because farm problems are often **qualitative** and multi-discipline.

### Expert system building blocks **[3]**

User interface · Database · **Knowledge base** · **Inference mechanism**

**Dev phases:** problem select → knowledge acquire → represent → program → test/evaluate.

### Why farming needs them **[3]**

Yield loss, erosion, crop choice, pesticide cost/resistance, price pressure, strategy barriers — one farmer cannot be expert in pathology + entomology + meteorology at once. ES integrates those into day-to-day advice.

### Soil Information System (SIS) **[3]**

High-resolution soil + topography maps via sensors + geo-processing. Characterizes physical/chemical soil and how inputs move. Supports irrigation, drainage, fertility by **zone**, not average field.

### Benefits (farmers) **[3]**

Better decisions when specialist absent · higher profit via input save · sustainability (less runoff) · training tool for new staff.

### Name 4 web ES + 4 mobile **[3]**

**Web / portals:** Maize Agri Daksh (IASRI) · Wheat ES (IASRI) · mKisan · RICE Doctor (IRRI) · TNAU AgriTECH · Rice Knowledge Management Portal 

**Mobile:** Crop insurance app (MoA) · AgriMarket · mKisan · IFFCO Kisan · eSAP · Mandi trades 

### Expected Qs

1. **[1]** Define expert system / SIS. 
2. **[3]** Components of an expert system. 
3. **[3]** Importance of expert systems in agriculture. 
4. **[6]** Expert systems and soil information systems for farm decisions (with examples).

---

## G. Last-hour answer skeletons (copy structure)

### Skeleton **[6]** — GIS and GPS in agriculture

1. Def GIS + GPS (3 lines). 
2. Precision farming link (1 line). 
3. Five uses T-C-L-S-Y with one sentence each. 
4. One limit (cost/skill/data quality) + conclusion.

### Skeleton **[6]** — Crop simulation models

1. Def model + simulation. 
2. Why needed (4 bullets). 
3. Empirical vs mechanistic (table). 
4. Inputs W-C-S-M (+ rice transplant gotcha). 
5. Uses + one limitation.

### Skeleton **[6]** — Computer-controlled devices / VRA stack

1. Precision idea. 
2. Sensor → seed system → geospatial → VRA → irrigation. 
3. One worked flow: soil map + GPS → VRA fertilizer. 
4. Limit: bad map → bad rate.

### Skeleton **[6]** — DSS / Expert system

1. Define DSS vs ES. DSS is a wider toolkit. ES uses knowledge base plus inference. 
2. Architecture parts. 
3. Types or components. 
4. Agri examples (DSSAT, IFFCO or mKisan class tools, SIS). 
5. Close with decision quality and sustainability.

---

## H. Rapid flash — 40-second drills

| Cue | Answer |
|-----|--------|
| PHM golden rule | Quality not improved after harvest — only maintained |
| eNAM implementer | SFAC under MoA&FW |
| AgriMarket radius | 50 km GPS |
| Five Ms | Map Measure Monitor Model Manage |
| DSS core 3 | DB · Model · UI |
| DSS phases | Intelligence Design Choice Implementation |
| Model types | Empirical vs Mechanistic |
| Rice model start | Transplant date |
| Raster | Grid cells |
| Vector | Point line polygon |
| ES core | Knowledge base + inference |
| VRA | Rate by location/quality |
| Sensor | Stimulus → distinctive signal |
| RML | Reuters Market Light SMS |

---

## I. Exam gotchas (lose marks if you mix these)

1. **GIS vs GPS vs RS** — GPS locates. RS senses at a distance. GIS analyzes layers. 
2. **Model vs simulation** — model is structure. Simulation is the run of that structure. 
3. **Native vs web app** — native = platform-specific install. Web = browser. 
4. **Attribute ≠ spatial** — GIS needs both. 
5. **eNAM ≠ Rythu Bazar** — eNAM is the national electronic APMC network. Rythu Bazar is a local fresh market app. 
6. **Expert system ≠ spreadsheet** — ES uses inference and knowledge. It is not only formulas. 
7. Spelling traps: **geospatial**, **phenology**, **inference**, **APMC**, **SFAC**.

---

## J. 15-minute pre-exam order

1. Write PHM rule + eNAM + Five Ms + raster/vector from memory. 
2. Sketch S-M-A-A map once. 
3. Recite T-C-L-S-Y and W-C-S-M. 
4. Open answer with definition + one agri example — examiners scan first 5 lines.

**Source scope:** Your provided PDF unit on computer-controlled inputs, models, apps, GIS/RS/GPS, DSS, expert systems & SIS. Align wording with class handouts if teacher used different lists.


---

## K. Core questions (answered in body)

1. What is the farm ICT chain? → S-M-A-A (Sense Model Advise Act). 
2. What is VRA? → Rate of input by location or field quality. 
3. What data does a crop model need? → Weather, Crop, Soil, Management (W-C-S-M). 
4. What is the postharvest rule? → Quality cannot improve after harvest. Only maintain it. 
5. What is GIS vs GPS vs RS? → Analyze layers vs locate vs sense without contact. 
6. What is a DSS? → Interactive aid for decisions with data, models, and interface. 
7. What is an expert system? → Program that mimics expert inference with a knowledge base.
