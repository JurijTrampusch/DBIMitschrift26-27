#set document(title: "DBI Mitschrift – 06.11.2026")
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
  #text(13pt)[06.11.2026 -- Embedding vs. Referencing]
]

= Embedding vs. Referencing

== Beispiel: Social-Media-Post (Embedding)

Die Kommentare werden direkt im Post-Dokument *eingebettet*:

```js
db.socialmediapost.insertOne({
  _id: "BN_061126",
  title: "ich mag sushi",
  text: "…",
  comments: [
    { _id: …, user: …, text: "…" },
    { _id: …, user: …, text: "…" }
  ]
})
```

*Problem:* Wenn der Post ultra viral geht, wächst das `comments`-Array immer weiter -- das *Limit von 16 MB pro Dokument* kann erreicht werden.

== Lösung: Referencing

Deswegen werden die Kommentare in eine *eigene Collection* ausgelagert und verweisen auf den Post:

```js
db.comments.insertOne({
  _id: …,
  post_id: "BN_061126",   // Referenz auf den Post
  user: …,
  text: "…"
})
```

Zusammengeführt wird beim Lesen mit einem *Lookup* (`$lookup`) -- das entspricht einem Join in SQL.

#info[Beispiel für einen Lookup:
  ```js
  db.socialmediapost.aggregate([
    { $lookup: {
        from: "comments",
        localField: "_id",
        foreignField: "post_id",
        as: "comments"
    } }
  ])
  ```
]

#merke[
  - Im Gegensatz zur relationalen DB kann man eine *Referenz angeben, die nicht existiert* -- es gibt keine Fremdschlüssel-Constraints bzw. referentielle Integrität.
  - Wann *Embedding* (Daten werden gemeinsam gelesen, begrenzte Menge) und wann *Referencing* (unbegrenzt wachsende Daten, z.B. Kommentare → 16-MB-Limit)?
]
