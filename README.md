### Usage
- build docker image locally with the command below
```
docker build -t anaconda3:latest .
```
- run built image (-p XXXX:8888 helps to forward specific port)
```
docker run anaconda3
```
- bind the local directory into a container
```
docker run -d -p 3000:8888 --name anaconda3 -v "$(pwd)"/notebooks:/opt/notebooks anaconda3
```

 
