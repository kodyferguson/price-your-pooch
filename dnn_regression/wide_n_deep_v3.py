# Copyright 2016 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================
"""Example code for TensorFlow Wide & Deep Tutorial using TF.Learn API."""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import ctypes
ctypes.CDLL('librt.so', mode=ctypes.RTLD_GLOBAL)

import argparse
import shutil
import sys
import tempfile
import random
import sklearn
from sklearn.model_selection import train_test_split
import pandas as pd
#from six.moves import urllib
import tensorflow as tf
import numpy as np
import csv

_CSV_COLUMNS = [
    "Breed", "Gender", "Age", "Heritage", "Sired",
    "Price", "Registered/registerable", "Current_vac", "Vet_exam", "Health_cert",
    "Health_guarantee", "Pedigree", "Travel_crate"
]
 
_CSV_COLUMN_DEFAULTS = [[''], [''], [5.8], [''], [''], [5.8], [5.8], [5.8], [5.8], [5.8],
                        [5.8], [5.8], [5.8]]


FEATURES = [
    "Breed", "Gender", "Age", "Heritage", "Sired",
    "Registered/registerable", "Current_vac", "Vet_exam", "Health_cert",
    "Health_guarantee", "Pedigree", "Travel_crate"
]
LABEL = "Price"

# To show an example of hashing:
breed = tf.feature_column.categorical_column_with_hash_bucket(
    "Breed", hash_bucket_size=20)
heritage = tf.feature_column.categorical_column_with_vocabulary_list(
    "Heritage", ["Yes", "No"])
sired = tf.feature_column.categorical_column_with_vocabulary_list(
    "Sired", ["Yes", "No"])
gender = tf.feature_column.categorical_column_with_vocabulary_list(
    "Gender", ["Female", "Male"])

# Continuous base columns.
age = tf.feature_column.numeric_column("Age")
registry = tf.feature_column.numeric_column("Registered/registerable")
vaccine = tf.feature_column.numeric_column("Current_vac")
vet = tf.feature_column.numeric_column("Vet_exam")
certificate = tf.feature_column.numeric_column("Health_cert")
guarantee = tf.feature_column.numeric_column("Health_guarantee")
pedigree = tf.feature_column.numeric_column("Pedigree")
travel = tf.feature_column.numeric_column("Travel_crate")

# Transformations.
age_buckets = tf.feature_column.bucketized_column(
    age, boundaries=[45, 90, 180, 360])

# Wide columns and deep columns.
base_columns = [
    breed, sired, heritage, gender,age
]

crossed_columns = [
    tf.feature_column.crossed_column(
        ["Sired", "Heritage"], hash_bucket_size=5),
    tf.feature_column.crossed_column(
        [age_buckets, "Gender"], hash_bucket_size=10),
    tf.feature_column.crossed_column(
        ["Health_cert", "Health_guarantee"], hash_bucket_size=10)
]

deep_columns = [
    tf.feature_column.indicator_column(sired),
    tf.feature_column.indicator_column(heritage),
    tf.feature_column.indicator_column(breed),
    tf.feature_column.indicator_column(gender),
    age,
    certificate,
    guarantee,
    vet,
    registry,
    vaccine, 
    pedigree,
    travel 	
]

def build_estimator(model_dir, model_type):
  run_config = tf.estimator.RunConfig().replace(
      session_config=tf.ConfigProto(device_count={'GPU': 0}))
  """Build an estimator."""
  if model_type == 'wide':
    m = tf.estimator.LinearRegressor(
        model_dir=model_dir,
        feature_columns=base_columns,
        config=run_config)
  elif model_type == 'deep':
    m =  tf.estimator.DNNRegressor(
        model_dir=model_dir,
        feature_columns=deep_columns,
        hidden_units=[16],
	config=run_config)
  else:
    m = tf.estimator.DNNLinearCombinedRegressor(
	model_dir=model_dir,
        linear_feature_columns=crossed_columns,
        dnn_feature_columns=deep_columns,
        dnn_hidden_units=[512, 64],
	config=run_config)
  return m


parser = argparse.ArgumentParser()

parser.add_argument(
    '--model_dir', type=str, default='/tmp/dog_breed',
    help='Base directory for the model.')

parser.add_argument(
    '--model_type', type=str, default="wide_deep",
    help="Valid model types: {'wide', 'deep', 'wide_deep'}.")

parser.add_argument(
    '--train_epochs', type=int, default=500, help='Number of training epochs.')

parser.add_argument(
    '--epochs_per_eval', type=int, default=500,
    help='The number of training epochs to run between evaluations.')

parser.add_argument(
    '--train_batch_size', type=int, default=500, help='Number of train examples per batch.')

parser.add_argument(
    '--test_batch_size', type=int, default=801, help='Number of test examples per batch.')

_NUM_EXAMPLES = {
    'train': 2313,
    'validation': 801,
}

def input_fn(data_file, num_epochs, shuffle, batch_size):
  """Generate an input function for the Estimator."""
  assert tf.gfile.Exists(data_file), (
      '%s not found. Please make sure you have either run data_download.py or '
      'set both arguments --train_data and --test_data.' % data_file)

  def parse_csv(value):
    print('Parsing', data_file)
    columns = tf.decode_csv(value, record_defaults=_CSV_COLUMN_DEFAULTS)
    features = dict(zip(_CSV_COLUMNS, columns))
    labels = features.pop('Price')
    return features, labels

  # Extract lines from input files using the Dataset API.
  dataset = tf.contrib.data.TextLineDataset(data_file)

  if shuffle:
    dataset = dataset.shuffle(buffer_size=_NUM_EXAMPLES['train'])

  dataset = dataset.map(parse_csv, num_threads=5)

  # We call repeat after shuffling, rather than before, to prevent separate
  # epochs from blending together.
  dataset = dataset.repeat(num_epochs)
  dataset = dataset.batch(batch_size)

  iterator = dataset.make_one_shot_iterator()
  features, labels = iterator.get_next()
  return features, labels


def main(unused_argv):
  # Clean up the model directory if present
  shutil.rmtree(FLAGS.model_dir, ignore_errors=True)
  model = build_estimator(FLAGS.model_dir, FLAGS.model_type)

  # Train and evaluate the model every `FLAGS.epochs_per_eval` epochs.
  for n in range(FLAGS.train_epochs // FLAGS.epochs_per_eval):
    model.train(input_fn=lambda: input_fn(
        "trainset_8020.csv", FLAGS.epochs_per_eval, True, FLAGS.train_batch_size))

    results = model.evaluate(input_fn=lambda: input_fn(
        "testset_8020.csv", 1, False, FLAGS.test_batch_size))
    loss_score = results["average_loss"]	

    # Display evaluation metrics
    print("\nRMS error at epoch", (n + 1) * FLAGS.epochs_per_eval,"is {:.8f}".format(loss_score**0.5))
    print('-' * 60)

if __name__ == '__main__':
  tf.logging.set_verbosity(tf.logging.INFO)
  FLAGS, unparsed = parser.parse_known_args()
  tf.app.run(main=main, argv=[sys.argv[0]] + unparsed)
