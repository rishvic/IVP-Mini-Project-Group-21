from mmagic:1.2.0-mmcv2.1.0-pytorch2.2.2-cuda12.1-cudnn8

RUN pip install flask
COPY ./supaserver.py /usr/local/bin/supaserver
COPY ./run_video_inferer /usr/local/bin/run_video_inferer
CMD ["supaserver"]
