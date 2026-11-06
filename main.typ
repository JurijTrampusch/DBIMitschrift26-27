#set document(title: "DBI Mitschrift – Graphen, JSON & NoSQL")
#set page(paper: "a4", margin: 2cm, numbering: "1")
#set text(lang: "de", size: 11pt)
#set heading(numbering: "1.")

#let merke(body) = block(
  width: 100%,
  inset: 10pt,
  radius: 4pt,
  fill: rgb("#fff4d6"),
  stroke: (left: 3pt + rgb("#e0a800")),
)[*Prüfungsrelevant:* #body]

#let info(body) = block(
  width: 100%,
  inset: 10pt,
  radius: 4pt,
  fill: rgb("#e8f1fb"),
  stroke: (left: 3pt + rgb("#3a7bd5")),
)[*Ergänzung:* #body]

#align(center)[
  #text(18pt, weight: "bold")[DBI Mitschrift]\
  #text(13pt)[Graphen, JSON & SQL vs. NoSQL]
]

#outline(depth: 2)

= Grundbegriffe

/ Entität: Ein konkretes Objekt, z.B. _Jurij_ ist eine Entität vom Entitätstyp _Schüler_.
/ Entitätstyp: Die Kategorie / Klasse von Entitäten, z.B. _Schüler_.
/ Attribut: Eigenschaft einer einzelnen Entität (z.B. Name, Einwohnerzahl).
/ Beziehung (Kante): Verbindung zwischen zwei Entitäten. Auch Beziehungen können Werte (Attribute) haben.

In einem Graphen sind die Entitäten die *Knoten* (Nodes), die Beziehungen die *Kanten* (Edges).

*Wichtig:* Entitäten stehen in Beziehung zu anderen Entitäten -- aber *nicht alle* zueinander.

== Beispiel: Städte

```
             60 km
   Wien ─────────────── St. Pölten
    │
    │ 50 km
    │
Wiener Neustadt
```

- Knoten: Wien, St. Pölten, Wiener Neustadt (mit eigenen Attributen, z.B. Einwohnerzahl)
- Kanten: Straßenverbindungen mit dem Wert _Distanz_ (ein Graph mit Kantenwerten heißt *gewichteter Graph*)

= Gerichtete und ungerichtete Graphen

#merke[Unterschied zwischen gerichteten und ungerichteten Graphen.]

/ Ungerichtet: Die Beziehung gilt in beide Richtungen gleich.\
  Beispiel: Die Distanz Wien → St. Pölten ist dieselbe wie St. Pölten → Wien.
/ Gerichtet: Die Beziehung hat eine Richtung, der Wert kann je Richtung verschieden sein.\
  Beispiel: „Wer eine Switch kauft, kauft auch einen Controller“ hat einen anderen Wert als „Wer einen Controller kauft, kauft auch eine Switch“.

= Anwendung: Ähnlichkeiten erkennen

Graphen zeigen Ähnlichkeiten bzw. Zusammenhänge, z.B. bei Amazon: _Welche Produkte werden zusammen gekauft?_ (Empfehlungssysteme)

== Beispiel: Nintendo Switch

- Wer eine Switch kauft, kauft oft auch ein *Spiel* und einen *Controller*.
- Über zwei Schritte (Switch → Controller/Spiel → …) kommt man z.B. zu *Transportboxen*.
- Die Kanten tragen einen Faktor, z.B.: von 1000 Switch-Käufern kaufen 900 auch ein Spiel (900 / 1000 = 0,9).
- Da der Faktor von der Ausgangsseite abhängt, ist dieser Graph *gerichtet*.

#figure(
  image("img/20261020_graphen.jpeg", width: 90%),
  caption: [Distanzen zwischen Entitäten (Städte) und Kaufbeziehungen bei einer Verkaufswebsite],
)

= Technologien

- *Graphdatenbanken* (z.B. Neo4j) speichern Daten direkt als Knoten und Kanten.
- Vorteil: Beziehungen über mehrere Schritte („Freunde von Freunden“, „Kunden kauften auch …“) lassen sich schnell abfragen -- in SQL bräuchte man dafür viele Joins.

#info[Neo4j verwendet die Abfragesprache *Cypher*, z.B.
  ```
  MATCH (:Produkt {name: "Switch"})-[:GEKAUFT_MIT]->(p) RETURN p
  ```
]

#pagebreak()

#align(center)[
  #text(13pt, weight: "bold")[20.10.2026 -- JSON, SQL vs. NoSQL & Projekt]
]

= Allgemeines

- Prüfung (Niklas) am Papier -- JSON-Dokumente werden auf dem Blatt Papier geschrieben
- Themen: relationale Datenbanken und NoSQL
- Voraussetzung: grobe DB-Kenntnisse (ER-Modell, SQL)

= JSON & dokumentorientierte Datenbanken

== JSON-Grundlagen

JSON (_JavaScript Object Notation_) speichert Daten als Schlüssel-Wert-Paare.

- `{ }` → *Objekt* (Schlüssel-Wert-Paare, z.B. `{ "name": "Neil" }`)
- `[ ]` → *Array* (Liste von Werten)
- `[{ }]` → Array von eingebetteten Objekten (z.B. mehrere Schuljahre eines Schülers)
- Datentypen: String, Zahl, Boolean, `null`, Objekt, Array

#info[In MongoDB entspricht ein JSON-Dokument einer Zeile, eine *Collection* einer Tabelle:

  #table(
    columns: (1fr, 1fr),
    table.header([*Relational (SQL)*], [*MongoDB (NoSQL)*]),
    [Tabelle], [Collection],
    [Zeile / Datensatz], [Dokument],
    [Spalte], [Feld],
    [Primärschlüssel], [`_id`],
    [Join], [Einbetten (bzw. `$lookup`)],
  )
]

== Beispiel: Religionsanmeldung

Simples DB-Model fürs Anmelden zum Religionsunterricht:

#figure(
  image("img/20261020_reli_dbmodell.png", width: 50%),
  caption: [DB-Model Religionsanmeldung],
)

=== Variante 1: Pro Schüler ein Dokument

```js
db.RelJeSchueler.insertOne({
  name: "Gundi",
  RelBezeichnung: "…",
  Schuljahre: [
    { Schuljahr: "26/27", gewaehlterUnterricht: "…", Klasse: "…" }
  ]
})
```

=== Variante 2: Pro Religion ein Dokument

Collection `SchuelerJeReligion` (die Religion dient als `_id`):

```js
db.SchuelerJeReligion.insertOne({
  _id: "…",            // Religion
  Schuljahr: "26/27",
  Schueler: [{
    id: …,
    schuelerfirstname: "…",
    schuelerlastname: "…",
    note: …            // eher ungünstig, siehe unten
  }],
  Lehrer: [{
    id: …,
    lehrername: "…"
  }]
})
```

Für jede Religion wird eine Liste an Schülern und eine Liste von Lehrern gespeichert, welche dieses Fach unterrichten.
Für die *Historisierung* wird zusätzlich das Schuljahr gespeichert.

#info[Warum ist `note` im Schüler-Array ungünstig? Das Dokument wächst mit jedem Schüler; um eine einzelne Note zu ändern, muss im Array gesucht werden. Daten, die sich oft einzeln ändern, besser in eigenen Dokumenten speichern.]

#merke[Ein DB-Model (ER-Modell) in JSON-Dokumente umwandeln können. Entscheidend ist, *wovon man ausgeht* (Schüler oder Religion) -- danach richtet sich, was eingebettet wird. Zusammengehörende Daten, die gemeinsam gelesen werden, werden *eingebettet* statt per Join verknüpft.]

== CAP-Theorem

Ein verteiltes System kann von den folgenden drei Eigenschaften nur *zwei gleichzeitig* garantieren:

/ C -- Consistency: Alle Knoten sehen zur selben Zeit dieselben Daten.
/ A -- Availability: Jede Anfrage bekommt eine Antwort.
/ P -- Partition Tolerance: Das System funktioniert weiter, auch wenn die Verbindung zwischen Knoten ausfällt.

#info[Da Netzwerkausfälle in verteilten Systemen nie ganz auszuschließen sind, muss man in der Praxis meist zwischen *CP* (z.B. MongoDB) und *AP* (z.B. Cassandra) wählen. Klassische relationale DBs auf einem Server gelten als *CA*.]

= CRUD: SQL vs. NoSQL

CRUD -- *C*reate, *R*ead, *U*pdate, *D*elete

#table(
  columns: (auto, 1fr, 1.5fr),
  align: left,
  table.header([], [*SQL*], [*NoSQL*]),
  [C], [Langsam (Constraints, Indizes, Fremdschlüssel prüfen)], [Sehr schnell (kein festes Schema)],
  [R], [Schnell], [Langsamer -- bei kleinen Datenmengen aber sogar schneller als SQL, weil der Join wegfällt],
  [U], [Mit Filter schnell \ Ohne Filter mittelschnell], [Mit Filter langsam \ Ohne Filter eher schnell],
  [D], [Mit Filter langsam \ Ohne Filter langsam], [Mit Filter mittel \ Ohne Filter schnell -- sehr schnell],
)

_Wir löschen alle Datensätze -- warum braucht das bei SQL einen zweiten Prozess?_\
→ Es müssen *Abhängigkeiten* (Fremdschlüssel, referentielle Integrität) geprüft werden.

Eine relationale DB hat eine *DDL* (_Data Definition Language_: `CREATE`, `ALTER`, `DROP`) -- das Schema wird vorher festgelegt. NoSQL-Datenbanken sind meist *schemalos*: Dokumente einer Collection können unterschiedlich aufgebaut sein.

= Schätzung Supermarkt

Wie viele Datensätze und Operationen gibt es?

#table(
  columns: (auto, 1fr, 1fr),
  align: left,
  table.header([*Entität*], [*Datensätze*], [*Änderungen*]),
  [Filialen], [\~1.000], [\~10 neue pro Jahr],
  [Produkte], [\~40.000], [\~1.000 neue pro Jahr, bis zu 2 Mio. Operationen pro Jahr (z.B. Preisänderungen)],
  [Rechnungen], [\~10.000.000 pro Tag (Anzahl Einkäufe)], [laufend neue],
  [Positionen], [min. 5 pro Rechnung → \~50.000.000 pro Tag], [laufend neue],
)

- Filialen und Produkte ändern sich selten, werden aber ständig gelesen → *leselastig* → relationale DB gut geeignet.
- Rechnungen und Positionen entstehen in riesiger Zahl → *create-lastig* → hier spielt NoSQL seine Stärke beim Einfügen aus.
- Für Auswertungen (Umsatz, Statistiken) werden die Positionen anschließend viel gelesen.

#merke[
  - Beurteilen, ob ein Prozess *leselastig* oder *create-lastig* ist, und begründet empfehlen, welche DB man verwendet.
  - Die Mengen (Datensätze, Operationen) aus dem ER-Modell bzw. der Angabe abschätzen.
]

= Projekt

- Zweiergruppen
- Theoretische Grundlage vorausgesetzt (wird praktisch nicht unterrichtet)
- 4 Tabellen (1 Lookup-Tabelle und 2--3 Kreuztabellen)
- Neben der relationalen Schicht ein zweiter Ast, der auf eine NoSQL-Datenbank (MongoDB) geht
- Mit 3 verschiedenen Datenmengen (klein, mittel, groß -- groß soll mindestens 1 Minute dauern) die Laufzeiten der CRUD-Operationen beider Systeme vergleichen

*3. Dezember 2026:* Abgabe und Abgabegespräche (bei späterer Abgabe gibt es Punkteabzug)
