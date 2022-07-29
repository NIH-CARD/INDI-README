#!/bin/bash
# sbatch --cpus-per-task=10 --mem=10g --mail-type=END --time=24:00:00 run_pdf2image.sh

module load python/3.7
pip install pdf2image

python pdf2image.py