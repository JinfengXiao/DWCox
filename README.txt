This package, WeDCox, is an adopted Cox method that is more robust against outliers in the training data and thus gives better predictions than the original Cox when the training data are expected to contain a lot of outliers. More details can be found in our manuscript (under preparation).

You are welcome to use this package, subject to the license described in LICENSE.txt. Also, please cite this paper:
(Paper under preparation)

-----------------------------------------------------------------

How to run WeDCox:

Simply execute run.sh.

WeDCox is ready to run right after being downloaded. The required data files have been simulated and put in data/. The outputs are data/pred_risk.csv and data/pred_days.csv. You can replace data/train.csv and data/task.csv with your own data files to let WeDCox do your jobs.

-----------------------------------------------------------------

Functionality:

WeDCox was originally developed to predict the risk scores and expected survival time in days of prostate cancer patients from their clinical records at the beginning of their trails. Fortunately, since the pipeline of WeDCox is completely automatic, you can easily apply it directly to other survival analysis problems, as long as you prepare your input data with the correct formatting.

-----------------------------------------------------------------

How to prepare your input data:

Please prepare 2 csv files whose formats are similar to the two in data/. They should have the same number of columns (not necessarily 22) containing real numbers or nothing. data/train.csv contains information about subjects (or patients) used to train WeDCox, while data/task.csv contains information about subjects whose survival is to be predicted by WeDCox. Each row gives all information about a subject. The first column contains the last observed survival time in days (or any unit you prefer). The second column contains either 1 or 0: 1 means the subject died (or the event happened) at the last observed survival time, while 0 means the subject remained alive (or the event had not happened) till the last observed survival time but no information about that subject is available after that time. The remaining columns are features (clinical variables, or any features you prefer) that will be used to model the survival. There should exist no missing values in the first 2 columns of data/train.csv.

Enjoy!