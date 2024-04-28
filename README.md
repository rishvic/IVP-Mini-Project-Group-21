# IVP Mini Project, Group-21

**Submitted by: Rishvic Pushpakaran (20CS01018), Pranay Borgohain (20EE01015)**

**Supervised by: Dr. Niladri Bihari Puhan**

This repository contains the following:

- Analysis code, written in MATLAB. This computes various metrics, viz. MSE, 
  SNR, PSNR, SSIM, from the model output and plots the same.
- A desktop application written in PyQt6, that allows a user to select an input
  video file, sends the same to the backend processing server, and displays the
  generated upscaled video.
- A flask server that takes requests from the desktop application, and runs the
  model on the requested video file, returning the upscaled video.

## Usage

### Dependencies

To install the dependencies, you need to install Poetry.
```shell
# To install poetry, follow the instruction here:
# https://python-poetry.org/docs/#installation

# Install the required dependencies
poetry install
```

### How to Run

For the frontend, the backend server needs to be running. Before building the
backend image, the mmagic image needs to be generated:
```shell
# Update git submodules
git submodule update --init --recursive

# Build the mmagic docker image.
docker build -t mmagic:1.2.0-mmcv2.1.0-pytorch2.2.2-cuda12.1-cudnn8 mmagic/
```

Build the backend image and run it
```shell
# CD to the supaserver/ directory
cd supaserver

# Run the server via docker compose
docker compose up -d
```

To run the frontend, run it via poetry
```shell
poetry run cgui
```

The frontend needs to know where to place the files for processing. As such,
environment variables `SUPASERVER_INPUT_PATH` and `SUPASERVER_OUTPUT_PATH` need
to be set, similar to the examples mentioned in `.env.example`.
