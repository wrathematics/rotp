library(rotp)
key = "asdf"

test = hotp(key, 1)
truth = 679366
stopifnot(all.equal(test, truth))

test = hotp(key, 10)
truth = 795860
stopifnot(all.equal(test, truth))

test = hotp(key, 10000)
truth = 350230
stopifnot(all.equal(test, truth))

test = hotp(key, 10000000)
truth = 620310
stopifnot(all.equal(test, truth))



test = hotp(key, 0, digits=8)
truth = 96788213
stopifnot(all.equal(test, truth))
