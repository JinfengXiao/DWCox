#!/bin/bash
if [[ ! -e data/train.csv ]]; then
    echo 'No training data were detected!'
    exit 1
fi
if [[ ! -e data/task.csv ]]; then
    echo 'No data for prediction were detected!'
    exit 1
fi
Rscript predict.r data/train.csv data/task.csv data/pred_risk.csv data/pred_days.csv