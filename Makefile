build:
	docker build -t sleung124/rstudio-sockeye-tutorial .

run:
	docker run --rm -it -p 8787:8787 -e PASSWORD=123 -v %cd%:/home/rstudio/ sleung124/rstudio-sockeye-tutorial
	
push:
	docker push sleung124/rstudio-sockeye-tutorial:latest
