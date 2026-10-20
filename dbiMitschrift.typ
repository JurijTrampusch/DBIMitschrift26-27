#set document(title: "DBI Mitschrift – Graphen & Graphdatenbanken")
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

#align(center)[
  #text(18pt, weight: "bold")[DBI Mitschrift]\
  #text(13pt)[Graphen & Graphdatenbanken]
]

= Grundbegriffe

/ Entität: Ein konkretes Objekt, z.B. _Jurij_ ist eine Entität vom Entitätstyp _Schüler_.
/ Entitätstyp: Die Kategorie / Klasse von Entitäten, z.B. _Schüler_.
/ Attribut: Eigenschaft einer einzelnen Entität (z.B. Name, Einwohnerzahl).
/ Beziehung (Kante): Verbindung zwischen zwei Entitäten. Auch Beziehungen können Werte (Attribute) haben.

In einem Graphen sind die Entitäten die *Knoten* (Nodes), die Beziehungen die *Kanten*.

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

- Knoten: Wien, St. Pölten, Wiener Neustadt (mit eigenen Attributen)
- Kanten: Straßenverbindungen mit dem Wert _Distanz_

= Gerichtete und ungerichtete Graphen

#merke[Unterschied zwischen gerichteten und ungerichteten Graphen.]

/ Ungerichtet: Die Beziehung gilt in beide Richtungen gleich.\
  Beispiel: Die Distanz Wien → St. Pölten ist dieselbe wie St. Pölten → Wien.
/ Gerichtet: Die Beziehung hat eine Richtung, der Wert kann je Richtung verschieden sein.\
  Beispiel: „Wer eine Switch kauft, kauft auch einen Controller“ hat einen anderen Wert als „Wer einen Controller kauft, kauft auch eine Switch“.

= Anwendung: Ähnlichkeiten erkennen

Graphen zeigen Ähnlichkeiten bzw. Zusammenhänge, z.B. bei Amazon: _Welche Produkte werden zusammen gekauft?_

== Beispiel: Nintendo Switch

- Wer eine Switch kauft, kauft oft auch ein *Spiel* und einen *Controller*.
- Über zwei Schritte (Switch → Controller/Spiel → …) kommt man z.B. zu *Transportboxen*.
- Die Kanten tragen einen Faktor, z.B.: von 1000 Switch-Käufern kaufen 900 auch ein Spiel (0,9).

= Technologien

- *Graphdatenbanken* (z.B. Neo4j) speichern Daten direkt als Knoten und Kanten.

