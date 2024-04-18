#!/bin/bash
source /dreambooth_config.sh

cd /diffusers/examples/dreambooth && /opt/venv/bin/accelerate launch train_dreambooth.py \
  --pretrained_model_name_or_path="$MODEL"  \
  --instance_data_dir=/training-data \
  --output_dir=/new-model \
  --instance_prompt="$INSTANCE_PROMPT" \
  --resolution=$RESOLUTION \
  --train_batch_size=$TRAIN_BATCH_SIZE \
  --gradient_accumulation_steps=$GRADIENT_ACCUMULATION_STEPS \
  --learning_rate=$LEARNING_RATE \
  --lr_scheduler="$LR_SCHEDULER" \
  --lr_warmup_steps=$LR_WARMUP_STEPS \
  --lr_power=$LR_POWER \
  --max_train_steps=$MAX_TRAIN_STEPS
