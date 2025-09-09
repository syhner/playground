ARG PYTHON_VERSION=3.12

FROM public.ecr.aws/lambda/python:${PYTHON_VERSION} AS build

# Ensure git and gcc are installed so we can install git based dependencies (such as sst)
RUN dnf update -y && \
  dnf install -y git gcc && \
  dnf clean all

# Copy requirements and install dependencies
COPY requirements.txt ${LAMBDA_TASK_ROOT}/requirements.txt

# Mount the uv image to install dependencies. uv will not be installed in the final image
RUN --mount=from=ghcr.io/astral-sh/uv,source=/uv,target=/bin/uv \
  uv pip install -r requirements.txt --target ${LAMBDA_TASK_ROOT} --system --compile-bytecode

# Perform any steps that you want here e.g. pre-bake in model weights from huggingface to image

FROM public.ecr.aws/lambda/python:${PYTHON_VERSION}

COPY --from=build ${LAMBDA_TASK_ROOT} ${LAMBDA_TASK_ROOT}

COPY . ${LAMBDA_TASK_ROOT}

# No need to configure the handler or entrypoint - SST will do that
