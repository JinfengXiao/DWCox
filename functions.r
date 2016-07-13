# This script defines some functions for calls.

suppressMessages(require(mice));
suppressMessages(require(survival));
suppressMessages(require(glmnet));
suppressMessages(require(pdfCluster));

# MICE with outcome (i.e. time, death)
MIwithOutcome = function(data,seed=NA)
{
  temp = as.data.frame(subset(data,select=c(t,ei)));
  nae = nelsonaalen(temp,t,ei);
  mat = cbind(nae,data[,3:ncol(data)]);
  imp = mice(mat, m=1, maxit=10, print=F,seed=seed);
  mat = complete(imp);
  out = as.matrix(cbind(temp,mat[,2:ncol(mat)]));
  return(out);
}

# MICE without outcome
MIwithoutOutcome = function(data,seed=NA)
{
  imp = mice(data[,3:ncol(data)], m=1, maxit=10, print=F,seed=seed);
  out = as.matrix(cbind(subset(data,select=c(t,ei)),complete(imp)));
  return(out);
}

# Cox regression with glmnet
CoxGlm = function(traindata,alpha=0,lambda=0,weights=NULL)
{
  surv = traindata[,c("t","ei")];
  colnames(surv) = c("time","status");
  if(is.null(weights)){
    cox = glmnet(x=traindata[,3:ncol(traindata)],y=surv,family="cox",alpha=alpha,lambda=lambda);
  }else{
    cox = glmnet(x=traindata[,3:ncol(traindata)],y=surv,family="cox",alpha=alpha,lambda=lambda,weights=weights);
  }
  return(cox);
}

# Perform Cox with glmnet and the best lambda value
CoxGlmRisk = function(traindata,testdata,bestlambda,alpha=0,trainweights=NULL)
{
  if(is.null(trainweights)){
    cox = CoxGlm(traindata,alpha,bestlambda);
  }else{
    cox = CoxGlm(traindata,alpha,bestlambda,trainweights);
  }
  return(predict(cox,newx=testdata[,3:ncol(testdata)],type="link"));
}

# This function predicts the survival time from risks, using linear regression.
oneb = function(train,trainrisk,testrisk)
{
  traintime = train[,"t"];
  model = lm(traintime~trainrisk);
  out = model$coefficients[1]+model$coefficients[2]*testrisk;
  return(out);
}

# This function generates the predicted risks and survival time.
pred_gen = function(train,test,risk_out_dir,time_out_dir,alpha=0,lambda=0,reweigh=T){
  if(reweigh){
    trainweight = attr(kepdf(train[,3:ncol(train)],bwtype="fixed",h=4*h.norm(train[,3:ncol(train)])),"estimate");
    trainweight = trainweight/max(trainweight);
  }else{
    trainweight = rep(1,nrow(train));
  }
  RISK = CoxGlmRisk(train,test,lambda,alpha,trainweight);
  write.table(RISK,file=risk_out_dir,sep=",",row.names=F,col.names=F);
  trainrisk = CoxGlmRisk(train,train,lambda,alpha,trainweight);
  TIMETOEVENT = oneb(train,trainrisk,RISK);
  write.table(TIMETOEVENT,file=time_out_dir,sep=",",row.names=F,col.names=F);
}