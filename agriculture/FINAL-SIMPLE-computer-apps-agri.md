# Computer Applications in Agriculture  
## Super simple notes (first time learner)

Read slowly. Every idea is explained like you never heard it before.  
At the end of each part you get **easy exam points** to remember.

**Exam tip:**  
- **1 mark** = write the short definition  
- **3 marks** = definition + 3 or 4 points  
- **6 marks** = definition + explain parts + farm use + one limit  

---

# Part 0 — What is this subject about?

## Story

Think of a big farm field.  
One side of the field is dry.  
Another side has more fertilizer already in the soil.  
Insects attack only one corner.

**Old way:** The farmer treats the **whole field the same**.  
Same seed amount. Same fertilizer. Same spray. Same water.  

This wastes money.  
It also fails the plants that need something different.

**New way (this subject):**  
Use computers, phones, sensors, and maps so the farmer can give  
**the right thing, in the right amount, in the right place, at the right time.**

That idea is called **precision farming** (or site-specific farming).

## Four steps (remember this forever)

1. **SENSE** — measure what is happening in the field  
2. **MODEL** — use software to guess what will grow if we do X  
3. **ADVISE** — apps and systems tell the farmer what to do  
4. **ACT** — machines apply seed, fertilizer, spray, or water correctly  

Short memory word: **S-M-A-A**  
Sense → Model → Advise → Act  

Maps sit in the middle. A system called **GIS** stores those maps.

You do not need to be a computer engineer.  
You only need to know **what each tool is** and **why a farmer uses it**.

---

# Part 1 — Computer-controlled devices on the farm

## What does “computer-controlled” mean?

A machine is computer-controlled when:

1. Something is **measured** (by a sensor)  
2. A **computer reads** that measurement  
3. The machine **changes what it does** because of that information  

**Easy life examples (not farm, but same idea):**

- A **robot** follows a program to move and pick things.  
- An **ATM** is a computer that checks your bank account and gives cash.  

On a farm, the same idea runs planters, sprayers, and irrigation pumps.

---

## 1. Sensor

### Explanation

A **sensor** is a small device that “feels” something in the world and turns it into a signal the computer can understand.

Examples of things sensors can feel:

- heat (temperature)  
- light  
- pressure  
- moisture in soil  

**Farm use:**  
Sensors are used in greenhouses, polyhouses (protected cultivation), and precision farming.  
They watch the crop or climate when a person cannot stand there all day.

**Barcode example (from your notes):**  
A barcode is black and white lines on a product.  
A scanner shines light on it and reads the code.  
This only works if nothing blocks the light.  
That rule is called **line of sight**.

### Easy cram points

- Sensor = device that receives a stimulus and gives a useful response  
- Used in greenhouse, polyhouse, precision farming  
- Barcode scanner needs line of sight  
- Sensor collects data. It is not a map system by itself  

### Exam line (1 mark)

A sensor is a device that receives a signal such as heat, light, or pressure and responds in a way a computer can use.

---

## 2. Seed planting system

### Explanation

If seeds are too close, plants fight for food and light.  
If seeds are too far, land is wasted.

A **computer-controlled seed planter** tries to place seeds at a good distance.

How it works in simple steps:

1. A planter moves across the field (pulled by a tractor or self-driven).  
2. Metal parts called **planting shoes** put seeds into the soil.  
3. Sensors near the shoes notice each time a seed is planted.  
4. The computer uses those signals to control **spacing** (distance between seeds).

### Easy cram points

- Goal = optimal seed spacing  
- Planting shoes put seed in soil  
- Sensors detect planting events  
- Computer controls spacing  

### Exam line (3 marks)

Write: definition of seed planting system + shoes + sensors + computer spacing control.

---

## 3. Geospatial locator

### Explanation

**Geo** means Earth.  
**Spatial** means space or place.  
So **geospatial** means “linked to a place on Earth.”

A **geospatial locator** finds the place of each planted seed (using location signals, often GPS style).  
It sends that place to the computer.

The computer joins:

- “a seed was planted”  
- “at this exact place”  

This makes a **seed distribution profile**.  
That is a map showing where seeds went.  
It helps control spacing and later management.

### Easy cram points

- Geospatial = linked to location on Earth  
- Locator records place of each seed  
- Computer makes seed distribution profile  
- Helps control seed spacing  

---

## 4. Variable Rate Application (VRA)

### Explanation

Normally a fertilizer machine throws the **same amount everywhere**.  
But one part of the field may need more nitrogen. Another part may need less.

**Variable Rate Application** means the machine changes the amount of material  
based on **where it is** or **how good that part of the field is**.

Materials can be:

- seed  
- fertilizer  
- pesticide  
- lime  

**Picture in your head:**  
The tractor moves.  
Zone A opens the fertilizer door more.  
Zone B opens it less.  
That is VRA.

VRA needs location information and a quality map or sensor data.  
Without that, it is only a normal sprayer.

Machines mentioned in notes:

- computer or controller  
- liquid sprayers  
- granular fertilizer applicators  
- air sprayers and spreaders  
- drills and planters  

### Easy cram points

- VRA = rate of input changes with location or field quality  
- Opposite of uniform (same) application  
- Needs map or sensor + GPS + controller  
- Saves money and chemicals when used well  

### Exam line (3 or 6 marks)

Define VRA.  
Explain why uniform application is wasteful.  
Give farm example.  
List equipment types.  
Write one limit: bad map gives bad rate.

---

## 5. Irrigation system (computer linked)

### Explanation

Water is also an input, like fertilizer.  
Some soil is wet. Some is dry.

A computer-linked irrigation system uses sensors, schedules, or maps  
to decide **when** and **how much** to water.  
Goal is the same precision idea: do not flood one corner and dry another.

### Easy cram points

- Computer helps decide water timing and amount  
- Links to sensors and maps  
- Same idea as VRA, but for water  

---

## Part 1 memory list (five devices)

Remember: **S-S-G-V-I**

1. Sensor  
2. Seed planting system  
3. Geospatial locator  
4. Variable Rate Application  
5. Irrigation system  

**6 mark order:**  
Precision farming idea → list five with one line each → one full example of VRA → one limit.

---

# Part 2 — Computer models and crop simulation

## Why do we need models?

Real farm experiments take months or years.  
You cannot test 50 weather years in one week in the field.

Scientists put their knowledge into a **computer model**.  
Then the computer runs many “what if” questions quickly.

Example question a model can help with:  
“If rain is late this year, what happens to yield of this variety?”

---

## Three words you must not mix

### System

The real thing: crop + soil + weather + farmer actions together.

### Model

A **simple copy** of that system inside the computer.  
Often written as math rules.

**Definition:** A model is a simplified representation of a system or process.

### Simulation

**Running** the model over time with data to see results.

**Definition:** Simulation is the process of building models and analyzing the system with them.

**Simple picture:**  
Model = toy map of a city.  
Simulation = moving toy cars on that map to see traffic.

---

## What is a crop model?

A **crop model** is a simple computer picture of how a crop grows  
when it meets weather, soil, and farmer management.

It can estimate:

- when the crop flowers and matures  
- how much green growth it makes  
- final yield  
- water and nutrient use  

---

## Why simulation models are useful (4 points)

1. They store knowledge from many field trials in one place.  
2. They help different experts work together (soil, weather, crop).  
3. They support systems thinking on complex farm problems.  
4. They give numbers that change over time (dynamic tools).  

---

## Two types of crop growth models

### Type A — Empirical (regression) models

These fit a mathematical curve to past growth data.  
Examples of curve styles: Richards function, polynomials.

**Good:** simple and fast.  
**Weak:** they describe the pattern but do not fully explain plant biology.  
They can fail if conditions are new and outside past data.

### Type B — Mechanistic models

These build growth from plant processes  
(like photosynthesis, water use, nitrogen use)  
linked to the environment.

**Good:** they explain “why” growth changes.  
**Weak:** they need more data and skill.

**Memory:**  
Empirical = fitted graph.  
Mechanistic = mini plant science inside software.

---

## What data does a crop model need?

Think of four big bags of data: **W-C-S-M**

### Weather (usually every day)

- maximum temperature  
- minimum temperature  
- rainfall  
- relative humidity  
- solar radiation  
- wind speed  

Why daily? Because growth is calculated day by day.

### Crop

- crop name  
- variety name  
- phenology (timing of life stages: days to flowering, days to maturity)  
- leaf area index (how much leaf covers the ground)  
- biomass and grain yield information  
- 1000-grain weight  

**Phenology** means the calendar of plant life stages.

### Soil

- thickness of soil layers  
- pH, EC  
- N, P, K  
- soil organic carbon  
- texture, sand %, clay %  
- moisture, saturation  
- field capacity and wilting point  
- bulk density  

These control water and food available to roots.

### Management (what the farmer does)

- date of sowing (start of simulation in most crops)  
- for **transplanted rice**, use **transplanting date**, not nursery sowing date  
- seed rate and depth  
- irrigation: how much, when, where placed  
- fertilizer and manure: type, amount, date, depth  
- crop residue  
- if organic material is used, **C:N ratio** (carbon to nitrogen balance)  

Sometimes insect and pest data is also used.

---

## Uses of crop models

**On the farm:**

- help decide fertilizer, irrigation, pesticide before and during season  

**For government and policy:**

- soil erosion risk  
- chemical leaching into water  
- climate change effects  
- yield forecasts over large areas  

---

## Limits (always write one for full marks)

- wrong weather data → wrong answer  
- wrong variety settings → wrong yield  
- weak pest representation in simple models  
- bad input data → bad output  

---

## Part 2 easy cram points

- Model = simplified representation of a system  
- Simulation = run the model and analyze results  
- Two types = empirical and mechanistic  
- Inputs = Weather, Crop, Soil, Management (W-C-S-M)  
- Rice special rule = use transplant date  
- Uses = farm decisions + policy forecasts  
- Limit = garbage in, garbage out  

---

# Part 3 — Smartphone apps, markets, postharvest

## What is a mobile app?

A **mobile app** is a software program made for a phone or tablet,  
not for a normal desktop computer.

Apps can come already on the phone,  
or the user can download them from an app store or internet.

Your syllabus talks about apps for:

- agriculture  
- horticulture  
- animal husbandry  
- farm machinery  

Notes also say some popular Indian agri apps were developed by groups like **Jayalaxmiagrotech**.

---

## Why phones help farmers

Many farmers live far from agriculture offices.  
A phone can bring advice to the field.

Help comes from:

- mobile phones  
- cloud computing (data and software on internet servers)  
- online learning  
- integrated IT systems  

Benefits:

- better land decisions (soil + weather together)  
- smarter use of fertilizer, seed, and water  
- save money and reduce waste  

**RML (Reuters Market Light):**  
A paid **SMS** service (text messages) for local prices, crop tips, and weather.  
It is important even though it is SMS, not only a smartphone app.

---

## Three types of apps

### Native app

Built for one system only, such as Android or iPhone.  
It can use the phone’s camera, GPS, and other features well.

### Hybrid app

Part native and part web.  
A mix of both styles.

### Web app

Stored on an internet server.  
You open it in a browser.  
You usually do not install a full special program.

---

## Apps for farm advice (remember job of each)

You do not need perfect download numbers.  
You need **one clear job** per app.

**AgriApp**  
Online market place for farm needs.  
Chat with experts.  
Farming videos.

**IFFCO Kisan**  
Weather.  
Market rates.  
Farm advice.  
Many Indian languages.  
Farmers can ask experts questions.  
Service family in notes: agro IT, call centre, commodity services, rural distribution, and more.

**Agri Media Video App**  
Lots of farming videos.  
Chat with experts.  
Can upload photo of a sick crop.

**Farm-Bee / RML Farmer**  
Helps through the full crop life cycle.  
Many crop varieties, markets, and weather points.  
Notes give rough numbers: about 450 crops, 1300 markets, 3500 weather locations.

**KisanYojana**  
Shows government schemes for farmers.  
Saves time and travel to government offices.

**Smart Krishi**  
Package of practices (how to grow crops step by step).  
Success and failure stories.  
Library of local herbs and fruits.  
Farm contacts with GPS.  
Daily tips.  
Weather information.

---

## Apps for market prices

### AgriMarket

Shows prices of crops in markets within about **50 km** of your phone location.  
Uses GPS.  
You can also choose market and crop by hand.

### eNAM (very important)

**Problem:** India has many local mandis (APMC markets).  
Rules and prices differ. Farmers may not see the best buyer.

**eNAM** means **National Agriculture Market**.  
It is an all-India electronic trading website and system.  
It connects existing APMC mandis so trading can be more open and unified.

**Who runs the project idea:**  
**SFAC** (Small Farmers Agribusiness Consortium)  
under the Ministry of Agriculture and Farmers’ Welfare.

**What it tries to do:**

- same clearer procedures across markets  
- less hidden information between buyer and seller  
- real-time price discovery (price based on real demand and supply)  
- transparent auction based on quality  
- online payment path  

**Extra facts often asked:**

- more than **90** commodities listed  
- mobile app in **8** languages  
- first mostly trade inside one market  
- later phases aim at trade between markets and states  

### Rythu Bazar App

For local vegetable and fruit market prices.  
Helps find a nearby Rythu Bazar.

### Mandi app

Live mandi prices.  
Zone-wise market list.  
Daily updates.  
Language options.

### AGMARKNET

**Agricultural Marketing Information Network.**  
Started in **March 2000** by the Union Ministry of Agriculture.  
It is a base system for agricultural market information.  
Link this name when you talk about mandi price apps.

---

## Postharvest management

**Postharvest** means everything after the crop is cut or picked.

### Golden rule (learn word for word)

> Quality cannot be improved after harvest but maintained.

### What this means in simple words

Once the tomato is picked, you cannot make a bad tomato become excellent.  
You can only **protect** the quality it already has.

So:

1. Harvest only good produce for market.  
2. Poor quality already dies faster after harvest.  
3. After harvest: cool, clean, sort, and pack carefully.  
4. Good farming before harvest still matters a lot.

**CHEETAH app (example in notes):**  
Helps with postharvest loss problems in trade chains, including border movement ideas in Africa.

**Numbers in your PDF (for 1 mark bait):**

- Africa postharvest food losses about **48 billion dollars** a year  
- about **33 percent** of world food production is lost  
- bruised produce rejected in market can mean about **30 percent** loss for the farmer in the example  

---

## Part 3 easy cram points

- Mobile app = software for phone or tablet  
- Types = native, hybrid, web  
- RML = SMS prices, crop tips, weather  
- AgriMarket = prices within 50 km  
- eNAM = national electronic market linking APMC mandis  
- SFAC implements eNAM  
- AGMARKNET launched March 2000  
- Postharvest rule = quality not improved after harvest, only maintained  
- After harvest jobs = cool, clean, sort, pack  

**Memory for app names:** A-I-F-K-E  
AgriApp, IFFCO, FarmBee, KisanYojana, eNAM  

---

# Part 4 — GIS, remote sensing, and GPS

This part confuses students.  
Learn three tools as three different questions.

## Three tools in one breath

**GPS answers:** Where is this point?  
**Remote sensing answers:** What does this area look like from far away?  
**GIS answers:** How do I store, combine, and study all place-based information?

Farm picture:

- GPS = “I am in the north corner of field 3.”  
- Remote sensing = “That corner looks yellow and dry in the satellite image.”  
- GIS = “Put soil map + yield map + weed map on one screen and decide treatment.”  

---

## What is GIS?

**GIS** means **Geographic Information System**.

### Explanation

A GIS is a computer system that works with information about **places on Earth**.

A normal school mark list can say “Ravi scored 80.”  
It does not need a map.

A GIS can say “this field polygon has soil type X and yield Y.”  
Every fact is tied to a **location**.

### Good exam definition

A geographic information system is a computer system that captures, stores, checks, combines, analyzes, and displays information linked to locations on the Earth.

Another full definition used in notes (ESRI style):  
GIS is an organized set of hardware, software, geographic data, and people that handle geographically referenced information.

---

## Two kinds of data inside GIS

### Spatial data

This is the **where**.  
Examples: a point for a well, a line for a canal, a shape for a field.

### Attribute data

This is the **what**.  
Examples: crop name, owner name, yield, soil class.

GIS is strong because it joins **where** and **what**.

---

## How places are drawn in the computer

**Point**  
Only a position. Example: a tube well.

**Line**  
Has length. Example: a road or canal.

**Area (polygon)**  
Has length and width. Example: a field or village boundary.

**Surface**  
Values everywhere. Example: elevation or temperature across land.

---

## Raster and vector (must understand)

### Raster

The map is broken into many small squares (cells or pixels), like a chessboard.  
Each square has a value.

Good for continuous things such as:

- elevation  
- temperature  
- greenness of crop from satellite  

### Vector

The map uses shapes:

- points  
- lines  
- polygons  

Good for clear boundaries such as:

- farm plots  
- roads  
- canals  

### Extra model words

**Objects** = separate things with edges (a building, a road).  
**Fields** = a value at every place (every point has elevation).  
**TIN** = a triangle network used for some continuous surfaces.  
**Object-oriented model** = computer stores real-world objects, not only pure geometry.  
**Data model** = the planned way data is organized in the system.  
**Geodatabase** = one box that stores spatial and non-spatial data together, with rules to keep data clean.

---

## Parts of a GIS

### Function parts (what GIS does)

1. Data input (bring maps and numbers in)  
2. Storage and retrieval (save and find data)  
3. Analysis (ask questions, make new maps)  
4. Output (print maps and tables)  

### System parts (what GIS is made of)

1. Hardware (computers, GPS, printers)  
2. Software (GIS programs)  
3. Data (maps and attributes)  
4. People (trained users)  

---

## Five Ms of GIS

Remember these five words:

1. Mapping  
2. Measurement  
3. Monitoring  
4. Modeling  
5. Management  

---

## Where GIS is used (outside and inside farm life)

- government and public services  
- business planning  
- transport and logistics  
- environment studies  
- and agriculture / precision farming  

**Geodemographics** means small-area data about people and buying behavior.  
Businesses use it to plan where to open shops. Notes mention this under GIS applications.

**Software names to recognize:**  
ArcGIS, ERDAS IMAGINE, IDRISI, MapInfo, AutoCAD, MicroStation, and more.

---

## What GIS analysis can do (name any five in exam)

- search and retrieve data  
- make buffers (zones around a road or well)  
- overlay two maps on each other  
- measure distance and area  
- network analysis (paths and routes)  
- terrain analysis (slopes and elevation)  
- change map formats and export results  

---

## Remote sensing

### Explanation

**Remote sensing** means measuring something **without touching it**.

If you stand at the field edge and judge plant color with your eyes, that is a simple human form of remote sensing.  
Satellites and aircraft do the same from high above with special cameras and sensors.

In agriculture, most remote sensing uses the **electromagnetic spectrum** (light and related energy bands).  
Sound-based methods also exist in science, but farm notes stress light/EM methods.

### Farm uses

Remote sensing can help find:

- nutrient shortage  
- disease  
- too little or too much water  
- insect damage  
- hail, wind, or herbicide damage  
- plant population differences  

These images can become base maps for **variable rate** fertilizer or pesticide.  
Then the farmer treats only the sick or weak zones.

---

## GPS on the farm

**GPS** means Global Positioning System.  
It tells location using satellites.

**Important:** If your PDF prints “CPS”, write **GPS** in the answer. That is a typing error in some notes.

### Precision farming needs both GPS and GIS

GPS gives location.  
GIS stores and analyzes maps.  
Together they support site-specific farming.

### Five farm uses (learn with story)

**1. Tractor guidance**  
Record the path the tractor drove.  
Later, follow the same path for fertilizer or harvest.  
This reduces missed strips and double work.

**2. Crop-duster targeting**  
Insects are not equal everywhere.  
Workers mark problem spots with GPS.  
Planes or sprayers treat only those spots.  
This saves chemical, fuel, and time.

**3. Livestock tracking**  
Put a GPS tag on valuable animals.  
Know where they are on a large farm.  
Also track animals when sent to market.

**4. Soil sampling**  
Take soil samples at known points.  
Mark each point with GPS.  
When lab results return, put them on the map.  
Treat only the needy zones.

**5. Yield monitoring**  
Divide the field into zones.  
Estimate yield of each zone.  
Map the results.  
Plan next season better.

Also GPS can map field boundaries, roads, irrigation lines, weed patches, and disease spots.

**Memory:** T-C-L-S-Y  
Tractor, Crop-duster, Livestock, Soil sampling, Yield  

---

## Part 4 easy cram points

- GPS = where  
- RS = sense without contact  
- GIS = store and analyze map data  
- GIS needs spatial + attribute data  
- Raster = grid cells  
- Vector = points, lines, polygons  
- GIS parts = input, store, analyze, output  
- Also hardware, software, data, people  
- Five Ms = Map, Measure, Monitor, Model, Manage  
- Precision farming uses GPS + GIS  
- Farm GPS uses = T-C-L-S-Y  

---

# Part 5 — Decision Support System (DSS)

## Everyday idea

Before you irrigate, you open a weather app.  
The app does not open the pump for you.  
It only helps you decide.

That is the heart of a **Decision Support System**.

---

## What is a DSS?

A **DSS** is an interactive computer system that helps a person make decisions.  
It uses data, documents, knowledge, models, and communication tools.

**Interactive** means the user can ask, change options, and see results.

**Very important:**  
A DSS **supports** the decision maker.  
It does not replace the person’s final responsibility.

Other tools often grouped with DSS ideas:

- GIS  
- expert systems  
- OLAP (multi-way data analysis)  
- data mining  
- group tools for teams  

---

## Three main parts of a DSS

1. **Database or knowledge base**  
   Stores facts and knowledge.  

2. **Model**  
   The method used to compare options and judge results.  

3. **User interface**  
   The screen and controls a human uses.  

The user is also part of the system.

---

## Four phases of decision making

1. **Intelligence** — notice that a decision is needed  
2. **Design** — invent possible actions  
3. **Choice** — pick one action  
4. **Implementation** — put the action into real life  

---

## Five types of DSS

**Model-driven DSS**  
Focus on calculation models (optimization or simulation).  
Examples named in notes: Sprinter, MEDIAC, Brandaid.

**Data-driven DSS**  
Focus on large amounts of data over time and searching that data.  
Notes mention very large retail data examples.

**Communication-driven DSS**  
Focus on people working together: video meetings, group software, discussion boards.

**Document-driven DSS**  
Focus on finding and reading documents: policies, catalogs, old reports.

**Knowledge-driven DSS**  
Focus on giving recommendations like an expert.  
Uses expert system and AI ideas.

**Memory:** M-D-C-D-K  
Model, Data, Communication, Document, Knowledge  

---

## Tools often listed under DSS

- multi-dimensional analysis or OLAP  
- query tools (ask questions of data)  
- data mining tools (find hidden patterns)  

---

## Three technology levels

1. **Application** — the finished DSS a manager uses  
2. **Generator** — software environment used to build DSS apps  
   Examples in notes: Crystal, Analytica, iThink  
3. **Tools** — lower level languages and libraries  

---

## Other classification words (if exam asks)

**Holsapple and Whinston** classify DSS into six kinds:

- text-oriented  
- database-oriented  
- spreadsheet-oriented  
- solver-oriented  
- rule-oriented  
- **compound** (mix of two or more; most popular)  

Support can be:

- personal  
- group  
- organizational  

Another simple view of parts:

- inputs  
- user knowledge  
- outputs  
- decisions  

**IDSS** means Intelligent DSS.  
It uses artificial intelligence or software agents.

Notes also give non-farm examples such as medical clinical DSS and railway safety testing in Canada.  
For agriculture answers, prefer farm examples.

---

## Agriculture examples of DSS

**DSSAT** (notes say DSSAT4, with USAID support history)  
Helps assess crop production systems quickly for farm and policy decisions.

**Precision agriculture**  
Uses DSS thinking to tailor decisions to **parts of a field**, not only the whole farm average.

**Forest management**  
Also uses DSS a lot because planning is long and spatial.

**Limits of adoption**  
Cost, skills, and data quality can block use on real farms.

---

## When do people build a DSS?

Ask questions like:

- Can normal programming solve it easily already?  
- Is the problem area clear and limited?  
- Is there a real need?  
- Is there a human expert willing to share knowledge?  
- Can the expert explain the knowledge clearly?  
- Is the knowledge full of experience rules, not only exact formulas?  

---

## Part 5 easy cram points

- DSS = interactive computer help for decisions  
- Supports human. Does not replace human.  
- Parts = database, model, user interface  
- Phases = Intelligence, Design, Choice, Implementation  
- Types = model, data, communication, document, knowledge  
- Agri example = DSSAT and precision farming  
- Levels = application, generator, tools  

---

# Part 6 — Expert systems and Soil Information Systems

## Why expert systems?

Farm problems are mixed:

- disease  
- insects  
- weather  
- soil  
- market prices  

One farmer cannot be a full specialist in all of these every day.  
Also, much farm knowledge is based on experience, not only pure math.

An **expert system** tries to put expert thinking into a computer program.

---

## What is an expert system?

An expert system is a computer program that solves problems by copying the way an expert thinks.  
It uses rules, logic, experience, and knowledge.  
It is different from a normal program that only calculates fixed formulas.

---

## Four building blocks

1. **User interface**  
   How the user asks questions and sees answers.  

2. **Database**  
   Facts about the current case (crop, symptoms, place).  

3. **Knowledge base**  
   Expert rules and knowledge stored in the system.  

4. **Inference mechanism**  
   The engine that applies rules to facts and reaches advice.  

---

## Steps to build an expert system

1. Choose the problem  
2. Collect knowledge from experts  
3. Represent that knowledge in a computer form  
4. Write the program  
5. Test and evaluate  

---

## Soil Information System (SIS)

A **Soil Information System** makes detailed maps of soil and land shape.  
It uses advanced sensors and computer processing.

It helps show:

- physical nature of soil  
- chemical nature of soil  
- how water and inputs move through soil  

Farm advisors use SIS for zone decisions on:

- irrigation  
- drainage  
- fertility  

Not one average treatment for the whole farm.

---

## Benefits for farmers

- better decisions when a human specialist is not nearby  
- better profit by using inputs wisely  
- more sustainable farming with less waste and less runoff  
- training help for new farm workers  

---

## Named examples (for listing in exams)

**Web style systems**

- Maize Agri Daksh (IASRI)  
- Wheat expert system (IASRI)  
- Digital mandi  
- mKisan portal  
- RICE Doctor (IRRI)  
- TNAU AgriTECH portal  
- Barley expert system  
- Rice Knowledge Management Portal  
- Expert system work noted for agriculture and animal husbandry (DWCRA, Bhubaneswar)  

**Mobile examples**

- Crop insurance app (Ministry of Agriculture)  
- AgriMarket  
- mKisan  
- RainbowAgri  
- Manditrades  
- Mpower  
- IFFCO Kisan  
- eSAP  

You do not need all names every time.  
In a 3 mark answer, write 4 clear names with one use each.

---

## Part 6 easy cram points

- Expert system = computer that copies expert reasoning  
- Parts = interface, database, knowledge base, inference engine  
- Needed because farm knowledge is often qualitative and multi-subject  
- SIS = detailed soil and topography information for zone decisions  
- Benefits = better decisions, profit, sustainability, training  

---

# Part 7 — How to write answers

## 1 mark

One clear definition sentence.  
Optional second sentence with one example.

## 3 marks

1. Definition  
2. Three short points  
3. One line on importance  

## 6 marks

1. Introduction and definition  
2. Main parts or types  
3. Agricultural uses with examples  
4. One limitation  
5. One line conclusion  

### Ready 6-mark plans

**GIS and GPS in agriculture**  
Define both.  
Link to precision farming.  
Write five uses: tractor, crop-duster, livestock, soil sampling, yield.  
Write one limit: cost or skill or data quality.  
Close.

**Crop simulation models**  
Define model and simulation.  
Four reasons we need them.  
Empirical vs mechanistic.  
Inputs W-C-S-M and rice transplant note.  
Uses and one limit.

**Computer-controlled devices**  
Precision idea.  
Five devices S-S-G-V-I with one line each.  
Explain VRA with example.  
One limit.

**DSS or expert system**  
Define.  
Main parts.  
Types or phases.  
Agri example (DSSAT, IFFCO class apps, SIS).  
Close with better farm decisions.

---

# Part 8 — Last night flash list

Read this out loud.

1. Precision farming = right input, right amount, right place, right time  
2. S-M-A-A = Sense, Model, Advise, Act  
3. Sensor = feels stimulus, gives useful signal  
4. VRA = rate changes by location or quality  
5. Model = simple copy of system  
6. Simulation = run the model  
7. W-C-S-M = Weather, Crop, Soil, Management  
8. Transplanted rice uses transplant date  
9. Mobile app types = native, hybrid, web  
10. eNAM = national e-market of APMC mandis, SFAC lead  
11. AGMARKNET = March 2000  
12. Postharvest rule = quality not improved after harvest, only maintained  
13. GPS = where  
14. RS = sense without touch  
15. GIS = map data system with location + attributes  
16. Raster = squares  
17. Vector = points, lines, areas  
18. Five Ms = Map, Measure, Monitor, Model, Manage  
19. DSS supports decisions. It does not replace the person  
20. DSS parts = database, model, interface  
21. DSS phases = Intelligence, Design, Choice, Implementation  
22. Expert system = knowledge base + inference  
23. SIS = detailed soil maps for zone decisions  
24. T-C-L-S-Y = Tractor, Crop-duster, Livestock, Soil, Yield  
25. PDF typo CPS means GPS  

---

# Part 9 — Common mistakes

1. Do not say GIS and GPS are the same.  
2. Do not say model and simulation are the same.  
3. Do not say eNAM is only a local vegetable market app.  
4. Do not say expert system is only Excel formulas.  
5. Do not forget line of sight for barcode.  
6. Do not forget rice transplant date in crop models.  
7. Do not write long introductions. Start with definition + farm example.

---

# Part 10 — Tiny self check

Cover the answers. Try first.

1. What does precision farming mean in one line?  
2. What is the difference between GPS and GIS?  
3. Write the postharvest golden rule.  
4. Name the four input groups for crop models.  
5. Name three parts of a DSS.  
6. Name four parts of an expert system.  
7. What is VRA?

**Answers**

1. Right input, right amount, right place, right time.  
2. GPS tells location. GIS stores and analyzes map information.  
3. Quality cannot be improved after harvest but maintained.  
4. Weather, Crop, Soil, Management.  
5. Database or knowledge base, model, user interface.  
6. User interface, database, knowledge base, inference mechanism.  
7. Applying farm inputs at rates that change with place or field quality.

---

You now have the full unit in plain language.  
If one part still feels hard, read only that part twice and rewrite its easy cram points in your own words on paper. That is the fastest way to remember.
