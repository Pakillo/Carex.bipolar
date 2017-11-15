library(Carex.bipolar)

context("Fake test")

examplefunction <- function(text){
  return(text)
}

test_that("examplefunction can be run", {
  output <- examplefunction("testing")
  expect_match(output, "testing")
})
