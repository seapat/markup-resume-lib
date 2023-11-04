#let parse_isodate(isodate) = {
  let date = ""
  date = datetime(
    year: int(isodate.slice(0, 4)),
    month: int(isodate.slice(5, 7)),
    day: int(isodate.slice(8, 10)),
  )
  date
}

#let capitalize(string) = [
  #upper(string.at(0))#string.slice(1)
]

#let format_date(entry, date_format) = {
  // cases:
  // if start and end -> set duration
  // if start but no end -> until present
  // if end but no start -> single date
  // release is a shorter endDate, for semantics
  let start = if "startDate" in entry.keys() [#parse_isodate(entry.startDate).display(date_format)] else { none }
  let end = if "endDate" in entry.keys() [#parse_isodate(entry.endDate).display(date_format)] else if start != none { "Present" } else { none }
  let release = if "releaseDate" in entry.keys() [#parse_isodate(entry.releaseDate).display(date_format)] else { none }

  // return value, NOTE: if we put everything in the []-block, newline above would be returned as well
  [#if start != none [#start #sym.dash.en #end] else if end != none [#end] else [#release]]
}

