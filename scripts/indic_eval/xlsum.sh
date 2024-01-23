export CUDA_VISIBLE_DEVICES=0


model_name_or_path="sarvamai/OpenHathi-7B-Hi-v0.1-Base"

echo "evaluating openhathi base on xlsum ..."

# 1-shot
python3 -m eval.xlsum.run_eval \
    --ntrain 1 \
    --max_context_length 512 \
    --save_dir "results/xlsum-hin/openhathi-base-1shot" \
    --model_name_or_path $model_name_or_path \
    --tokenizer_name_or_path $model_name_or_path \
    --eval_batch_size 1


model_name_or_path="ai4bharat/Airavatha"

echo "evaluating airavatha on xlsum ..."

# 1-shot
python3 -m eval.xlsum.run_eval \
    --ntrain 1 \
    --max_context_length 512 \
    --save_dir "results/xlsum-hin/airavatha-1shot" \
    --model_name_or_path $model_name_or_path \
    --tokenizer_name_or_path $model_name_or_path \
    --eval_batch_size 1 \
    --use_chat_format \
    --chat_formatting_function eval.templates.create_prompt_with_tulu_chat_format
