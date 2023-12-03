// Address
#let address(info, render_settings) = {
  if render_settings.show_address {
    [
      #info.personal.location.city,
      // region is optional
      #if "region" in info.personal.location.keys() [#info.personal.location.region]
      #info.personal.location.country
      #info.personal.location.postalCode
      #v(-4pt)
    ]
  } else { none }
}

#let contact(info, render_settings) = [

  // TODO: make configurable
  #let dot_symbol = sym.refmark
  // Contact Info
  // Create a list of contact profiles
  #let profiles = (
    box(link("mailto:" + info.personal.email)),
    if render_settings.show_phone { box(link("tel:" + info.personal.phone)) } else {},
    if "url" in info.personal.keys() { box(link(info.personal.url)[#info.personal.url.split("//").at(1)]) },
  )

  // Remove any none elements from the list,
  // needed in case a field in personal is empty
  #if none in profiles {
    profiles.remove(profiles.position(it => it == none))
  }

  // Add any social profiles
  #if info.personal.profiles.len() > 0 {
    for profile in info.personal.profiles {
      // assertion so we can communicate to user that input is incorrect
      assert("url" in profile.keys(), message: "url missing in {profile.name}")

      // TODO format URL -> `domain`: `profile-name`
      // handle trailing forward slashes
      // handle presence or absence of `www.` / `https://`

      // 1. slice url into array on `.` and `/`
      // 2a. drop https, and www
      // 2b. drop empty elements (trailing `/`)
      // 3. grep element containing domain (0 [if dropped] else 3rd or 2nd)
      // NOTE: we might not want to do this after all, what if the url name is not the username?
      // let url = "https://linkedin.com/in/sean-patrick-klein"
      // if url.ends-with("/") { url = url.trim("/") }
      // let profile = url.match(regex("[^/]+($)")).text
      // parbreak()
      // let domain = url.match(
      //   regex("(?:(?:https|http)://(?:[a-z]{3,}\.)|(?:[a-z]{3,}\.)|)([a-z]+)\."),
      // ).captures.at(0)
      // grep last element for profile name (if trailing / droppedd successfully)

      profiles.push(
        box(
          link(
            profile.url, 
            profile.url.trim("https://").trim("www.").trim("mail.")
      )))
    }
  }

  #if render_settings.show_photo {
    for item in profiles {
      list(marker: dot_symbol)[- #item]
    }
  } else [
    #set par(justify: false)
    #set text(font: render_settings.font_body, weight: "medium", size: render_settings.font_size * 1)
    #pad(x: 0em)[
      #profiles.join([#sym.space.en #dot_symbol #sym.space.en])
    ]
  ]
]

// Create layout of the title + contact info
#let make_head(info, render_settings) = {
  // set page(numbering:"1/1")
  let content = [
    = #info.personal.name
    #address(info, render_settings)
    #contact(info, render_settings)
  ]

  if render_settings.show_photo {
    grid(
      columns: (auto, auto),
      column-gutter: 10pt,
      image(info.personal.photo, width: auto, height: render_settings.photo_height),
      content,
    )
  } else {
    align(center, content)
  }
}