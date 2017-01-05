rm(list = ls())
source("functions.r")
args = commandArgs(trailingOnly = TRUE)
train = args[1]
task = args[2]
pred_risk = args[3]
pred_days = args[4]
seed = 1 # Seed is set for replication of results. Set this to NA if you want greater randomness.

train = as.matrix(read.csv(train))
task = as.matrix(read.csv(task))

if(sum(is.na(train[, 3:ncol(train)]))){
  train = MIwithOutcome(train, seed = seed)
}
if(sum(is.na(rbind(task, train)[, 3:ncol(train)]))){
  temp = MIwithoutOutcome(rbind(task, train), seed = seed)
  task = temp[1:nrow(task), ]
}

pred_gen(train, task, pred_risk, pred_days, reweigh = F)