FROM python:3 :latest
ADD requiremets.txt /
RUN pip install -r /requirements.txt
ADD main.py /main.py
ADD spartan.py /spartan.py
ADD database.py/database.py
ENTRYPOINT ["python", "main.py"]