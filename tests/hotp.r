library(rotp)
key = "asdf"

test = hotp(key, 1)
truth = 679366
stopifnot(all.equal(test, truth))

test = hotp(key, -1)
truth = 602401
stopifnot(all.equal(test, truth))

test = hotp(key, 10000000)
truth = 620310
stopifnot(all.equal(test, truth))

test = hotp(key, -10000000)
truth = 229514
stopifnot(all.equal(test, truth))



test = hotp(key, 0, digits=8)
truth = 96788213
stopifnot(all.equal(test, truth))
