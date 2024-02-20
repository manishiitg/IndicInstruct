#!/bin/bash

source ./scripts/indic_eval/common_vars.sh


for model_name_or_path in "${model_names[@]}"; do
    model_name=${model_name_or_path##*/}
    TASK_NAME=hellaswag
    LANG=en
    
    FOLDER="${FOLDER_BASE}/${TASK_NAME}/${model_name}/${LANG}"
    FILE=$FOLDER/metrics.json
    echo "evaluating $model_name base on $TASK_NAME $LANG ..."

    if echo "$model_name" | grep -qi "awq"; then
        awq_param="--awq"
    else
        awq_param=""
    fi

    check_file_existence=true
    template_format="eval.templates.create_prompt_with_chatml_format"
    if echo "$model_name" | grep -qi "Airavata"; then
        template_format="eval.templates.create_prompt_with_tulu_chat_format"
    fi
    if echo "$model_name" | grep -qi "OpenHathi-7B-Hi-v0.1-Base"; then
        template_format="eval.templates.create_prompt_with_llama2_chat_format"
    fi

    if [ "$check_file_existence" = false ] || [ ! -f "$FILE" ]; then
        python3 -m eval.hellaswag.run_eval_exact \
            --ntrain 0 \
            --save_dir $FOLDER \
            --model_name_or_path $model_name_or_path \
            --tokenizer_name_or_path $model_name_or_path \
            --eval_batch_size 4 \
            --use_chat_format \
            --chat_formatting_function $template_format \
            $awq_param
    else
        cat "$FILE"

    fi
done

# -------------------------------------------------------------
#                       Indic Hellaswag
# -------------------------------------------------------------

for model_name_or_path in "${model_names[@]}"; do
    model_name=${model_name_or_path##*/}
    TASK_NAME=hellaswag-indic
    LANG=hi
    
    FOLDER="${FOLDER_BASE}/${TASK_NAME}/${model_name}/${LANG}"
    FILE=$FOLDER/metrics.json
    echo "evaluating $model_name base on $TASK_NAME $LANG ..."

    if echo "$model_name" | grep -qi "awq"; then
        awq_param="--awq"
    else
        awq_param=""
    fi

    check_file_existence=true
    template_format="eval.templates.create_prompt_with_chatml_format"
    if echo "$model_name" | grep -qi "Airavata"; then
        template_format="eval.templates.create_prompt_with_tulu_chat_format"
        check_file_existence=false
    fi
    if echo "$model_name" | grep -qi "OpenHathi-7B-Hi-v0.1-Base"; then
        template_format="eval.templates.create_prompt_with_llama2_chat_format"
        check_file_existence=false
    fi

    if [ "$check_file_existence" = false ] || [ ! -f "$FILE" ]; then
        # zero-shot
        python3 -m eval.hellaswag.run_eval_exact \
            --ntrain 0 \
            --dataset "Thanmay/hellaswag-translated" \
            --save_dir $FOLDER \
            --model_name_or_path $model_name_or_path \
            --tokenizer_name_or_path $model_name_or_path \
            --eval_batch_size 4 \
            --use_chat_format \
            --chat_formatting_function $template_format \
            $awq_param
    
    else
        cat "$FILE"
    fi
done