// This function gets your whole document as its `body`
// and formats it as a simple letter.
#let letter(
  // render_settings,
  // The letter's sender, which is display at the top of the page.
  sender: none,
  // The letter's recipient, which is displayed close to the top.
  recipient: none,
  // The date, displayed to the right.
  date: none,
  // The subject line.
  subject: none,
  // The name with which the letter closes.
  name: none,
  ending: none, // default value set in caller (see below)
  // The letter's content.
  body: none,
  signature_pic: none,
) = {
  // Configure page
  set page(margin: (top: 2cm), numbering: none)

  // Display sender at top of page. If there's no sender
  // add some hidden text to keep the same spacing.
  text(9pt, if sender == none {
    hide("a")
  } else {
    sender
  })

  v(1.8cm)

  // Display recipient.
  recipient

  v(0.25cm)

  // Display date. If there's no date add some hidden
  // text to keep the same spacing.
  align(right, if date != none {
    date
  } else {
    hide("a")
  })

  v(0.5cm) // 2cm

  // Add the subject line, if any.
  if subject != none {
    pad(right: 10%, strong(subject + 2 * linebreak()))
  }

  // Add body and name.
  body
  v(0.5cm)

  ending
  if signature_pic != none { image(signature_pic, width: auto, height: 3em) }
  name
}

#let make_letter(cv_data, render_settings) = {
  let today = datetime.today()
  let day = today.day()
  let written_number = {
    if day == 1 { "st" } else if day == 2 { "nd" } else if day == 3 { "rd" } else { "th" }
  }
  letter(
    sender: [
      #let order = if "address_order" in render_settings.keys() {render_settings.address_order} else {("street", ",", "city", ",", "postalCode", ",","country")}
      #cv_data.personal.name,
      #for value in order {
        if value in cv_data.personal.location.keys() {
          str(cv_data.personal.location.at(value))
          } else {
            value
          }
      }
    ],
    recipient: {
      if "name" in cv_data.recipient.keys() { cv_data.recipient.name + linebreak() }
      if "affiliation" in cv_data.recipient.keys() {
        cv_data.recipient.affiliation + linebreak()
      }
      if "location" in cv_data.recipient.keys() {
        let location = cv_data.recipient.location
        if "street" in location { location.street + linebreak() }
        if "postalCode" in location { str(location.postalCode) + " " }
        if "city" in location { location.city + linebreak() }
        if "regionCode" in location { str(location.regionCode) + " " }
        if "country" in location { location.country }
      }
    },
    date: cv_data.personal.location.city + ", " + if "date_string" in render_settings {
      render_settings.date_string
    } else {
      today.display("[month repr:long] [day padding:none]" + written_number + ", [year]")
    },
    subject: cv_data.letter.subject,
    name: cv_data.personal.name,
    body: cv_data.letter.text,
    ending: if "letter_ending" in render_settings { render_settings.letter_ending } else { "Sincerely," },
    signature_pic: if "signature" in cv_data.personal.keys() { cv_data.personal.signature } else { none },
  )
}