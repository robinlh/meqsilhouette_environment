# meqsilhouette_environment

To run with docker-compose:
```
docker-compose run meqsilhouette
```

If changes are made to the Dockerfile:
```
docker-compose build
docker-compose run meqsilhouette
```

## Data input/output
Change name of input file in docker-compose.yml environment:
```
- INPUT_FILE=<input_file>
```
Output data must be written to /home/meqsil_user/data in order to reflect on host system
