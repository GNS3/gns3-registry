FROM python:3.6.1

RUN pip3 install jupyter

ADD jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py

RUN mkdir -p /opt/notebooks

EXPOSE 8888

VOLUME /opt/notebooks

CMD jupyter notebook --allow-root --no-browser /opt/notebooks
