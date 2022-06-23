library (readxl) ## One way to read excel files to R
library (compareGroups) #For nicely formatted descriptive tables
library (mosaic) # For creating factors
library (stargazer) #Nicely formatted regression models.

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
                    SHealth = `Q47: State of health (subjective)`) %>% 
            select(age, sex, education, religion,
                   urban, settlement, ethnic,
                   SHealth) %>% 
            mutate (StHealth = ifelse((SHealth < 3),
                                      "Good", "Not Good") %>% as.factor(),
                    sex = ifelse((sex == 1), "Male", "Female") %>% as.factor(),
                    urban = ifelse((urban == 1), "Urban", "Rural"),
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
                                             .default = NA)) %>% 
            select (-c(SHealth, ethnic, age))


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
          single.row = TRUE,
          apply.coef = exp)


### What else can you do? Surprise us!