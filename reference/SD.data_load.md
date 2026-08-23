# retrieve scverse-curated \`SpatialData\` .zarr archive

This function consolidates the retrieval and caching and transformation
of scverse-curated Zarr archives and 10x-curated Xenium archives.

## Usage

``` r
SD.data_load(id, target = tempfile(), source)
```

## Arguments

- id:

  character string; dataset identifier

- target:

  character(1), defaults to tempfile(); use a different value if you
  wish to retain the unzipped .zarr store persistently.

- source:

  The name of the source, i.e. query bucket.

  biocOSN

  :   Bioc's Open Storage Network (NSF) OSN bucket (spatialdata v0.3.0,
      zarr v2)

  biocOSN_Xenium

  :   Raw Xenium readouts from Bioc's Open Storage Network (NSF) OSN
      bucket.

  sandbox

  :   scverse's spatialdata-sandbox bucket at EMBL.

## Value

an instance of SpatialData, or throws an error if the dataset identifier
(id)does not uniquely match the name of any resource, see
[SD.data_list](https://helenalc.github.io/SpatialData.data/reference/SD.data_list.md)
for the list of datasets.

## Details

- MouseIntestineVisHD: Visium HD 3.0.0 (10x Genomics) dataset of mouse
  intestine; source (biocOSN):
  <https://www.10xgenomics.com/datasets/visium-hd-cytassist-gene-expression-libraries-of-mouse-intestine>

- MouseBrainVisHD: Visium HD 4.0.1 (10x Genomics) dataset of mouse
  brain; source (sandbox):
  <https://www.10xgenomics.com/datasets/visium-hd-three-prime-mouse-brain-fresh-frozen>

- MouseBrainVis: Visium (10x Genomics) dataset of mouse brain; source
  (sandbox):
  <https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-MTAB-11114>

- LungAdenocarcinomaMCMICRO: MCMICRO dataset of human small cell lung
  adenocarcinoma; source (biocOSN)

- MouseBrainMERFISH: MERFISH dataset of mouse brain tissue; source
  (biocOSN)

- MouseLiverMERFISH: MERFISH dataset of mouse liver tissue (SPArrOW
  output); source (sandbox):
  <https://www.biorxiv.org/content/10.1101/2024.07.04.601829v1>

- MulticancerSteinbock: imaging mass cytometry dataset of four cancers;
  source (biocOSN): <https://www.nature.com/articles/s41596-023-00881-0>

- ColorectalCarcinomaMIBITOF: MIBI-TOF dataset of colorectal carcinoma;
  source (biocOSN)

- JanesickBreastVisiumEnh: Visium (10x Genomics) dataset of breast
  cancer; source (biocOSN):
  <https://www.nature.com/articles/s41467-023-43458-x>

- JanesickBreastXeniumRep1: first of two Xenium (10x Genomics) sections
  associated with the Visium section from Janesick *et al.*; source
  (biocOSN)

- JanesickBreastXeniumRep2: second of two Xenium (10x Genomics) sections
  associated with the Visium section from Janesick *et al.*; source
  (biocOSN)

- Breast2fov_10x: Xenium (10x Genomics) data on breast cancer, trimmed
  to 2 FOVs; source (biocOSN_Xenium):
  <https://www.10xgenomics.com/support/software/xenium-onboard-analysis/latest/resources/xenium-example-data>

- Lung2fov_10x: Xenium (10x Genomics) data on lung cancer, trimmed to 2
  FOVs; source (biocOSN_Xenium):
  <https://www.10xgenomics.com/support/software/xenium-onboard-analysis/latest/resources/xenium-example-data>

- HumanLungMulti_10x: Xenium (10x Genomics) data on lung cancer; source
  (biocOSN):
  <https://www.10xgenomics.com/datasets/preview-data-ffpe-human-lung-cancer-with-xenium-multimodal-cell-segmentation-1-standard>

- SpaceMHelaniH3T3: SpaceM on Hepa and NIH3T3 cells; source (sandbox);
  more info:
  <https://github.com/giovp/spatialdata-sandbox/blob/main/spacem_helanih3t3/README.md>

## Examples

``` r
Sys.setenv(AWS_REGION = "us-east-1")

# load using `SD.data_load`
ld <- SD.data_load("ColorectalCarcinomaMIBITOF")
#> caching mibitof.zip
#> 
ld
#> class: SpatialData
#> - images(3):
#>   - point16_image (3,1024,1024)
#>   - point23_image (3,1024,1024)
#>   - point8_image (3,1024,1024)
#> - labels(3):
#>   - point16_labels (1024,1024)
#>   - point23_labels (1024,1024)
#>   - point8_labels (1024,1024)
#> - points(0):
#> - shapes(0):
#> - tables(1):
#>   - table (36,3309) [point8_labels,point16_labels,point23_labels]
#> coordinate systems(3):
#> - point16(2): point16_image point16_labels
#> - point23(2): point23_image point23_labels
#> - point8(2): point8_image point8_labels

# TODO: zarr v3 read is not complete
# # use sandbox as source
# ld <- SD.data_load("ColorectalCarcinomaMIBITOF", source = "sandbox")
```
