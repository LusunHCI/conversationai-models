#!/bin/bash

GCS_RESOURCES="gs://kaggle-model-experiments/resources"
DATETIME=`date '+%Y%m%d_%H%M%S'`
MODEL_NAME="keras_gru_attention"
JOB_DIR=gs://kaggle-model-experiments/tf_trainer_runs/${USER}/${MODEL_NAME}/${DATETIME}

gcloud ml-engine jobs submit training tf_trainer_${MODEL_NAME}_${USER}_${DATETIME} \
    --job-dir=${JOB_DIR} \
    --runtime-version=1.8 \
    --module-name="tf_trainer.${MODEL_NAME}.run" \
    --package-path=tf_trainer \
    --region=us-east1 \
    --verbosity=debug \
    --config="tf_trainer/${MODEL_NAME}/hparam_config.yaml" \
    -- \
    --train_path="${GCS_RESOURCES}/toxicity_q42017_train.tfrecord" \
    --validate_path="${GCS_RESOURCES}/toxicity_q42017_validate.tfrecord" \
    --embeddings_path="${GCS_RESOURCES}/glove.6B/glove.6B.300d.txt" \
    --model_dir="${JOB_DIR}/model_dir"
