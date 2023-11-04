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

  v(0.5cm)

  // Display date. If there's no date add some hidden
  // text to keep the same spacing.
  align(right, if date != none {
    date
  } else {
    hide("a")
  })

  v(2cm)

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

#let make_letter(cvdata) = {
  let today = datetime.today()
  let day = today.day()
  let ending = {
    if day == 1 { "st" } else if day == 2 { "nd" } else if day == 3 { "rd" } else { "th" }
  }
  letter(
    sender: [
      #cvdata.personal.name,
      #cvdata.personal.location.street,
      #cvdata.personal.location.city,
      #cvdata.personal.location.postalCode,
      #cvdata.personal.location.country
    ],
    recipient: [
      #cvdata.recipient.name \
      #cvdata.recipient.affiliation \
      #if "street" in cvdata.recipient [#cvdata.recipient.location.street,] \
      #if "city" in cvdata.recipient [#cvdata.recipient.city,]
      #if "regionCode" in cvdata.recipient { cvdata.recipient.regionCode }
      #if "postalCode" in cvdata.recipient {cvdata.recipient.postalCode} \
      #if "country" in cvdata.recipient { cvdata.recipient.country }
    ],
    date: [#cvdata.personal.location.city, #today.display("[month repr:long] [day padding:none]" + ending + ", [year]") ],
    //  October 28th, 2023
    subject: [#cvdata.body.subject ],
    name: cvdata.personal.name,
    // ending: [Kind regards,],
    body: [#cvdata.body.text ],
  )
}