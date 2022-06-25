library (readxl) ## One way to read excel files to R
library (compareGroups) #For nicely formatted descriptive tables
library (mosaic) # For creating factors
library (stargazer) #Nicely formatted regression models.
library (caret) 
library (tidyverse)
library (randomForest)
library (tidyr)
library (kableExtra)
library (glmnet) # for logit models in caret
# If you are unable to load any of the package, remember to install.packages(pkg) and then rerun library(pkg)


#' Remember to copy path and include the path to your dataset below.
#' Download data from: https://www.worldvaluessurvey.org/WVSDocumentationWV7.jsp
wvs <- read_xlsx("D:\\OneDrive\\Rstats\\SICSS-CU2022\\Rscripts\\Data\\WVS.xlsx")
glimpse(wvs)
table(wvs$`Q2: Important in life: Friends`)

wvs_updt <- wvs %>%
            rename (urban = `H_URBRURAL: Urban-Rural`,
                    religion = `Q289: Religious denominations - major groups`,
                    sex = `Q260: Sex`,
                    education = `Q275: Highest educational level: Respondent [ISCED 2011]`,
                    settlement = `H_SETTLEMENT: Settlement type`,
                    ethnic = `Q290: Ethnic group`,
                    age = `Q262: Age`,
                    hell = `Q167: Believe in: hell`,
                    trust_family = `Q58: Trust: Your family`,
                    income = `Q288R: Income level (Recoded)`,
                    SHealth = `Q47: State of health (subjective)`,
                    no_medicine = `Q53: Frequency you/family (last 12 month): Gone without needed medicine or treatment that you needed`) %>% 
            mutate (StHealth = ifelse((SHealth < 3),
                                      "Good", "NotGood") %>% as.factor(),
                    sex = ifelse((sex == 1), "Male", "Female") %>% as.factor(),
                    urban = ifelse((urban == 1), "Urban", "Rural"),
                    hell = ifelse((hell == 1), "Yes", "No") %>% as.factor(),
                    settlement = derivedFactor("Capital" = (settlement == 1 | settlement == 2),
                                               "District" = (settlement == 3),
                                               "Another city" = (settlement == 4),
                                               "Village" = (settlement == 5),
                                               .default = NA),
                    education = derivedFactor("No Education" = (education == 0),
                                              "Primary" = (education == 1),
                                              "Secondary" = (education == 2 | education == 3 | education == 4 | education == 5),
                                              "Tertiary" = (education == 6 | education == 7 | education == 8),
                                              .default = NA),
                    religion = derivedFactor("No religion" = (religion == 0),
                                             "Christian" = (religion ==1 | religion == 2 | religion == 3),
                                             "Muslim" = (religion == 5),
                                             "Others" = (religion == 4| religion == 6 | religion == 7 | religion == 8),
                                             .default = NA),
                    age_grp = derivedFactor("18-34" = (age >= 18 & age <= 34),
                                             "35-54" = (age >= 35 & age <= 54),
                                             "55+" = (age >= 55),
                                             .default = NA),
                    income = derivedFactor("Low" = (income == 1),
                                           "Medium" = (income == 2),
                                           "High" = (income == 3),
                                           .default = NA),
                    trust_family = derivedFactor("Trust Completely" = (trust_family == 1),
                                           "Trust Somewhat" = (trust_family == 2),
                                           "No Trust" = (trust_family == 3 | trust_family == 4),
                                           .default = NA),
                    
                    no_medicine = derivedFactor("Often" = (no_medicine == 1),
                                                 "Sometimes" = (no_medicine == 2),
                                                 "Rarely" = (no_medicine == 3),
                                                "Never" = (no_medicine == 4),
                                                 .default = NA)) %>% 
              select(age, sex, education, 
                     religion, urban, 
                     settlement, no_medicine, 
                     trust_family, income,
                     hell, StHealth)


glimpse(wvs_updt)

## Univariate Descriptive Stats
descrTable(wvs_updt)

## Bivariate Table
cross_tab <- compareGroups(StHealth ~ .,
                           data = wvs_updt, byrow = TRUE)
createTable(cross_tab)


#' Logistic regression model (because our outcome is a dummy)
#' I have also specified outcome ~ . to regress all variables in the
#' dataset over the outcome. If you need to regress only a few variables,
#' try outcome ~ var1 + var2 + var3 + var4

logit <- glm(StHealth ~ .,
             data = wvs_updt,
             family = binomial(link = "logit"))
summary(logit)



stargazer(logit, ci = TRUE,
          type = "text", 
          single.row = TRUE)


### What else can you do? Surprise us!

## Machine Learning
## ================

anyNA(wvs_updt)  # here we check if there are any NAs in our dataset.

wvs_updt_new <- drop_na(wvs_updt) # drop NAs

#' In the blocks of code below we will partition the data into training and testing.
#' Note that I have moved set.seed before shuffle and have assigned it to an object.
#' Ideally we should have the same dataset after shuffling using the same seed value.
#' 
set.seed(419)
wvs_updt_shuf <- shuffle(wvs_updt_new)
wvs_updt_shuf <- wvs_updt_shuf %>% select(-c(orig.id))
data_index <- createDataPartition(wvs_updt_shuf$StHealth, p=0.7, list = FALSE)
train_data <- wvs_updt_shuf[data_index,]
test_data <- wvs_updt_shuf[-data_index,]


#' METHODOLOGY - We used a 10-fold cross validation with 10 repeats because it is a 
#' standard way to improve the estimated performance of a machine learning model. 
#' 
#' The k-fold cross-validation procedure divides a limited dataset into k non-overlapping folds. 
#' Each of the k folds is given an opportunity to be used as a held back test set, 
#' whilst all other folds collectively are used as a training dataset.
#' 
#' This involves simply repeating the cross-validation procedure multiple times 
#' and reporting the mean result across all folds from all runs.
fitControl <- trainControl(method="repeatedcv",
                           number = 10,
                           repeats = 10,
                           sampling = "smote",
                           classProbs = TRUE,
                           summaryFunction = twoClassSummary)

model_svm <- train(StHealth~.,
                   train_data,
                   method="svmRadial",
                   metric="ROC",
                   trControl=fitControl)

model_logit <- train(StHealth~.,
                   train_data,
                   method="glmnet",
                   family = 'binomial',
                   metric="ROC",
                   trControl=fitControl)

model_knn <- train(StHealth~.,
                   train_data,
                   method="knn",
                   metric="ROC",
                   trControl=fitControl)

model_rf <- train(StHealth~.,
                   train_data,
                   method="rf",
                   metric="ROC",
                   trControl=fitControl)

    ## Below, we have generated predictions based on each of the algorithms.
    pred_rf <- predict(model_rf, test_data)
    cm_rf <- confusionMatrix(pred_rf, test_data$StHealth, positive = "Good")

    pred_logit <- predict(model_logit, test_data)
    cm_logit <- confusionMatrix(pred_logit, test_data$StHealth, positive = "Good")
    
    pred_svm <- predict(model_svm, test_data)
    cm_svm <- confusionMatrix(pred_svm, test_data$StHealth, positive = "Good")
    
    pred_knn <- predict(model_knn, test_data)
    cm_knn <- confusionMatrix(pred_knn, test_data$StHealth, positive = "Good")
    


#summarize accuracy of models
result <- rbind("SVM" = cm_svm$byClass, 
                "KNN" = cm_knn$byClass,
                "LOGIT" = cm_logit$byClass, 
                "RF" = cm_rf$byClass) %>%
              ## t() is used to transpose the data
              t() %>% data.frame() %>%  
              rownames_to_column ("Metric") %>% 
              ## Let's drop a few columns that are not so important.
              filter (Metric != "Prevalence" &
                        Metric != "Detection Rate" &
                        Metric != "Detection Prevalence")
result
result %>% kbl() %>%  kable_styling()


## Which model do you think performed better?
