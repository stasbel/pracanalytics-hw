# pracanalytics-hw

Practical analytics course homework at SPbAU 7th term

## Installation

### Dev

I use python and [pipenv](https://docs.pipenv.org/) as a primary tools for 
development. See [Pipfile](Pipfile), [Pipfile.lock](Pipfile.lock), 
[requirements-dev.txt](requirements-dev.txt)(if any) and
[requirements.txt](requirements.txt) for full specification of 
platform, python and dependency packages.  
Basically, to reproduce enviroment, you need to run `pip install -r 
requirements.txt` with certain version of python. However, it is recommended 
to use [virtualenv](https://virtualenv.pypa.io/en/stable/). 

### Makefile

I provide [Makefile](Makefile) for convinient commands implementation.  
Run `make help` for get info on that.

### Prerequisites

* **R**>=3.4.2
* **forecast** package as python wrapper for R stl funcs (is't on PyPi)

## Usage

`make help`

### Tasks

See particular task for more info on that.

## License

[MIT](LICENSE)
