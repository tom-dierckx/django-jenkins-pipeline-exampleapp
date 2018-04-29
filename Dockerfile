 FROM arm32v7/python:3.6.5
 RUN mkdir /code
 WORKDIR /code
 ADD requirements.txt /code/
 RUN pip install -r requirements.txt
 ADD . /code/
 RUN python /code/manage.py makemigrations
 RUN python /code/manage.py migrate
 CMD ["python", "/code/manage.py runserver"]