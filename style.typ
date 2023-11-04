// set rules
#let format_page(uservars, document) = {
  set page(
    paper: uservars.page_type,

    numbering: (..page_indices) => {
      // accomodate 1 or 2 counting symbols
      let numbers = (page_indices.pos().at(0) - 1,)
      if uservars.numbering.find(regex("1|a|A|i|I|い|イ|א|가|ㄱ")).len() >= 2 { numbers.push(page_indices.pos().last() - 1) }

      // start indexing only the pages belonging to the cv
      // assuming the cover letter is only 1 page
      if page_indices.pos().at(0) != 1 {
        // decrease count by 1 to start counting one page later
        numbering(uservars.numbering, ..numbers)
      }
    },
    number-align: uservars.number-align,
    margin: uservars.margin,
  )

  // Set Text settings
  set text(font: uservars.bodyfont, size: uservars.fontsize, hyphenate: false)

  // Set Paragraph settings
  set par(justify: true)

  document
}

// show rules
#let format_sections(uservars, document) = {
  // Uppercase Section Headings
  show heading.where(level: 2): item => [
    #set align(left)
    #set text(font: uservars.headingfont, size: 1em, weight: "bold")
    #upper(item.body)
    #if (uservars.line_below) {
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
    #set text(font: uservars.headingfont, size: 1.5em, weight: "bold")
    #upper(item.body)
    #v(2pt)
  ]

  document
}

#let init(doc, uservars) = {
  doc = format_page(uservars, doc)
  doc = format_sections(uservars, doc)
  doc
}