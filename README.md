# Data Cleaning with AI Support

## Student Information
- **Name:** Kristoffer Neo Senyahan
- **GitHub:** https://github.com/magneofico
- **Date:** 2025-11-23

## Dataset
- Source: Kaggle — Titanic (https://www.kaggle.com/c/titanic)
- Name: Titanic - Machine Learning from Disaster

> **How to add data:** Download `train.csv` from the Kaggle Titanic competition and save it to `data/raw_dataset.csv` in this repo.

## Issues found (expected for Titanic)
- Missing values: `Age`, `Cabin`, and some `Embarked` values are missing
- Duplicates: Possible duplicate passengers based on `Name`/`Ticket`/`Cabin` combos
- Inconsistencies: Mixed casing in `Sex`/`Embarked`; whitespace/ticket formatting
- Outliers: Unusually high `Fare`; extreme `Age` values (if any)

## Cleaning steps (high level)
1. **Standardize string formats** → lowercase, strip whitespace from `Sex` and `Embarked`
2. **Handle missing values:**
   - Impute `Age` with median by `Pclass` and `Sex` (respects socioeconomic patterns)
   - Fill `Embarked` with mode (most frequent port)
   - Fill `Fare` with median
   - Extract `Deck` letter from `Cabin`; fill unknown values with 'U'
3. **Optimize data types** → convert categorical columns (`Sex`, `Embarked`, `Pclass`, `Deck`) to category dtype (saves ~40% memory)
4. **Remove duplicates** → drop exact duplicate rows
5. **Detect & treat outliers** → IQR-based winsorization for `Age` and `Fare` (k=1.5)
6. **Feature engineering** → create `HasCabin` binary indicator; drop sparse `Cabin` column

## Key improvements
- **Memory:** ~58 KB → ~35 KB (40% reduction with categorical encoding)
- **Correlations:** Cleaned data shows stronger relationships (e.g., Fare ↔ HasCabin: 0.618 vs 0.482)
- **Data completeness:** All numeric columns now have no missing values

## AI Prompts Used

### Prompt 1: Age Imputation Strategy
**Request:**
> "Generate Pandas code to impute missing 'Age' values using median grouped by 'Pclass' and 'Sex'. This respects socioeconomic and gender patterns in the Titanic dataset. Include a check for any remaining NaN values and fill with overall median."

**Outcome:** Vectorized imputation using `groupby().transform('median')` instead of row-by-row apply (more efficient)

### Prompt 2: Categorical Encoding for Memory Optimization
**Request:**
> "Convert low-cardinality string columns ('Sex', 'Embarked', 'Pclass') to Pandas category dtype to reduce memory usage. Show memory usage before and after."

**Outcome:** ~40% memory reduction (58 KB → 35 KB); faster groupby operations

### Prompt 3: IQR-based Outlier Detection
**Request:**
> "Create a function to detect and winsorize outliers using IQR method with k=1.5 multiplier. Apply it to 'Age' and 'Fare' columns. Show summary statistics before/after treatment."

**Outcome:** `winsorize_iqr()` function clipping extreme values to reasonable bounds without losing rows

### Prompt 4: Correlation Analysis for Data Quality Assessment
**Request:**
> "Generate code to compare numeric column correlations before and after cleaning. Display raw correlations, cleaned correlations, and the absolute difference. Show only changes > 0.01. Create side-by-side heatmaps."

**Outcome:** Quantified impact—showed Fare ↔ survival correlation improved from 0.257 → 0.317

### Prompt 5: Feature Engineering from Sparse Column
**Request:**
> "Extract the first character (deck letter) from 'Cabin' column when available. Fill missing deck values with 'U' for unknown. Create a binary 'HasCabin' indicator. Explain why we drop the sparse Cabin column but keep engineered features."

**Outcome:** Deck + HasCabin features preserve cabin information while dropping 77% missing sparse column

---

## Methods & Tools
- **Imputation:** Median-by-group for Age; mode for Embarked; median for Fare
- **Outlier handling:** IQR winsorization (preserves data, doesn't delete rows)
- **Data types:** Categorical encoding for memory/speed optimization
- **Validation:** Correlation analysis before/after; distribution visualizations
- **Libraries:** Pandas, NumPy, Matplotlib, Seaborn

## Results
- **Rows before cleaning:** 891
- **Rows after cleaning:** 891 (no duplicates found)
- **Columns after cleaning:** 12 (dropped sparse `Cabin` column; added `Deck` & `HasCabin` features)
- **Memory usage:** 58 KB (raw) → 35 KB (cleaned) — **40% reduction**
- **Missing values eliminated:** Age, Fare, Embarked ✓ | Cabin preserved as features

**Key finding:** Correlation analysis shows cleaning improved data quality—stronger relationships detected after imputation and outlier treatment (e.g., Fare ↔ survival correlation increased from 0.257 → 0.317).

**Video:** [Titanic Dataset - Data Cleaning (CSC172 Data Mining)](https://youtu.be/E4jfzzuy42E)

---

### Repro steps (local)
```bash
# 1) Create and activate a virtual environment (choose one)

# Option A: venv (Python 3.10+ recommended)
python3 -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate

# Option B: conda
conda create -n csc172-clean python=3.10 -y
conda activate csc172-clean

# 2) Install packages
pip install -r requirements.txt

# 3) Add data
# Download Kaggle Titanic train.csv and place it as:
# data/raw_dataset.csv

# 4) Launch Jupyter
jupyter lab  # or: jupyter notebook
```

### Git quickstart
```bash
git init
git add .
git commit -m "Init: scaffold for CSC172 data cleaning (Titanic)"

# Create a public repo named exactly csc172-data-cleaning-<lastname> on GitHub
git branch -M main
git remote add origin https://github.com/<your-username>/csc172-data-cleaning-<lastname>.git
git push -u origin main
```

---

### Notes
- The main notebook is in `notebooks/data_cleaning.ipynb`.
- Save your cleaned CSV to `data/cleaned_dataset.csv` (already handled in the notebook).
- Cite AI prompts in this README.
- Keep commits small and descriptive.
