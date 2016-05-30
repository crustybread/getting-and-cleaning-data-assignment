Rows in all files are associated by their row index values; there is no columnar value on which to join the train and test data.

subject_train and subject_test each have 7352 records and 2947 records respectively. Each have 1 column of data, a factor from 1 to 30 identifying the participant of the study (70% of subjects are in train and 30% in test, mutually exclusive).

y_train and y_test each have 7352 records and 2947 records respectively. Each have 1 column of data, a factor from 1 to 6 identifying the type of activity.

The inertial_signal_ and _test sub-folders each contain 9 files. Each file respresents a different type of observation from either the accelerometer or gyroscope sensor. Each subject file contains 7352 (train) and 2947 (test) records of 128 numeric measurements taken approximately 2.5 seconds apart. 

x_train and x_test each have 7352/2947 records with 561 columns of numeric values (as identified in features.txt) calculated from the sensors' inertial signals data.

Two datasets are required, one for the observational data and one for the calculated data (observational data is NOT merged with calculated feature data as this is "untidy"). Both datasets are 10299 (7352 + 2947) rows. 

The observational dataset has 1152 columns (1 + 1 + (9 * 128)); subject + activity + (9 sensor types * 128 measurements)
The feature dataset has 535 columns (1 + 1 + 561); subject + activity + 561 features

Both datasets are defined by appending all observations (rows) from train and test together, consolidating column headers to remove reference to train or test.

