{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "b88d367f",
   "metadata": {
    "papermill": {
     "duration": 0.002781,
     "end_time": "2023-05-08T05:03:44.869612",
     "exception": false,
     "start_time": "2023-05-08T05:03:44.866831",
     "status": "completed"
    },
    "tags": []
   },
   "source": []
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "cfdb1401",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-05-08T05:03:44.879256Z",
     "iopub.status.busy": "2023-05-08T05:03:44.876670Z",
     "iopub.status.idle": "2023-05-08T05:03:48.113684Z",
     "shell.execute_reply": "2023-05-08T05:03:48.111577Z"
    },
    "papermill": {
     "duration": 3.244336,
     "end_time": "2023-05-08T05:03:48.116228",
     "exception": false,
     "start_time": "2023-05-08T05:03:44.871892",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<style>\n",
       ".list-inline {list-style: none; margin:0; padding: 0}\n",
       ".list-inline>li {display: inline-block}\n",
       ".list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
       "</style>\n",
       "<ol class=list-inline><li>'input'</li><li>'kaggle_bigquery.R'</li><li>'kaggle_secrets.R'</li><li>'lib'</li><li>'src'</li><li>'template_conf.json'</li><li>'working'</li></ol>\n"
      ],
      "text/latex": [
       "\\begin{enumerate*}\n",
       "\\item 'input'\n",
       "\\item 'kaggle\\_bigquery.R'\n",
       "\\item 'kaggle\\_secrets.R'\n",
       "\\item 'lib'\n",
       "\\item 'src'\n",
       "\\item 'template\\_conf.json'\n",
       "\\item 'working'\n",
       "\\end{enumerate*}\n"
      ],
      "text/markdown": [
       "1. 'input'\n",
       "2. 'kaggle_bigquery.R'\n",
       "3. 'kaggle_secrets.R'\n",
       "4. 'lib'\n",
       "5. 'src'\n",
       "6. 'template_conf.json'\n",
       "7. 'working'\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       "[1] \"input\"              \"kaggle_bigquery.R\"  \"kaggle_secrets.R\"  \n",
       "[4] \"lib\"                \"src\"                \"template_conf.json\"\n",
       "[7] \"working\"           "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"available files...\"\n",
      "[1] \"sample_submission.csv\" \"test_data.csv\"         \"train_data.csv\"       \n",
      "[4] \"train_labels.csv\"     \n",
      "Number of threads for data.table: 2\n"
     ]
    }
   ],
   "source": [
    "\n",
    "suppressPackageStartupMessages(library(data.table)) \n",
    "suppressPackageStartupMessages(library(tidyverse))\n",
    "suppressPackageStartupMessages(library(dtplyr)) #data.table with tidy syntax\n",
    "suppressPackageStartupMessages(library(arrow))\n",
    "suppressPackageStartupMessages(library(glmnet))\n",
    "\n",
    "dir(\"..\")\n",
    "print('available files...')\n",
    "list.files(path = \"../input/amex-default-prediction\") %>% print()\n",
    "\n",
    "pqt_dir <- '../input/amex-data-integer-dtypes-parquet-format'\n",
    "csv_dir <- '../input/amex-default-prediction'\n",
    "dt_threads <- getDTthreads()\n",
    "cat(paste(\"Number of threads for data.table: \", dt_threads, \"\\n\", sep=\"\"))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "0e372f39",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-05-08T05:03:48.185069Z",
     "iopub.status.busy": "2023-05-08T05:03:48.122272Z",
     "iopub.status.idle": "2023-05-08T05:03:50.037431Z",
     "shell.execute_reply": "2023-05-08T05:03:50.035208Z"
    },
    "papermill": {
     "duration": 1.922146,
     "end_time": "2023-05-08T05:03:50.040627",
     "exception": false,
     "start_time": "2023-05-08T05:03:48.118481",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Time to load training labels..\"\n"
     ]
    },
    {
     "data": {
      "text/plain": [
       "Time difference of 1.737854 secs"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Number of rows\"\n"
     ]
    },
    {
     "data": {
      "text/html": [
       "458913"
      ],
      "text/latex": [
       "458913"
      ],
      "text/markdown": [
       "458913"
      ],
      "text/plain": [
       "[1] 458913"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Number of IDs\"\n"
     ]
    },
    {
     "data": {
      "text/html": [
       "458913"
      ],
      "text/latex": [
       "458913"
      ],
      "text/markdown": [
       "458913"
      ],
      "text/plain": [
       "[1] 458913"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"columns in target data.. customer_ID\"\n",
      "[2] \"columns in target data.. target\"     \n"
     ]
    }
   ],
   "source": [
    "#pull in training labels\n",
    "t1 <- Sys.time()\n",
    "train_Y <- fread(\"../input/amex-default-prediction/train_labels.csv\") %>% as_tibble()\n",
    "t2 <- Sys.time()\n",
    "\n",
    "print('Time to load training labels..')\n",
    "difftime(t2,t1, units=\"secs\")\n",
    "print('Number of rows')\n",
    "train_Y %>% nrow()\n",
    "print('Number of IDs')\n",
    "train_Y %>% distinct(customer_ID) %>% nrow()\n",
    "print(paste('columns in target data..',colnames(train_Y)))"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "cac7c816",
   "metadata": {
    "papermill": {
     "duration": 0.002807,
     "end_time": "2023-05-08T05:03:50.046355",
     "exception": false,
     "start_time": "2023-05-08T05:03:50.043548",
     "status": "completed"
    },
    "tags": []
   },
   "source": []
  },
  {
   "cell_type": "markdown",
   "id": "fe47e034",
   "metadata": {
    "papermill": {
     "duration": 0.002495,
     "end_time": "2023-05-08T05:03:50.051680",
     "exception": false,
     "start_time": "2023-05-08T05:03:50.049185",
     "status": "completed"
    },
    "tags": []
   },
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "R",
   "language": "R",
   "name": "ir"
  },
  "language_info": {
   "codemirror_mode": "r",
   "file_extension": ".r",
   "mimetype": "text/x-r-source",
   "name": "R",
   "pygments_lexer": "r",
   "version": "4.0.5"
  },
  "papermill": {
   "default_parameters": {},
   "duration": 8.827908,
   "end_time": "2023-05-08T05:03:50.304520",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2023-05-08T05:03:41.476612",
   "version": "2.4.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
