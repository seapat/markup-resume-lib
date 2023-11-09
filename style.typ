// set rules
#let format_page(render_settings, document) = {
  set page(
    paper: render_settings.page_type,

    numbering: (..page_indices) => {
      // accomodate 1 or 2 counting symbols
      let numbers = (page_indices.pos().at(0) - 1,)
      if render_settings.numbering.find(regex("1|a|A|i|I|い|イ|א|가|ㄱ")).len() >= 2 { numbers.push(page_indices.pos().last() - 1) }

      // start indexing only the pages belonging to the cv
      // assuming the cover letter is only 1 page
      if page_indices.pos().at(0) != 1 {
        // decrease count by 1 to start counting one page later
        numbering(render_settings.numbering, ..numbers)
      }
    },
    number-align: render_settings.number_align,
    margin: render_settings.margin,
  )

  // Set Text settings
  set text(font: render_settings.font_body, size: render_settings.font_size, hyphenate: false)

  // Set Paragraph settings
  set par(justify: true)

  document
}

// show rules
#let format_sections(render_settings, document) = {
  // Uppercase Section Headings
  show heading.where(level: 2): item => [
    #set align(left)
    #set text(font: render_settings.font_head, size: 1em, weight: "bold")
    #upper(item.body)
    #if (render_settings.line_below) {
      v(-0.75em)
      line(length: 100%, stroke: 1pt + black) // Draw a line
    } else {
      box(
        width: 1fr,
        inset: (bottom: 0.3em),
        line(length: 100%, stroke: 1pt + black),
      )
    }
  ]

  // Name Title
  show heading.where(level: 1): item => [
    #set text(font: render_settings.font_head, size: 1.5em, weight: "bold")
    #upper(item.body)
    #v(2pt)
  ]

  document
}

#let init(doc, render_settings) = {
  doc = format_page(render_settings, doc)
  doc = format_sections(render_settings, doc)
  doc
}