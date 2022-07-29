import os
import tempfile
from pdf2image import convert_from_path
from PIL import Image
import pandas as pd

prefix_df = pd.read_csv("PDF_file_list.txt", names=["prefixes"]) 
# Here is where you load the sample lists to convert. If it crashes just make a list of what is left and change file paths in this line.
prefix_list = prefix_df['prefixes'].unique()

for prefix in prefix_list:
  inpath = "/data/CARD/projects/INDI_genotypes/FEMALE_FTD_selection/with_header_files/PDFs/" + prefix + ".pdf"
  print("Working on converting PDF from " + inpath)
  images = convert_from_path(inpath)
  dir_path = "/data/CARD/projects/INDI_genotypes/FEMALE_FTD_selection/with_header_files/PDFs/reduced_plots/" + prefix + "/"
  os.mkdir(dir_path)
  for i, image in enumerate(images):
      fname = "/data/CARD/projects/INDI_genotypes/FEMALE_FTD_selection/with_header_files/PDFs/reduced_plots/" + prefix + "/" + str(i + 1) + ".png"
      image.save(fname, "PNG")
