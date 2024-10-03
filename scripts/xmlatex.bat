@echo off
set str=%*
set "str=%str:\=/%"
set "DOCKER_IMAGE=ghcr.io/ximeraproject/xake2019:v2.1.1"
echo Starting docker %DOCKER_IMAGE% with args  %str%  in directory %cd%.
REM echo docker run --rm --net="host" --mount type=bind,source=%cd%,target=/code %DOCKER_IMAGE% xmlatex %str%
REM docker run --rm --net="host" --mount type=bind,source=%cd%,target=/code %DOCKER_IMAGE% xmlatex %str%
echo docker run --rm --net="host" --mount type=bind,source=%cd%,target=/code %DOCKER_IMAGE% ./scripts/xmlatex.full %str%
docker run --rm --net="host" --mount type=bind,source=%cd%,target=/code %DOCKER_IMAGE% ./scripts/xmlatex.full %str%