variable "PUSH" {
  default = "true"
}

variable "REPOSITORY" {
  default = "kava"
}

variable "BASE_IMAGE_VERSION" {
  default = "v2.0.0-beta.2"
}

variable "BASE_IMAGE_VERSION_SUFFIX" {
  default = "Qwen2.5-VL-7B-Instruct-unsloth-bnb-4bit"
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
    MODEL_NAME = "unsloth/Qwen2.5-VL-7B-Instruct-unsloth-bnb-4bit"
  }
  output = ["type=docker,push=${PUSH}"]
}
