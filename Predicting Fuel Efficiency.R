Capstone Project Predicting Fuel Efficiency
1: Business Understanding
Problem Statement: Predict a car’s fuel efficiency (miles per gallon, mpg) based on its characteristics.

Stakeholders: Car manufacturers, consumers, policymakers.

Success Metric: Accuracy of prediction (e.g., RMSE for regression).

2: Data Understanding
Loading and exploring the dataset:
data(mtcars)   # loads the dataset
str(mtcars)    # structure of the data
summary(mtcars) # descriptive statistics

3: Data Preparation
The dataset is already clean, but we can engineer features and select predictors. For example:

Weight (wt) and horsepower (hp) are likely strong predictors of mpg.

Number of cylinders (cyl) could also matter.
library(dplyr)
data(mtcars)

# Select relevant predictors
cars <- mtcars %>%
  select(mpg, wt, hp, cyl)

# Quick check
head(cars)
This gives us a clean dataset with mpg (target) and predictors.

4: Modeling
Linear regression model
model <- lm(mpg ~ wt + hp + cyl, data=cars)
summary(model)

5: Evaluation of fuel efficiency
#making predictions
predictions <- predict(model, cars)
head(predictions)

#comparing predictions with actual values
results <- data.frame(
  actual = cars$mpg,
  predicted = predictions
)
head(results)

#calculating error metrics
rmse <- sqrt(mean((results$actual - results$predicted)^2))
rmse

#visualizing fit
library(ggplot2)
ggplot(results, aes(x=actual, y=predicted)) +
  geom_point(color="blue") +
  geom_abline(slope=1, intercept=0, linetype="dashed", color="red") +
  labs(title="Actual vs Predicted MPG")

6: Deployment & Communication
#Polished Visualizations with ggplot2
library(ggplot2)

ggplot(mtcars, aes(x=wt, y=mpg, color=factor(cyl))) +
  geom_point(size=3) +
  geom_smooth(method="lm", se=FALSE) +
  labs(title="Fuel Efficiency vs Weight",
       x="Car Weight (1000 lbs)",
       y="Miles per Gallon",
       color="Cylinders")

#Interactive Dashboard with Shiny
install.packages("shiny", repos = "https://cloud.r-project.org")
library(shiny)

ui <- fluidPage(
  titlePanel("Fuel Efficiency Predictor"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("wt", "Weight (1000 lbs):", min=1.5, max=5.5, value=3),
      sliderInput("hp", "Horsepower:", min=50, max=350, value=150),
      sliderInput("cyl", "Cylinders:", min=4, max=8, value=6, step=2)
    ),
    mainPanel(
      textOutput("prediction")
    )
  )
)

server <- function(input, output) {
  model <- lm(mpg ~ wt + hp + cyl, data=mtcars)
  output$prediction <- renderText({
    newdata <- data.frame(wt=input$wt, hp=input$hp, cyl=input$cyl)
    pred <- predict(model, newdata)
    paste("Predicted MPG:", round(pred, 2))
  })
}

shinyApp(ui, server)

Conclusion
Weight, horsepower, and cylinders are strong predictors of fuel efficiency.

The model provides actionable insights for manufacturers and consumers.

Future work: test additional predictors (e.g., transmission type, displacement).
