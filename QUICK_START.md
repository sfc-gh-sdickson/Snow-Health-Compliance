# Snow Health Compliance - Quick Start Guide

## 🚀 5-Minute Setup

### Prerequisites
- Snowflake account with Cortex Intelligence enabled
- ACCOUNTADMIN or equivalent privileges
- X-SMALL or larger warehouse available

---

## Step 1: Execute SQL Scripts (20-30 minutes)

Open Snowsight and execute in order:

```sql
-- 1. Database setup (< 1 second)
@sql/setup/01_database_and_schema.sql

-- 2. Create tables (< 5 seconds)
@sql/setup/02_create_tables.sql

-- 3. Generate data (5-15 minutes)
@sql/data/03_generate_synthetic_data.sql

-- 4. Create views (< 10 seconds)
@sql/views/04_create_views.sql

-- 5. Create semantic views (< 5 seconds)
@sql/views/05_create_semantic_views.sql

-- 6. Create Cortex Search (3-5 minutes)
@sql/search/06_create_cortex_search.sql
```

---

## Step 2: Create Intelligence Agent (5 minutes)

1. In Snowsight → **AI & ML** → **Agents**
2. Click **+ Agent**
3. Name: `SNOW_HEALTH_INTELLIGENCE_AGENT`
4. Description: `Healthcare compliance and training intelligence`
5. Warehouse: `SNOW_HEALTH_WH`

---

## Step 3: Add Semantic Views (3 minutes)

In your agent → **Data** → **+ Add Data**:

1. Add `SNOW_HEALTH_INTELLIGENCE.ANALYTICS.SV_LEARNING_CREDENTIALING_INTELLIGENCE`
2. Add `SNOW_HEALTH_INTELLIGENCE.ANALYTICS.SV_SUBSCRIPTION_REVENUE_INTELLIGENCE`
3. Add `SNOW_HEALTH_INTELLIGENCE.ANALYTICS.SV_ORGANIZATION_SUPPORT_INTELLIGENCE`

---

## Step 4: Add Cortex Search (3 minutes)

In your agent → **Tools** → **+ Add** → **Search**:

1. Add `SNOW_HEALTH_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH`
2. Add `SNOW_HEALTH_INTELLIGENCE.RAW.INCIDENT_REPORTS_SEARCH`
3. Add `SNOW_HEALTH_INTELLIGENCE.RAW.TRAINING_MATERIALS_SEARCH`

---

## Step 5: Test Your Agent (2 minutes)

Try these questions in the agent chat:

```
"How many employees have overdue mandatory training?"

"Which providers have credentials expiring in the next 90 days?"

"Show me incident reports about medication errors"

"What are the top support issues by category?"

"Which organizations are at risk of churn based on low usage?"
```

---

## ✅ You're Done!

Your Snow Health Intelligence Agent is ready to use.

### Next Steps (Optional)

**Add ML Models** for predictive analytics:
1. Open `notebooks/snow_health_ml_models.ipynb` in Snowflake Notebooks
2. Add packages: `snowflake-ml-python`, `scikit-learn`, `xgboost`
3. Run all cells to train 3 ML models
4. Execute `sql/ml/07_create_model_wrapper_functions.sql`
5. Add models to agent as tools

See `docs/NOTEBOOK_ML_GUIDE.md` for detailed ML setup instructions.

---

## 📚 Full Documentation

- **README.md**: Complete solution overview
- **docs/AGENT_SETUP.md**: Detailed agent configuration
- **docs/questions.md**: 13 sample test questions
- **docs/NOTEBOOK_ML_GUIDE.md**: ML models guide
- **CONVERSION_SUMMARY.md**: Architecture and details

---

## 🆘 Troubleshooting

**Issue**: Cortex Search service creation fails  
**Solution**: Ensure Cortex Intelligence is enabled on your account

**Issue**: Semantic views not visible in agent  
**Solution**: Verify you have SELECT privileges on ANALYTICS schema

**Issue**: Agent gives incomplete answers  
**Solution**: Check that all 3 semantic views are added as data sources

**Issue**: Data generation is slow  
**Solution**: Increase warehouse size to SMALL or MEDIUM temporarily

---

## 💡 Pro Tips

- Use SMALL warehouse for faster data generation
- Test Cortex Search directly with `SNOWFLAKE.CORTEX.SEARCH_PREVIEW()` function
- Review `docs/questions.md` for more sophisticated test questions
- Monitor agent performance in Snowsight → Activity → Agents

---

**Estimated Total Setup Time**: 30-45 minutes  
**Data Volume**: 1.5M+ records, 500K employees, 25K transcripts
