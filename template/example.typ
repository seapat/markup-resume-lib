#import "@local/markup-resume:0.0.1" as core
#import "markup-resume-lib/cv_head.typ": make_head
#import "markup-resume-lib/cover_letter.typ": make_letter
#import "markup-resume-lib/style.typ": init

#let render_settings = (
  font_body: "Linux Libertine", // Set font for body
  font_size: 11pt, // 10pt, 11pt, 12pt
  font_head: "Linux Libertine", // Set font for headings
  line_below: false,
  line_spacing: 0.65em,
  margin: 1.25cm, // 1.25cm, 1.87cm, 2.5cm
  number_align: center, //left, center, right
  numbering: "1 / 1", // Might not work as page-numbering in typst, please create an issue if you find such a case
  page_type: "a4", // a4, us-letter
  photo_height: 9em, // trial&error
  show_address: true, // true/false Show address in contact info
  show_phone: true, // true/false Show phone number in contact info
  show_photo: true, // whether or not to show the Photo
)

#show: doc => init(doc, render_settings)

#let cv_data = toml("./example.toml")
#make_letter(cv_data)

#make_head(cv_data, render_settings)

#core.make_cv_core(cv_data)
#core.foot_note

// This example uses a single data file
// alternatively you could also compose your cv from multiple files like so:

// #let letter = toml("./letter.toml")
// #let header = toml("./header.toml")
// #let content = toml("./content.toml")
// #make_letter(letter)
// #make_head(header, render_settings)
// #core.make_cv_core(content)
// #core.foot_note

// with a little bit more typst code (dictionary merges), you could compartemalize your data further
