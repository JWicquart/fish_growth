firstup <- function(x) {
  substr(x, 1, 1) <- toupper(substr(x, 1, 1))
  x
}

# From : https://stackoverflow.com/questions/18509527/first-letter-to-upper-case