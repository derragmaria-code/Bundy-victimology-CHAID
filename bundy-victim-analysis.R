# ----------------------------
# Install and load required packages
# ----------------------------
if(!require(CHAID)) install.packages("CHAID", dependencies=TRUE)
if(!require(dplyr)) install.packages("dplyr")
if(!require(lubridate)) install.packages("lubridate")
library(CHAID)
library(dplyr)
library(lubridate)

# ----------------------------
# Step 1: Load dataset
# ----------------------------
data_text <- "
Victim,Age,Date,Location,Notes
Lynda_Ann_Healy,21,Feb 1 1974,Seattle_WA,First documented Bundy murder; disappeared from her home.
Donna_Gail_Manson,19,Mar 12 1974,Olympia_WA,Evergreen State College student; remains never found.
Susan_Elaine_Rancourt,18,Apr 17 1974,Ellensburg_WA,Central Washington State College student.
Roberta_Kathleen_Parks,22,May 6 1974,Corvallis_OR,Oregon State University student.
Brenda_Carol_Ball,22,Jun 1 1974,Seattle_WA,Last seen leaving a tavern.
Georgeann_Hawkins,18,Jun 11 1974,Seattle_WA,UW student abducted near sorority house.
Janice_Ott,23,Jul 14 1974,Issaquah_WA,Abducted from Lake Sammamish State Park.
Denise_Naslund,19,Jul 14 1974,Issaquah_WA,Abducted same day as Janice Ott.
Nancy_Wilcox,16,Oct 2 1974,Holladay_UT,High school student.
Melissa_Smith,17,Oct 18 1974,Midvale_UT,Police chief’s daughter.
Laura_Aime,17,Oct 31 1974,Lehi_UT,Body found on Thanksgiving Day.
Carol_DaRonch,18,Nov 8 1974,Murray_UT,Survived kidnapping; Bundy convicted.
Debra_Kent,17,Nov 8 1974,Bountiful_UT,Disappeared same night as DaRonch attack.
Caryn_Sue_Campbell,23,Jan 12 1975,Aspen_CO,Michigan nurse; body found frozen in snow.
Julie_Cunningham,26,Mar 15 1975,Vail_CO,Disappeared while walking to meet a friend.
Denise_Oliverson,25,Apr 6 1975,Grand_Junction_CO,Abducted while bicycling.
Lynette_Culver,12,May 6 1975,Pocatello_ID,Middle school student; Bundy confessed later.
Susan_Curtis,15,Jun 28 1975,Provo_UT,Disappeared from BYU campus.
Margaret_Bowman,21,Jan 15 1978,Tallahassee_FL,Chi Omega sorority house victim.
Lisa_Levy,20,Jan 15 1978,Tallahassee_FL,Chi Omega sorority house victim.
Kimberly_Leach,12,Feb 9 1978,Lake_City_FL,Last known Bundy victim; abducted from school.
"

data <- read.csv(text = data_text, stringsAsFactors = FALSE)

# ----------------------------
# Step 2: Preprocess data
# ----------------------------

# Extract State from Location
data$State <- sapply(strsplit(data$Location, "_"), function(x) tail(x,1))
data$State <- as.factor(data$State)

# Convert Age to categorical variable
data$AgeGroup <- cut(data$Age,
                     breaks=c(0,15,20,25,30),
                     labels=c("Child","Teen","YoungAdult","Adult"))

# Extract Month from Date
data$Date <- mdy(data$Date)
data$Month <- factor(month(data$Date, label=TRUE))

# ----------------------------
# Step 3: Extract keywords from Notes
# ----------------------------
keywords <- c("sorority","school","college","home","tavern","campus","body","abducted","survived")

for (kw in keywords){
  data[[kw]] <- ifelse(grepl(kw, data$Notes, ignore.case = TRUE), kw, "None")
  data[[kw]] <- as.factor(data[[kw]])
}

# ----------------------------
# Step 4: Ensure all predictors are factors and handle NAs
# ----------------------------
predictors <- c("AgeGroup","Month",keywords)
for (col in predictors){
  data[[col]] <- addNA(data[[col]])
  levels(data[[col]])[is.na(levels(data[[col]]))] <- "None"
}

# ----------------------------
# Step 5: Build CHAID tree
# ----------------------------
formula <- as.formula(paste("State ~", paste(predictors, collapse="+")))

chaid_model <- chaid(formula, data = data,
                     control = chaid_control(minbucket = 1, minsplit = 1, alpha2 = 0.05))

# ----------------------------
# Step 6: Plot CHAID tree
# ----------------------------
plot(chaid_model, main="CHAID Tree Predicting State with Notes Keywords")

# ----------------------------
# Step 7: Predict probabilities for each state
# ----------------------------
probs <- predict(chaid_model, newdata = data, type = "prob")
print(probs)

# ----------------------------
# Step 8: Rank predictors by Chi-square
# ----------------------------
chi_results <- sapply(predictors, function(col){
  tbl <- table(data[[col]], data$State)
  chisq <- chisq.test(tbl)
  c(ChiSq=chisq$statistic, Pvalue=chisq$p.value)
})

chi_results <- t(chi_results)
chi_results <- as.data.frame(chi_results)
chi_results <- chi_results[order(chi_results$Pvalue), ]
print("Predictors ranked by strength of association with State (low p-value = stronger)")
print(chi_results)
