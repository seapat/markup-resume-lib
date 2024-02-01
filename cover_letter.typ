// This function gets your whole document as its `body`
// and formats it as a simple letter.
#let letter(
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
  ending: [Sincerely,],
  // The letter's content.
  body: none,
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
    pad(right: 10%, strong(subject))
  }

  // Add body and name.
  body

  v(0.5cm)

  ending
  parbreak()
  name
}

#let make_letter(cv_data) = {
  let today = datetime.today()
  let day = today.day()
  let ending = {
    if day == 1 { "st" } else if day == 2 { "nd" } else if day == 3 { "rd" } else { "th" }
  }
  letter(
    sender: [
      #cv_data.personal.name,
      #cv_data.personal.location.street,
      #cv_data.personal.location.city,
      #cv_data.personal.location.postalCode,
      #cv_data.personal.location.country
    ],
    recipient: {
      cv_data.recipient.name
      linebreak()
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
    date: [#cv_data.personal.location.city, #today.display("[month repr:long] [day padding:none]" + ending + ", [year]") ],
    subject: [#cv_data.letter.subject ],
    name: cv_data.personal.name,
    body: [#cv_data.letter.text ],
  )
}