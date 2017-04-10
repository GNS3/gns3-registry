FROM python:2.7

RUN pip install jupyter

ADD jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py

RUN mkdir -p /opt/notebooks

EXPOSE 8888

VOLUME /opt/notebooks

CMD jupyter notebook --allow-root --no-browser /opt/notebooks
