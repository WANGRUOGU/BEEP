# BEEP Learning for Massively Multiplexed Biological Fluorescence Imaging

## Data Availability  
The datasets used in this project are available for download at the following links:  

- **Dataset 1:** https://zenodo.org/records/14210776 
- **Dataset 2:** https://zenodo.org/records/14994141

## Setup Instructions

1. **Download the Code**  
   - Clone or download this repository and place all code files in a folder (e.g., `BEEP`).

2. **Download the Data**  
   - Download the dataset and place it in a folder named `data` inside the `BEEP` directory.

## Description

### Data  

- **BEEP Reference Images**  
  - Images of 13 labeled *E. coli* cells captured using mixed biological images.

### Code Files (`.m` MATLAB Scripts)

#### **Core Functions**
- `BEEP.m` – Implements BEEP learning.  
- `NLS.m` – Implements Non-negative Least Squares (NLS) for spectral unmixing.  
- `ExtractSignature_BEEP.m` – Extracts reference images using BEEP learning.  
- `UnmixMix_BEEP.m` – Performs spectral unmixing on mixture images using BEEP.  
- `UnmixRef_BEEP.m` – Performs spectral unmixing on reference images using BEEP.

#### **Preprocessing & Utilities**
- `BackgroundRemover.m` – Removes background noise.  
- `RemoveBackground_BEEP.m` – Removes background noise from BEEP images.  
- `imregt.m` – Performs image registration.  
- `find_max_nonzero_submatrix.m` – Identifies the largest non-zero submatrix in an image.  
- `MaxSubimage_BEEP.m` – Extracts the largest subimages.  

#### **Visualization & Analysis**
- `mixAbundances.m` – Displays estimated abundances of mixture images.  
- `refAbundances.m` – Displays estimated abundances of reference images.  

#### **Other Utility Functions**
- `EBkr.m` – Computes the Kronecker product.  
- `load_BEEP_data.m` – Loads BEEP data.  

#### **Demo**
- `demo.m` – A demonstration script showcasing BEEP spectral unmixing using the provided data.
