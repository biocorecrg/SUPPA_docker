# SUPPA_docker
Docker for running [SUPPA](https://github.com/comprna/SUPPA)

## Build image

    docker build -t suppa .

Build arguments are provided for SUPPA

## Run image

    docker run -d -v ~/myshared:/share --name mysuppa suppa tail -f /dev/null

~/myshared is a shared volume used for convenience for placing input and output files

The command above keeps container running under the name mysuppa

Example running command:



