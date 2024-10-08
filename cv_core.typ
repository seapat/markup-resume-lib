#import "utils.typ" as utils
#import "@preview/fontawesome:0.1.0": *

// first define functions for each component then use them to generate the cv
#let link-blue = rgb("#0000EE")

#let make_title_line(entry, render_settings) = {
  let date_format = "[month repr:numerical]/[year]"

  let title = if "title" in entry.keys() [#entry.title]
  title = if "url" in entry.keys() {
    title + " - " + link(
      entry.url,
      text("link ", size: render_settings.font_size - 3pt) + fa-arrow-up-right-from-square(size: render_settings.font_size - 5pt, fill: link-blue),
    )
  } else { title }
  let date = utils.format_date(entry, date_format, render_settings)
  if title != none or date != none [*#title #h(1fr) #date* \ ]
}

#let make_sub_line(entry) = {
  let sub = if "subtitle" in entry.keys() {
    text(style: "italic", entry.subtitle)
  }
  let loc = if "location" in entry.keys() { entry.location }
  if sub != none or loc != none [#sub #h(1fr) #loc \ ]
}

#let make_description(entry) = {
  if "description" in entry.keys() and entry.description != none {
    eval(entry.description, mode: "markup")
  }
}

#let make_bullet_points(entry) = {
  if "bullets" in entry.keys() and entry.bullets != none {
    for bp in entry.bullets {
      list(eval(bp, mode: "markup"))
    }
  }
}

#let make_space(entry) = {
  if "spacer" in entry.keys() and entry.spacer != none {
    if type(entry.spacer) == int {
      for _ in range(entry.spacer) {
        "\n"
      }
    } else if entry.spacer == "pagebreak" {
      pagebreak(
        // weak=true
      )
    }
  }
}

#let make_tabular(entry) = {
  if "tabular" in entry.keys() and entry.tabular != none {
    let temp_arr = ()
    for (key, value) in entry.tabular.pairs() {
if key == "columns" {continue};

      let sep = ","
      if "separator" in entry.tabular.keys() { let sep = entry.tabular.separator }

      temp_arr.push(align(left, eval(key, mode: "markup")))
      temp_arr.push(align(left, if type(value) == "array" {
        eval(value.join(sep + " "), mode: "markup")
      } else {
        eval(str(value), mode: "markup")
      }))
    }
    let pad_dist = (2 / 3) * 1em
    pad(
      bottom: if "description" in entry.keys() { -pad_dist } else { -pad_dist / 6 }, // `-pad_dist/6` was determined by trial and error
      // We always want to have some spacing between the separating line and the first element, there's probably a better way to do this
      top: if "subtitle" in entry.keys() { -pad_dist } else { -0.05em },
      grid(
// multiply columns by two because key value are techically their own columns
        columns: if "columns" in entry.tabular.keys() {2*entry.tabular.columns} else {(auto, auto)},
        column-gutter: if "columns" in entry.tabular.keys() {5pt} else {15pt},
        // 0.65 is the default linesapcing of paragraphs
        row-gutter: 0.65em,
        ..temp_arr,
      ),
    ) // spreading-operator see docs.arguments
  }
}

#let make_cv_core(info, render_settings) = {
  // TODO: make user-configurable while using current as default
  for (section, data) in info {
    if type(data) == array { // true sections of CV body
      let section_elements = ()

      for entry in data {
        // init content with empty fields
        let content = (
          "title": none,
          "subtitle": none,
          "bullets": none,
          "list": none,
          "description": none,
        )

        // Line 1: Institution and Location
        content.insert("title", make_title_line(entry, render_settings))
        // Line 2: Degree and Date Range
        content.insert("subtitle", make_sub_line(entry))
        // Part 1: Bullet points
        content.insert("bullets", make_bullet_points(entry))
        // Part 2: Pairs of title and listing, only collect values
        content.insert("list", make_tabular(entry))
        // Part 3: Add text paragraph directly
        content.insert("description", make_description(entry))
        //Part 4: data defined new lines for spacing
        content.insert("spacer", make_space(entry))
        // Push content of most recent section to our Datastructure/array
        section_elements.push(content)
      }

      // render entry contents to page, order is important
      [== #section
        #for element in section_elements [
          #element.title
          #element.subtitle
          #element.list
          #element.description
          #element.bullets
          #element.spacer
          #parbreak()
        ]
      ]
    } else if type(content) == dictionary { none } // personal information and metadata
  }
}

#let foot_note(render_settings) = if render_settings.show_footer {
  place(
    bottom + right,
    block[
      #set text(size: 5pt, font: "Consolas", fill: silver)
      This document was last updated on #datetime.today().display("[year]-[month]-[day]").
    ],
  )
}

