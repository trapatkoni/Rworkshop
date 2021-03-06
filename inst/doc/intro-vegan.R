### R code from vignette source 'intro-vegan.Rnw'

###################################################
### code chunk number 1: intro-vegan.Rnw:18-23
###################################################
par(mfrow=c(1,1))
options(width=72)
figset <- function() par(mar=c(4,4,1,1)+.1)
options(SweaveHooks = list(fig = figset))
options("prompt" = "> ", "continue" = "  ")


###################################################
### code chunk number 2: intro-vegan.Rnw:71-74
###################################################
library(vegan)
data(dune)
ord <- decorana(dune)


###################################################
### code chunk number 3: intro-vegan.Rnw:77-78
###################################################
ord


###################################################
### code chunk number 4: intro-vegan.Rnw:101-103
###################################################
ord <- metaMDS(dune)
ord


###################################################
### code chunk number 5: a
###################################################
plot(ord)


###################################################
### code chunk number 6: intro-vegan.Rnw:118-119
###################################################
getOption("SweaveHooks")[["fig"]]()
plot(ord)


###################################################
### code chunk number 7: a
###################################################
plot(ord, type = "n")
points(ord, display = "sites", cex = 0.8, pch=21, col="red", bg="yellow")
text(ord, display = "spec", cex=0.7, col="blue")


###################################################
### code chunk number 8: intro-vegan.Rnw:140-141
###################################################
getOption("SweaveHooks")[["fig"]]()
plot(ord, type = "n")
points(ord, display = "sites", cex = 0.8, pch=21, col="red", bg="yellow")
text(ord, display = "spec", cex=0.7, col="blue")


###################################################
### code chunk number 9: intro-vegan.Rnw:205-207
###################################################
data(dune.env)
attach(dune.env)


###################################################
### code chunk number 10: a
###################################################
plot(ord, disp="sites", type="n")
ordihull(ord, Management, col="blue")
ordiellipse(ord, Management, col=3,lwd=2)
ordispider(ord, Management, col="red", label = TRUE)
points(ord, disp="sites", pch=21, col="red", bg="yellow", cex=1.3)


###################################################
### code chunk number 11: intro-vegan.Rnw:217-218
###################################################
getOption("SweaveHooks")[["fig"]]()
plot(ord, disp="sites", type="n")
ordihull(ord, Management, col="blue")
ordiellipse(ord, Management, col=3,lwd=2)
ordispider(ord, Management, col="red", label = TRUE)
points(ord, disp="sites", pch=21, col="red", bg="yellow", cex=1.3)


###################################################
### code chunk number 12: intro-vegan.Rnw:248-250
###################################################
ord.fit <- envfit(ord ~ A1 + Management, data=dune.env, perm=1000)
ord.fit


###################################################
### code chunk number 13: a
###################################################
plot(ord, dis="site")
plot(ord.fit)


###################################################
### code chunk number 14: b
###################################################
ordisurf(ord, A1, add=TRUE)


###################################################
### code chunk number 15: intro-vegan.Rnw:266-268
###################################################
getOption("SweaveHooks")[["fig"]]()
plot(ord, dis="site")
plot(ord.fit)
ordisurf(ord, A1, add=TRUE)


###################################################
### code chunk number 16: intro-vegan.Rnw:288-290
###################################################
ord <- cca(dune ~ A1 + Management, data=dune.env)
ord


###################################################
### code chunk number 17: a
###################################################
plot(ord)


###################################################
### code chunk number 18: intro-vegan.Rnw:297-298
###################################################
getOption("SweaveHooks")[["fig"]]()
plot(ord)


###################################################
### code chunk number 19: intro-vegan.Rnw:315-316
###################################################
cca(dune ~ ., data=dune.env)


###################################################
### code chunk number 20: intro-vegan.Rnw:325-326
###################################################
anova(ord)


###################################################
### code chunk number 21: intro-vegan.Rnw:340-341
###################################################
anova(ord, by="term", permu=200)


###################################################
### code chunk number 22: intro-vegan.Rnw:347-348
###################################################
anova(ord, by="mar")


###################################################
### code chunk number 23: a
###################################################
anova(ord, by="axis", perm=500)


###################################################
### code chunk number 24: intro-vegan.Rnw:365-367
###################################################
ord <- cca(dune ~ A1 + Management + Condition(Moisture), data=dune.env)
ord


###################################################
### code chunk number 25: intro-vegan.Rnw:372-373
###################################################
anova(ord, by="term", perm=500)


###################################################
### code chunk number 26: intro-vegan.Rnw:378-379
###################################################
anova(ord, by="term", perm=500, strata=Moisture)


###################################################
### code chunk number 27: intro-vegan.Rnw:383-384
###################################################
detach(dune.env)


