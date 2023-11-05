#import "utils.typ" as utils

// first define functions for each component then use them to generate the cv

#let make_name_line(entry, date_format) = {
  let name = if "name" in entry.keys() {
    if "url" in entry.keys() [*#link(entry.url)[#entry.name]*] else [#entry.name]
  }
  [*#name #h(1fr) #utils.format_date(entry, date_format)* \ ]

}

#let make_sub_line(entry) = {
  let sub = if "subtitle" in entry.keys() {
    text(style: "italic")[#entry.subtitle]
  }
  [#sub #h(1fr) #if "location" in entry.keys() [#entry.location] \ ]
}

#let make_description(entry) = {
  if "description" in entry.keys() and entry.description != none {
    eval("[" + entry.description + " \ ]")
  }
}

#let make_bullet_points(entry) ={
  if "bullets" in entry.keys() and entry.bullets != none {
    for bp in entry.bullets [- #eval("[" + bp + "]")]
  }
}

#let make_term_list(entry) = {
  // let term_list = none
  if "term_list" in entry.keys() and entry.term_list != none {
    let temp_arr = ()
    for (term, list) in entry.term_list {
      temp_arr.push(align(left, term))
      temp_arr.push(align(left, list.join(", ")))
    }
    let pad_dist = 0.55em
    pad(
      bottom: -pad_dist,
      // We always want to have some spacing between the separating line and the first element, there's probably a better way to do this
      top: if "subtitle" in entry.keys() { -pad_dist } else { 0em },
      grid(
        columns: (auto, auto),
        column-gutter: 10pt,
        // 0.65 is the default linesapcing of paragraphs
        row-gutter: 0.65em,
        ..temp_arr,
      ),
    ) // spreading-operator see docs.arguments
  }
}

#let make_cv_core(info) = {
  // TODO: make user-configurable while using current as default
  let date_format = "[month repr:short] [year]"

  for (section, data) in info {
    if type(data) == array { // true sections of CV body
      let section_elements = ()

      for entry in data {
        // init content with empty fields
        let content = (
          "name": none,
          "subtitle": none,
          "bullets": none,
          "list": none,
          "description": none,
        )

        // Line 1: Institution and Location
        content.insert("name", make_name_line(entry, date_format))

        // Line 2: Degree and Date Range
        content.insert("subtitle", make_sub_line(entry))

        // Part 1: Bullet points
        content.insert("bullets", make_bullet_points(entry))

        // Part 3: Add text paragraph directly
        content.insert("description", make_description(entry))

        // Part 2: Pairs of name and listing, only collect values
        content.insert("list", make_term_list(entry))

        // Push content of most recent section to our Datastructure/array
        section_elements.push(content)
      }

      // render entry contents to page, order is important
      [== #section
        #for element in section_elements [
          #element.name
          #element.subtitle
          #element.list
          #element.description
          #element.bullets
          #parbreak()
        ]
      ]
    } else if type(content) == dictionary { none } // personal information and metadata
  }
}

#let foot_note = {
  place(
    bottom + right,
    block[
      #set text(size: 5pt, font: "Consolas", fill: silver)
      This document was last updated on #datetime.today().display("[year]-[month]-[day]").
    ],
  )
}

