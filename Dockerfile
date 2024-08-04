FROM nogil/python-cuda
RUN mkdir build
WORKDIR /build
COPY . .
RUN pip install -r requirements.txt
EXPOSE 80
WORKDIR /build/app
CMD python -m uvicorn main:app --host 0.0.0.0 --port 80