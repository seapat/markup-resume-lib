#import "utils.typ" as utils
#import "@preview/fontawesome:0.1.0": *

// first define functions for each component then use them to generate the cv
#let link-blue = rgb("#0000EE")

#let make_title_line(entry, render_settings) = {
  let date_format = "[month repr:short] [year]"
  let date_format = "[month repr:short] [year]"

  let title = if "title" in entry.keys() [#entry.title]
  title = if "url" in entry.keys() {
      title+" "+link(entry.url, fa-up-right-from-square(size: render_settings.  font_size - 3pt, fill:link-blue))
    }
    else {title}
  let date = utils.format_date(entry, date_format)
  if title != none or date != none [*#title #h(1fr) #date* \ ]
}

#let make_sub_line(entry) = {
  let sub = if "subtitle" in entry.keys() {
    text(style: "italic", entry.subtitle)
  }
  let loc = if "location" in entry.keys() {entry.location}
  if sub != none or loc != none [#sub #h(1fr) #loc \ ]
}

#let make_description(entry) = {
  if "description" in entry.keys() and entry.description != none {
    eval(entry.description, mode:"markup")
  }
}

#let make_bullet_points(entry) = {
  if "bullets" in entry.keys() and entry.bullets != none {
    for bp in entry.bullets {list(eval(bp, mode:"markup"))}
  }
}

#let make_tabular(entry) = {
  if "tabular" in entry.keys() and entry.tabular != none {
    // entry.tabular
    // type(entry.tabular) + " " + str(entry.tabular.len())
    let temp_arr = ()
    for (key,value) in entry.tabular.pairs() {
      let sep = ","
      if "separator" in entry.tabular.keys() {let sep = entry.tabular.separator} else { let sep = ","}
      temp_arr.push(align(left, eval(key, mode:"markup"))) 
      temp_arr.push(align(left, eval(value.join(sep +" "), mode:"markup")))
    }
    let pad_dist = (2/3) * 1em
    pad(
      bottom: if "description" in entry.keys() {-pad_dist} else {-pad_dist / 6}, // `-pad_dist/6` is trial and error
      // We always want to have some spacing between the separating line and the first element, there's probably a better way to do this
      top: if "subtitle" in entry.keys() { -pad_dist } else { -0.05em },
      grid(
        columns: (auto, auto),
        column-gutter: 15pt,
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

