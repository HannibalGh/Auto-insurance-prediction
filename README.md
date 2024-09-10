# **"Predictive Modeling for Auto Insurance Claims: Building a Data Pipeline and Machine Learning Solution on Azure"**

This repository features a data engineering and machine learning project focused on constructing a pipeline and developing a machine learning model to predict the likelihood of auto insurance claims leveraging Azure cloud tools and services. The model uses various individual characteristics, such as age, income, and claims history. 

## **Project Overview:**

- **Objective:** Predict the likelihood of auto insurance claims based on customer data, leveraging historical claim patterns and customer characteristics. The project also focuses on building robust data pipelines to manage large datasets and using machine learning models for predictions.
  
## **Key Components:**
  
1. **Data Engineering:**
   - **Data Ingestion**: Use Azure Data Lake to store large volumes of customer and claims data.
   - **Data Transformation**: Clean and preprocess the data using PySpark on Azure Databricks, including encoding categorical variables and feature scaling.
   - **Feature Engineering**: Convert categorical variables into numerical values to make them suitable for model training.
     
2. **Machine Learning:**
   - **Model Selection**: Train predictive models using a Random Forest algorithm to classify the likelihood of a customer filing an auto insurance claim.
   - **Model Training**: Build the model on Azure Databricks.
   - **Evaluation**: Assess model performance using metrics like accuracy, precision, recall, F1-score, and ROC AUC.
  
3. **Data Insights & Visualization:**
   - **Power BI Integration**: Visualize predicted vs. actual outcomes, feature importance, claim distribution by gender, and other key insights using Power BI.

## **Technology Stack:**
- **Data Storage**: Azure Data Lake
- **Data Processing**: Azure Databricks (PySpark)
- **Modeling**: Random Forest Classification (PySpark MLlib)
- **Data Visualization**: Power BI

This project demonstrates the creation of a scalable data pipeline and effective machine learning model to provide actionable insights for the auto insurance industry.

## Challenges Faced

Throughout this project, several challenges were encountered and addressed:

### Dataset and Data Quality
- **Finding the Appropriate Dataset**: Identifying a suitable dataset with sufficient data columns for modeling was a challenge. Ensuring that the dataset contained relevant features and sufficient data was crucial for building a robust model.
- **Encoding Categorical Fields**: Converting categorical fields such as age, driving experience, and income into numerical values that the model could interpret was necessary. This involved careful preprocessing and encoding to ensure the model could effectively use these features.
- **Handling Missing or Inconsistent Data**: Addressing missing or inconsistent data required data imputation or removal of problematic entries. This process was essential to maintain the quality and reliability of the dataset.

### Data Pipeline and Model Training
- **Connecting the Mount Correctly**: Ensuring proper connection to the mount using the security key and verifying that all data was correctly accessed and processed was a challenge.
- **Integrating All Columns**: Ensuring that all columns were integrated into the model via the encoder was important. Some columns were initially excluded due to data type mismatches, which required adjustments to include all relevant features.

### Performance and Optimization
- **Performance Optimization**: Optimizing the data pipeline and machine learning model involved tuning hyperparameters and optimizing data transformations. Efficient resource management was crucial to ensure smooth operation.

### Documentation and Communication
- **Documentation and Communication**: Maintaining clear and comprehensive documentation throughout the project was crucial. Documenting the data pipeline, feature engineering steps, model training processes, and any issues encountered helped in effective communication and collaboration.

These challenges were addressed through iterative development, testing, and collaboration, leading to a successful implementation of the data pipeline and machine learning model.

## Conclusions

This project successfully implemented an end-to-end data pipeline for predicting auto insurance claims using Azure cloud tools and a machine learning model developed in Databricks. The model demonstrated solid performance across key metrics:

- **ROC AUC**: 0.88 — Indicating strong ability to distinguish between claims and non-claims.
- **Accuracy**: 80.93% — The model correctly predicted approximately 81% of outcomes.
- **Precision**: 80.56% — Among the predicted claims, around 81% were correct.
- **Recall**: 80.93% — The model captured 81% of actual claims.
- **F1 Score**: 80.26% — Balancing precision and recall for consistent performance.

### Key Findings and Correlations

- **Underestimation for Upper-Class Males (Ages 26-39)**: The model tended to underestimate claims for upper-income males of the majority race aged 26 to 39, while performing accurately for other groups.
  
- **Driving Experience and Past Accidents as Key Predictors**: **Driving Experience** (0.256) and **Past Accidents** (0.116) were the strongest predictors of claims. These findings align with expectations, as both factors are closely tied to driving risk.

- **Race and Vehicle Type as Additional Risk Factors**: **Race** (0.187) and **Vehicle Type** (0.114) also played significant roles in claim predictions, indicating that these features may inform insurance risk assessments.

### Feature Importance

The following table outlines the most influential features for the model:

| Feature                  | Importance  |
|--------------------------|-------------|
| **DRIVING_EXPERIENCE**    | 0.256422    |
| **RACE_OHE**              | 0.186901    |
| **PAST_ACCIDENTS**        | 0.116049    |
| **VEHICLE_TYPE_OHE**      | 0.113588    |
| **POSTAL_CODE_OHE**       | 0.058018    |
| **SPEEDING_VIOLATIONS**   | 0.038767    |
| **CREDIT_SCORE**          | 0.022754    |
| **AGE_OHE**               | 0.021312    |
| **VEHICLE_YEAR_OHE**      | 0.016856    |
| **VEHICLE_OWNERSHIP_OHE** | 0.015117    |
| **GENDER_OHE**            | 0.010444    |
| **ANNUAL_MILEAGE**        | 0.005371    |
| **EDUCATION**             | 0.001711    |
| **MARRIED_OHE**           | 0.001647    |
| **INCOME_OHE**            | 0.000853    |
| **DUIS**                  | 0.000767    |
| **CHILDREN_OHE**          | 0.000409    |

### Business Implications

These results can assist insurance underwriters in better assessing risk profiles and setting premium prices. The model’s focus on factors such as driving experience, past accidents, and vehicle type highlights important areas for risk evaluation. However, addressing the underperformance for certain demographics (e.g., upper-class males aged 26-39) may further improve the model's robustness.

## Folder Structure

- **`data/`**: Contains dataset files and processed data.
  - **`original_dataset/`**: Original dataset files used in the project. Which can also be downloaded directly via this [URL](https://www.kaggle.com/datasets/sagnik1511/car-insurance-data/data)
  - **`processed_data/`**: Data files that have been processed and are ready for analysis or further use.
  - **`feature_importance/`**: Files related to feature importance metrics, such as CSV files.

- **`notebooks/`**: Jupyter notebooks used for data transformation, machine learning, and analysis.
  - **`data_transformation_notebook.ipynb`**: Notebook for data transformation and machine learning model training performed in Databricks.

- **`scripts/`**: Contains scripts for setup and configuration.
  - **`setup.sh`**: Setup script for creating Azure resources and uploading data.

- **`reports/`**: Contains project reports 
  - **`AutoInsuranceDashboard.pbix`**: A Power BI report showcasing various metrics and data visualizations.
  
- **`visualizations/`**: Contains architecture diagrams and images of visualizations created with Power BI.
  - **`architecture_diagram.png`**: Diagram of the project's architecture.
  - **`feature_importance_chart.png`**: Chart showing the feature importance of different factors in predicting insurance claims.
  - **`Model_metrics.png`**: Visualization of key model performance metrics.
  - **`PowerBi_report.png`**: Screenshot of the Power BI dashboard with various insights.
  - **`predicted_vs_actual_pie_chart.png`**: Pie chart showing the comparison of predicted vs. actual claims made.
  - **`Predicted_vs_Actual_claims_made_chart.png`**: Visualization comparing predicted versus actual claims by gender, race and age.

- **`README.md`**: Provides an overview of the project, instructions for setup, usage, and other relevant details.



  
## Getting Started

### Prerequisites

- Azure CLI
- Python and required libraries (e.g., pandas, PySpark)
- An Azure account with access to Azure resources (Data Lake, Blob Storage, Databricks, etc.) 

## Steps to run project
1.Run the setup.sh bash script to setup the initial Azure environment.
2.Navigate to the Databricks studio via the Azure portal
3.Create a cluster
4.In the Azure portal, select the storage lake we are using and goto
5.Create a key and copy the 
6.Import the .pynb notebook and run it.
7.Export the .pynb file and then use Microsoft Power Bi to analyse/visualise your data
