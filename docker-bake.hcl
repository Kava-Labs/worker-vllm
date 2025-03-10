variable "PUSH" {
  default = "true"
}

variable "REPOSITORY" {
  default = "kava"
}

variable "BASE_IMAGE_VERSION" {
  default = "v2.0.0-beta.3"
}

variable "BASE_IMAGE_VERSION_SUFFIX" {
  default = "Qwen2.5-VL-7B-Instruct"
}

group "all" {
  targets = ["main"]
}


group "main" {
  targets = ["worker-1210"]
}


target "worker-1210" {
  tags = ["${REPOSITORY}/runpod-worker-vllm:${BASE_IMAGE_VERSION}-cuda12.1.0-${BASE_IMAGE_VERSION_SUFFIX}"]
  context = "."
  dockerfile = "Dockerfile"
  args = {
    BASE_IMAGE_VERSION = "${BASE_IMAGE_VERSION}"
    WORKER_CUDA_VERSION = "12.1.0"
    # Embed model in Docker image
    # MODEL_NAME = "unsloth/Qwen2.5-VL-7B-Instruct-unsloth-bnb-4bit"
    MODEL_NAME = "Qwen/Qwen2.5-VL-7B-Instruct"
  }
  output = ["type=docker,push=${PUSH}"]
}

target "worker-qwq-32b" {
  tags = ["${REPOSITORY}/runpod-worker-vllm:v2.0.0-beta.4-cuda12.1.0-qwq-32b"]
  context = "."
  dockerfile = "Dockerfile"
  args = {
    WORKER_CUDA_VERSION = "12.1.0"
    # Embed model in Docker image
    MODEL_NAME = "unsloth/QwQ-32B-GGUF"
    # Need both GGUF and config.json file
    CUSTOM_ALLOW_PATTERNS= "*Q6_K*,*.json"
    # Get tokenizer files from dynamic repo, GGUF repo doesn't have any
    # tokenizer files
    TOKENIZER_NAME = "unsloth/QwQ-32B-unsloth-bnb-4bit"
  }
  output = ["type=docker,push=${PUSH}"]
}

target "worker-qwq-32b-bnb-4bit" {
  tags = ["${REPOSITORY}/runpod-worker-vllm:v2.0.0-beta.1-cuda12.1.0-qwq-32b-bnb-4bit"]
  context = "."
  dockerfile = "Dockerfile"
  args = {
    WORKER_CUDA_VERSION = "12.1.0"
    # Embed model in Docker image
    MODEL_NAME = "unsloth/QwQ-32B-unsloth-bnb-4bit"
  }
  output = ["type=docker,push=${PUSH}"]
}
