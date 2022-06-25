## Load libraries

For this exercise, we will use a - `easyPubMed` to fetch publication
data from PubMed:
<https://pubmed.ncbi.nlm.nih.gov/?term=stunting&sort=date> - `tidyverse`
for tidy data wrangling - `rvest` for scrapping a website to retrieve
country names.

Remember to `install.packages()` if you have not installed these
packages already.

    library (easyPubMed)
    library (tidyverse)

    ## -- Attaching packages --------------------------------------- tidyverse 1.3.1 --

    ## v ggplot2 3.3.6     v purrr   0.3.4
    ## v tibble  3.1.7     v dplyr   1.0.9
    ## v tidyr   1.2.0     v stringr 1.4.0
    ## v readr   2.1.2     v forcats 0.5.1

    ## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

    library (countrycode)
    library (rvest)

    ## 
    ## Attaching package: 'rvest'

    ## The following object is masked from 'package:readr':
    ## 
    ##     guess_encoding

## PubMed Data Retreival

You’ll need to create a search query for research that includes the word
title in their abstract or title. These research needs to have been
published between 2019 and 2022.

Subsequently, we will use `get_pubmed_ids` to extract pubmed\_ids for
articles that match our query of interest.

The code chunk below will help us retrieve articles into R based on the
ids retreived above.

      database <- fetch_pubmed_data(new_query)
      all_xml <- articles_to_list(database)

Below, we will create different databases, one with individual
publication record while the other includes a record of researchers
listed on each article and their respective affiliations.

      ## Create a dataframe with articles
      articleBase <- do.call(rbind, 
                             lapply(all_xml, 
                                    article_to_df,
                                    max_chars = -1,
                                    getAuthors = FALSE))
      
      ## Create a dataframe with all author information
      author_Base <- table_articles_byAuth(pubmed_data = database, 
                                       included_authors = "all", 
                                       max_chars = 0, 
                                       encoding = "ASCII")

    ## Processing PubMed data .................................................. done!

      ## We can view the top records using head()
      head (author_Base)

    ##       pmid                            doi
    ## 1 35746780              10.3390/v14061310
    ## 2 35746780              10.3390/v14061310
    ## 3 35746780              10.3390/v14061310
    ## 4 35746780              10.3390/v14061310
    ## 5 35746780              10.3390/v14061310
    ## 6 35744610 10.3390/microorganisms10061092
    ##                                                                                                                                 title
    ## 1 Persistent, and Asymptomatic Viral Infections and Whitefly-Transmitted Viruses Impacting Cantaloupe and Watermelon in Georgia, USA.
    ## 2 Persistent, and Asymptomatic Viral Infections and Whitefly-Transmitted Viruses Impacting Cantaloupe and Watermelon in Georgia, USA.
    ## 3 Persistent, and Asymptomatic Viral Infections and Whitefly-Transmitted Viruses Impacting Cantaloupe and Watermelon in Georgia, USA.
    ## 4 Persistent, and Asymptomatic Viral Infections and Whitefly-Transmitted Viruses Impacting Cantaloupe and Watermelon in Georgia, USA.
    ## 5 Persistent, and Asymptomatic Viral Infections and Whitefly-Transmitted Viruses Impacting Cantaloupe and Watermelon in Georgia, USA.
    ## 6                                                     Differential Viral Genome Diversity of Healthy and RSS-Affected Broiler Flocks.
    ##   abstract year month day         jabbrv        journal
    ## 1          2022    06  24        Viruses        Viruses
    ## 2          2022    06  24        Viruses        Viruses
    ## 3          2022    06  24        Viruses        Viruses
    ## 4          2022    06  24        Viruses        Viruses
    ## 5          2022    06  24        Viruses        Viruses
    ## 6          2022    06  24 Microorganisms Microorganisms
    ##                                                                                                                                                                                                              keywords
    ## 1 Georgia; USA; cantaloupe; cucumis melo amalgavirus (CmAV1); cucumis melo cryptic virus (CmCV); cucumis melo endornavirus (CmEV); persistent virus; watermelon; watermelon crinkle leaf-associated virus 1 (WCLaV-1)
    ## 2 Georgia; USA; cantaloupe; cucumis melo amalgavirus (CmAV1); cucumis melo cryptic virus (CmCV); cucumis melo endornavirus (CmEV); persistent virus; watermelon; watermelon crinkle leaf-associated virus 1 (WCLaV-1)
    ## 3 Georgia; USA; cantaloupe; cucumis melo amalgavirus (CmAV1); cucumis melo cryptic virus (CmCV); cucumis melo endornavirus (CmEV); persistent virus; watermelon; watermelon crinkle leaf-associated virus 1 (WCLaV-1)
    ## 4 Georgia; USA; cantaloupe; cucumis melo amalgavirus (CmAV1); cucumis melo cryptic virus (CmCV); cucumis melo endornavirus (CmEV); persistent virus; watermelon; watermelon crinkle leaf-associated virus 1 (WCLaV-1)
    ## 5 Georgia; USA; cantaloupe; cucumis melo amalgavirus (CmAV1); cucumis melo cryptic virus (CmCV); cucumis melo endornavirus (CmEV); persistent virus; watermelon; watermelon crinkle leaf-associated virus 1 (WCLaV-1)
    ## 6                                                                                                                               broiler flocks; next-generation sequencing; poultry virome; runting-stunting syndrome
    ##      lastname       firstname
    ## 1     Adeleke Ismaila Adeyemi
    ## 2 Kavalappara   Saritha Raman
    ## 3    McGregor         Cecilia
    ## 4  Srinivasan   Rajagopalbabu
    ## 5         Bag          Sudeep
    ## 6     Kubacki           Jakub
    ##                                                                                    address
    ## 1              Department of Plant Pathology, University of Georgia, Tifton, GA 31793, USA
    ## 2              Department of Plant Pathology, University of Georgia, Tifton, GA 31793, USA
    ## 3                 Department of Horticulture, University of Georgia, Athens, GA 30602, USA
    ## 4                  Department of Entomology, University of Georgia, Griffin, GA 30223, USA
    ## 5              Department of Plant Pathology, University of Georgia, Tifton, GA 31793, USA
    ## 6 Institute of Virology, Vetsuisse Faculty, University of Zurich, 8057 Zurich, Switzerland
    ##   email
    ## 1  <NA>
    ## 2  <NA>
    ## 3  <NA>
    ## 4  <NA>
    ## 5  <NA>
    ## 6  <NA>

      head (articleBase)

    ##       pmid                            doi
    ## 1 35746780              10.3390/v14061310
    ## 2 35744610 10.3390/microorganisms10061092
    ## 3 35740754        10.3390/children9060817
    ## 4 35739560     10.1186/s40795-022-00551-6
    ## 5 35736806  10.1080/03014460.2022.2091794
    ## 6 35730383   10.1097/QAD.0000000000003290
    ##                                                                                                                                                                         title
    ## 1                                         Persistent, and Asymptomatic Viral Infections and Whitefly-Transmitted Viruses Impacting Cantaloupe and Watermelon in Georgia, USA.
    ## 2                                                                                             Differential Viral Genome Diversity of Healthy and RSS-Affected Broiler Flocks.
    ## 3                      Correlates of Sub-Optimal Feeding Practices among under-5 Children amid Escalating Crises in Lebanon: A National Representative Cross-Sectional Study.
    ## 4 Association between anthropometric criteria and body composition among children aged 6-59â\200‰months with severe acute malnutrition: a cross-sectional assessment from India.
    ## 5                                                                              Growth delay: an alternative measure of population health based on child height distributions.
    ## 6                                                         Neurodevelopmental Outcomes of HIV and Anti-retroviral Drug Perinatally Exposed Uninfected Children Aged 3-6 years.
    ##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         abstract
    ## 1                                                                                                                                                                                                                                                                                                                                                      Cucurbits in Southeastern USA have experienced a drastic decline in production over the years due to the effect of economically important viruses, mainly those transmitted by the sweet potato whitefly (<i>Bemisia tabaci</i> Gennadius). In cucurbits, these viruses can be found as a single or mixed infection, thereby causing significant yield loss. During the spring of 2021, surveys were conducted to evaluate the incidence and distribution of viruses infecting cantaloupe (<i>n</i> = 80) and watermelon (<i>n</i> = 245) in Georgia. Symptomatic foliar tissues were collected from six counties and sRNA libraries were constructed from seven symptomatic samples. High throughput sequencing (HTS) analysis revealed the presence of three different new RNA viruses in Georgia: cucumis melo endornavirus (CmEV), cucumis melo amalgavirus (CmAV1), and cucumis melo cryptic virus (CmCV). Reverse transcription-polymerase chain reaction (RT-PCR) analysis revealed the presence of CmEV and CmAV1 in 25% and 43% of the total samples tested, respectively. CmCV was not detected using RT-PCR. Watermelon crinkle leaf-associated virus 1 (WCLaV-1), recently reported in GA, was detected in 28% of the samples tested. Furthermore, RT-PCR and PCR analysis of 43 symptomatic leaf tissues collected from the fall-grown watermelon in 2019 revealed the presence of cucurbit chlorotic yellows virus (CCYV), cucurbit yellow stunting disorder virus (CYSDV), and cucurbit leaf crumple virus (CuLCrV) at 73%, 2%, and 81%, respectively. This finding broadens our knowledge of the prevalence of viruses in melons in the fall and spring, as well as the geographical expansion of the WCLaV-1 in GA, USA.
    ## 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  The intestinal virus community contributes to health and disease. Runting and stunting syndrome (RSS) is associated with enteric viruses and leads to economic losses in the poultry industry. However, many viruses that potentially cause this syndrome have also been identified in healthy animals. To determine the difference in the virome of healthy and diseased broilers, samples from 11 healthy and 17 affected broiler flocks were collected at two time points and analyzed by Next-Generation Sequencing. Virus genomes of <i>Parvoviridae</i>, <i>Astroviridae</i>, <i>Picornaviridae</i>, <i>Caliciviridae</i>, <i>Reoviridae</i>, <i>Adenoviridae</i>, <i>Coronaviridae</i>, and <i>Smacoviridae</i> were identified at various days of poultry production. De novo sequence analysis revealed 288 full or partial avian virus genomes, of which 97 belonged to the novel genus <i>Chaphamaparvovirus</i>. This study expands the knowledge of the diversity of enteric viruses in healthy and RSS-affected broiler flocks and questions the association of some viruses with the diseases.
    ## 3 Sub-optimal feeding practices among under-5 children are the major drivers of malnutrition. This study aims to assess the prevalence of malnutrition and the factors affecting exclusive breastfeeding, bottle feeding, and complementary feeding practices among under 5 children amid the COVID-19 pandemic as well as the economic and the political crises in Lebanon. A nationally representative stratified random sample of mother-child dyads (<i>n</i> = 511) was collected from households using a stratified cluster sampling design. The survey inquired about infant's feeding and complementary feeding practices using a valid questionnaire. Anthropometric measurements of the mother and child were collected. Multivariate logistic regression was conducted to explore the determinants associated with under-5 children's practices. The prevalence of underweight, stunting, wasting, overweight and obese children was 0.5%, 8.4%, 6.7%, 16.8% and 8.9%, respectively. In total, among under-5 children, the prevalence of ever breastfeeding, exclusive breastfeeding, and bottle feeding at birth was 95.1%, 59.1% and 25.8%, respectively. Half the children in this study started solid foods between 4 and 6 months. Regression analysis showed that supporting breastfeeding at hospital (aOR = 8.20, 95% CI (3.03-22.17)) and husband's support (aOR = 3.07, 95% CI (1.9-4.92)) were associated with increased breastfeeding odds. However, mother's occupation (aOR = 0.18, 95% CI (0.55-0.58)) was inversely associated with breastfeeding practices. Male children (aOR = 2.119, 95% CI (1.37-3.27), mothers diagnosed with COVID-19 (aOR = 0.58, 95% CI (0.35-0.95)), and bottle feeding at hospital (aOR = 0.5, 95% CI (0.32-0.77)) were more likely to induce early initiation of solid foods at 4 months of age. This study demonstrated non-negligible rates of malnutrition, low prevalence of exclusive breastfeeding, and high rates of early introduction of formula feeding and solid foods among Lebanese under-5-children amid escalating crises.
    ## 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           A multicentric study is being conducted in which children with severe acute malnutrition (SAM) aged 6-59â\200‰months are identified with only weight-for-height z-score (WHZ)â\200‰&lt;â\200‰-â\200‰3 criteria. The present study aimed to assess associations of anthropometric parameters and body composition parameters, to improve treatment of SAM. We conducted a cross-section assessment using the enrolment data of children who participated in a multi-centric longitudinal controlled study from five Indian states. Fat-free mass (FFM) and fat mass (FM) were determined by bio-electrical impedance analysis (BIA). Six hundred fifty-nine children were enrolled in the study using WHZâ\200‰&lt;â\200‰-3 criteria. Available data shows that WHZ, WAZ and BMIZ were significantly associated with FFMI while MUACZ was significantly associated with both FMI and FFMI. Children with both severe wasting and severe stunting had significantly lower FFMI compared to those who were only severely wasted. All forms of anthropometric deficits appear to adversely impact FFM and FM.Trial registrationThe study is registered with Clinical Trial Registration of India (Registration No.: CTRI/2020/09/028013 dated 24/09/2020).
    ## 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  Indicators of child height, such as mean height-for-age Z-scores (HAZ), height-for-age difference (HAD) and stunting prevalence, do not account for differences in population-average bone developmental stage. Propose a measure of child height that conveys the dependency of linear growth on stage rather than chronological age. Using Demographic and Health Surveys (2000-2018; 64 countries), we generated: 1) predicted HAZ at specific ages (HAZ regressed on age); 2) height-age (age at which mean height matches the WHO Growth Standards median); 3) Growth delay (GD), the difference between chronological age and height-age; 4) HAD; and 5) stunting prevalence. Metrics were compared based on secular trends within countries and age-related trajectories within surveys. In the most recent surveys (Nâ\200‰=â\200‰64), GDs ranged from 1.9 to 19.1 months at 60 months chronological age. Cross-sectionally, HAZ, HAD and GD were perfectly correlated, and showed similar secular trends. However, age-related trajectories differed across metrics. Accumulating GD with age demonstrated growth faltering as slower than expected growth for children of the same height-age. Resumption of growth at the median for height-age was rarely observed. GD is a population-level measure of child health that reflects the role of delayed skeletal development in linear growth faltering.
    ## 6                                                                                                                                                                                                                                                Given the roll out of maternal antiretroviral therapy (ART) for prevention-of-perinatal-HIV-transmission, increasing numbers of children are perinatally HIV/ART exposed but uninfected (CAHEU). Some studies suggest CAHEU may be at increased risk for neurodevelopmental (ND) deficits. We aimed to assess ND performance among preschool CAHEU. This cross-sectional study assessed ND outcomes among 3-6-year-old CAHEU at entry into a multicountry cohort study. We used the Mullen Scales of Early Learning (MSEL) and Kaufman Assessment Battery for Children (KABC-II) to assess ND status among 3-6-year-old CAHEU at entry into the PROMISE Ongoing Treatment Evaluation (PROMOTE) study conducted in Uganda, Malawi, Zimbabwe and South Africa. Statistical analyses (Stata 16.1) was used to generate group means for ND composite scores and subscale scores, compared to standardized test score means. We used multivariable analysis to adjust for known developmental risk factors including maternal clinical/socioeconomic variables, child sex, growth-for-age measurements, and country. 1647 children aged 3-6â\200Šyears had baseline ND testing in PROMOTE; group-mean unadjusted Cognitive Composite scores on the MSEL were 85.8 (standard deviation [SD]: 18.2) and KABC-II were 79.5 (SD: 13.2). Composite score group-mean differences were noted by country, with South African and Zimbabwean children having higher scores. In KABC-II multivariable analyses, maternal age &gt;40â\200Šyears, lower education, male sex, and stunting were associated with lower composite scores. Among a large cohort of 3-6â\200Šyear old CAHEU from eastern/southern Africa, group-mean composite ND scores averaged within the low-normal range; with differences noted by country, maternal clinical and socioeconomic factors.
    ##   year month day           jabbrv                       journal keywords
    ## 1 2022    06  24          Viruses                       Viruses     <NA>
    ## 2 2022    06  24   Microorganisms                Microorganisms     <NA>
    ## 3 2022    06  24 Children (Basel) Children (Basel, Switzerland)     <NA>
    ## 4 2022    06  23         BMC Nutr                 BMC nutrition     <NA>
    ## 5 2022    06  23     Ann Hum Biol       Annals of human biology     <NA>
    ## 6 2022    06  22             AIDS        AIDS (London, England)     <NA>
    ##   lastname firstname address email
    ## 1     <NA>      <NA>    <NA>  <NA>
    ## 2     <NA>      <NA>    <NA>  <NA>
    ## 3     <NA>      <NA>    <NA>  <NA>
    ## 4     <NA>      <NA>    <NA>  <NA>
    ## 5     <NA>      <NA>    <NA>  <NA>
    ## 6     <NA>      <NA>    <NA>  <NA>

## Descriptive statistics

### Most popular journal

Below, we will use one of the databases created earlier to evaluate the
most popular journal that has been publishing research on stunting. Can
you guess what database this might be? `author_Base` or `articleBase`?

      popular_jrnals <- articleBase %>% 
                        group_by(jabbrv) %>% 
                        count() %>% arrange(desc(n)) %>% 
                        ungroup () %>% 
                        slice (1:10)

      ## We can also plot the result using a bar plot.
      ## we used reorder(jabbrv, n) to arrange bars on the y-axis in descending order.
      popular_jrnals %>% 
        ggplot() + geom_col(aes(x = n,
                                y = reorder(jabbrv, n))) +
        theme_bw()

![](Day2---Bibiliometrix_files/figure-markdown_strict/unnamed-chunk-3-1.png)

### Most popular authors

We can also use one of the databases created earlier to evaluate the
most popular authors that have been publishing on stunting between
2019-2022. Can you guess what database this might be? `author_Base` or
`articleBase`?

      popular_auths <- author_Base %>% 
                       ## Below, lets concatenate the the first and last names
                       mutate (full_name = paste0(firstname, " ", lastname)) %>% 
                        group_by(full_name) %>% 
                        count() %>% arrange(desc(n)) %>% 
                        ungroup () %>% 
                        slice (1:10)
      
      ## We can also plot our result using a bar plot.
      popular_auths %>% 
        ggplot() + geom_col(aes(x = n, 
                                y = reorder(full_name, n),
                                fill = full_name)) +
        theme_bw() + theme(legend.position = "none") +
        labs (y = "Authors", x = "Number of Publications")

![](Day2---Bibiliometrix_files/figure-markdown_strict/unnamed-chunk-4-1.png)

### Most popular countries of affiliation

We can also use one of the databases created earlier to evaluate where
most of the authors are located. Can you guess what database this might
be? `author_Base` or `articleBase`?

    ## Below, we will extract countries of affiliation from the addresses provided in the database. We can use str_remove() to remove part of texts that we don't want and text that match a criteria.
      author_Base_updt <- author_Base %>% 
                          filter(doi !="") %>% 
                          mutate (country = str_remove(address, ".*, ")) %>% 
                          mutate (country = str_remove(country, pattern = "\\..*")) %>% 
                          mutate (country = str_remove(country, pattern = "[0-9]+"))

After a thorough cleaning, there appears to be so many authors whose
country of affiliation can not be identified. We can create separate
databases, one with author the lenght of country of affiliation less
than 25 characters and another that is more than 25 characters.

        auth_okay <- author_Base_updt %>% 
                     filter (str_length(country) < 25 & !is.na(country))
        auth_NotOkay <- author_Base_updt %>% 
                     filter (str_length(country) >= 25 & !is.na(country))

For the authors with countries of affiliation that are more than 25
characters, we could search within the texts for countries. We could do
this by first downloading/importing a table of countries into R and
subsequently, check our database line by line to see if any of the long
texts includes any of the country in the downloaded table.

      url <- "https://www.worldometers.info/geography/alphabetical-list-of-countries/"
      countries <- url %>% read_html() %>% html_table() %>%.[[1]]

          for (n in 1:nrow(auth_NotOkay)) {
          
          ut <- sub("\\.", "", auth_NotOkay$country[n])
          
          for (i in 1:nrow(countries)) {
            
            if (str_detect(ut, countries$Country[i]) == TRUE) {
              
              auth_NotOkay$country[n] <- countries$Country[i]
              
              cat(paste0("done ", countries$Country[i], "\n"))
              
              break
              
            }
            
          }
          
        }

    ## done Democratic Republic of the Congo
    ## done Democratic Republic of the Congo
    ## done Cameroon
    ## done Cameroon
    ## done Cameroon
    ## done Cameroon
    ## done Cameroon
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done Niger
    ## done Indonesia
    ## done Ethiopia
    ## done Ethiopia
    ## done Ethiopia
    ## done Ethiopia
    ## done Ethiopia
    ## done Ethiopia
    ## done Ethiopia
    ## done Ethiopia
    ## done Gambia
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done Germany
    ## done Germany
    ## done Kenya
    ## done Kenya
    ## done Kenya
    ## done Ethiopia
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China
    ## done Democratic Republic of the Congo
    ## done Democratic Republic of the Congo
    ## done Democratic Republic of the Congo
    ## done Democratic Republic of the Congo
    ## done Democratic Republic of the Congo
    ## done Democratic Republic of the Congo
    ## done Zambia
    ## done Zambia
    ## done Zambia
    ## done Zimbabwe
    ## done Zimbabwe
    ## done Zimbabwe
    ## done Zimbabwe
    ## done Netherlands
    ## done Zimbabwe
    ## done Kenya
    ## done Kenya
    ## done Kenya
    ## done Indonesia
    ## done Indonesia
    ## done China
    ## done China
    ## done China
    ## done China
    ## done China

We could subsequently, manually code countries that may have been spelt
differently or in another language, e.g. UK and United Kingdom. For
authors with no countries and just their affiliation, we could infer
their country of residence from their institutional affiliation,
e.g. John Hopkins University would be US, and London School of Tropical
Medicine would be UK.

      author_database <-  rbind(auth_NotOkay, auth_okay)  %>%
                          mutate (country = ifelse(str_detect(country, "Congo"),
                                                   "Democratic Republic of Congo",
                                                   country),
                                  country = ifelse(str_detect(country, "USA|Harvard|Johns Hopkins"),
                                                   "USA", country),
                                  country = ifelse(str_detect(country, "Korea"),
                                                   "Korea", country),
                                  country = ifelse(str_detect(country, "UK|London"),
                                                   "UK", country)) %>% 
        mutate (country = ifelse(str_detect(country, "Tropical|Research|University|Site|Subdirecci|Ministry|Hospital|Shahjalal|Zhejiang|Centre|Jawaharlal|Institute|Division|Department"),
                                 NA, country)) %>% 
        mutate (country = ifelse(str_detect(country, "UK"),
                                 "United Kingdom", country),
                country = ifelse(str_detect(country, "USA|United States"),
                                 "United States of America",
                                 country)) %>% 
        filter (!is.na(country) & country != "")

### Most popular country of affiliation

We can also use the updated information in the `author_Base` to count
the magnitude of knowledge production on stunting between 2019-2022
across the countries.

      popular_affCount <- author_database %>% 
                          group_by(country) %>% 
                          count() %>% arrange(desc(n)) %>% 
                          ungroup () %>% 
                          slice (1:10)
      
      popular_affCount %>% 
        ggplot() + geom_col(aes(x = n, 
                                y = reorder(country, n),
                                fill = country)) +
        geom_text(aes(x = n-30, 
                  y = reorder(country, n),
                  label = n),
                  color = "white") +
        theme_bw() + theme(legend.position = "none") +
        labs (y = "Authors", x = "Number of Publications")

![](Day2---Bibiliometrix_files/figure-markdown_strict/unnamed-chunk-9-1.png)

### Number of authors and magnitude of international collaboration

We can also use information on the countries of affiliation to quantify
international collaborations among the authors per article. To achieve
this, we could count the number of unique countries for each paper. We
could also count the number of authors on each paper.

    n_authors <- author_database %>% 
                  group_by(title) %>% 
                  mutate (collabo = length(unique(country))) %>% 
                  ungroup () %>%
                  group_by (title) %>%
                  mutate (n_auth = length(title)) %>% 
                  slice(1) %>% 
                  select (doi, n_auth, collabo)

    ## Adding missing grouping variables: `title`

    ## Examine summary descriptive characteristics for the number of authors/paper
    summary(n_authors$n_auth)

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   1.000   3.500   5.000   6.702   8.000 114.000

    ## Examine summary descriptive characteristics for the number of countries/paper
    summary(n_authors$collabo)

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   1.000   1.000   1.000   1.879   2.000  33.000
