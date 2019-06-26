library(plyr)
library(dplyr)
library(gbm)
library(caret)
library(dismo)
library(pROC)
library(ROCR)
library(foreign)

set.seed(1)

setwd('~/Data and Code/')
defaults = read.csv('Csv_Files/default_sample.csv', stringsAsFactors = T) 
cols = c('wave', 'female', 'muslim', 'ctrl', 'moral_rel', 'simple_rem', 'religious_plac', 'credit_rep', 'sample_before', 'default', 'province')
defaults[cols] = lapply(defaults[cols], factor)
defaults$default = as.numeric(as.character(defaults$default))
wpapua = defaults %>% filter(province=='31')
defaults = defaults %>% filter(province!='31')

# Control group only
defaults2 = defaults %>% filter(ctrl==1)

control = trainControl(method='repeatedcv', number=5, repeats=5)

# Gradient boosted machine with 10-fold repeated CV (using weights provided)
modelGbm <- train(default~wave+age+creditlimit+female+muslim+income+poor_credit_history+province+sample_before, 
                  data=defaults2, method="gbm", trControl=control, verbose=T, weights = weight)

prediction_1 = predict(modelGbm, newdata=defaults)
defaults$gbm = prediction_1

# Regression tree predictions
gbmModel = gbm(formula = default~wave+age+creditlimit+female+muslim+income+poor_credit_history+province+sample_before,
                    distribution = "bernoulli",
                    data = defaults2,
                    n.trees = 1500,
                    shrinkage = .01,
                    n.minobsinnode = 30,
                    weights = weight)

prediction_2 = predict.gbm(object = gbmModel,
                             newdata = defaults,
                             n.trees = 1500,
                             type = "response")

defaults$regression_tree = prediction_2

# No West Papua in control set, so create predictions as an average of all other province
# effects
matrices = list()
for(province in unique(defaults$province)) {
  wpapua$province = province
  prediction_1 = predict(modelGbm, newdata=wpapua)
  prediction_2 = predict.gbm(object = gbmModel,
                             newdata = wpapua,
                             n.trees = 1500,
                             type = "response")
  matrices[[length(matrices)+1]] = cbind(prediction_1, prediction_2)
}
wpapua_predictions = Reduce("+", matrices) / length(matrices) 
wpapua_predictions = wpapua_predictions %>% as.data.frame()
names(wpapua_predictions) = c('gbm', 'regression_tree')
wpapua = bind_cols(wpapua, wpapua_predictions)
defaults$province = as.character(defaults$province)
wpapua$province = '31'
defaults = bind_rows(defaults, wpapua)
defaults$province = as.factor(defaults$province)
defaults$randomcardnumber = sprintf("%012.0f",defaults$randomcardnumber)
write.dta(defaults, 'Dta_Files/machine_learning_predictions.dta')
